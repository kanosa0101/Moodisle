/// 心屿页：可拖动的世界场景（固定逻辑视口 + 相机裁切）。
///
/// 原版做法（render.js + styles.css）：
///   · canvas 固定逻辑视口 428×300，CSS 等比缩放适配屏幕；
///   · 相机 cam ∈ [0, WORLD-视口]，拖拽平移，点击 = 视口坐标 + 相机；
///   · 背景从 1200×800 世界图里裁出相机窗口绘制。
/// Flutter 对应：FittedBox 包一个固定 428×300 的场景，全部坐标按原版语义工作。
library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../application/game_controller.dart';
import '../../domain/config/game_config.dart';
import '../../domain/config/roam_config.dart';
import '../../domain/engine/season_engine.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/pet.dart';
import '../../domain/entities/task.dart';
import '../../domain/engine/eco_sim.dart';
import '../../shared/audio/moodisle_audio_scope.dart';
import '../../shared/audio/moodisle_audio_service.dart';
import '../../shared/theme/tokens.dart';
import '../widgets/game_icons.dart';
import '../widgets/pet_sprite.dart';

/// 逻辑视口（与原版 canvas width/height 一致）。
const double kViewW = 428;
const double kViewH = 300;

class IslandPage extends StatefulWidget {
  final GameController controller;
  const IslandPage({super.key, required this.controller});

  @override
  State<IslandPage> createState() => _IslandPageState();
}

class _IslandPageState extends State<IslandPage>
    with SingleTickerProviderStateMixin {
  double _camX = 0;
  double _camY = 0;
  Offset _lastFocal = Offset.zero;
  DateTime _lastEcoTick = DateTime.now();
  String? _loadedMapPath;
  ui.Image? _mapImage;
  late final AnimationController _particleCtrl;
  late final List<({double x, double y, double v, double s, double ph})>
      _particles;

  @override
  void initState() {
    super.initState();
    _particleCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 12))
          ..repeat();
    _particleCtrl.addListener(_tickEco);
    final rng = Random(7);
    _particles = List.generate(28, (_) {
      final v = 0.4 + rng.nextDouble() * 0.6;
      return (
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        v: v,
        s: 1.6 + rng.nextDouble() * 2.6,
        ph: rng.nextDouble() * 6.28,
      );
    });
    _initCamera();
    unawaited(_loadMapImage());
  }

  @override
  void dispose() {
    _particleCtrl.removeListener(_tickEco);
    _particleCtrl.dispose();
    _mapImage?.dispose();
    super.dispose();
  }

  void _tickEco() {
    final now = DateTime.now();
    final dt = (now.difference(_lastEcoTick).inMicroseconds / 1000000)
        .clamp(0.0, 0.1)
        .toDouble();
    _lastEcoTick = now;
    if (dt > 0) widget.controller.eco.tick(dt);
  }

  Future<void> _loadMapImage() async {
    final path = _mapAssetPath();
    _loadedMapPath = path;
    try {
      final data = await rootBundle.load(path);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final image = (await codec.getNextFrame()).image;
      codec.dispose();
      if (!mounted || _loadedMapPath != path) {
        image.dispose();
        return;
      }
      final old = _mapImage;
      setState(() => _mapImage = image);
      old?.dispose();
    } catch (_) {
      if (mounted) setState(() => _mapImage = null);
    }
  }

  void _initCamera() {
    _camX = (kWorldW - kViewW) / 2;
    _camY = (kWorldH - kViewH) / 2;
  }

  void _clampCam() {
    _camX = _camX.clamp(0.0, kWorldW - kViewW);
    _camY = _camY.clamp(0.0, kWorldH - kViewH);
  }

  @override
  Widget build(BuildContext context) {
    // 对齐原版 view-island：心岛面板(428:300) → 提示行 → 装扮商店，整页滚动
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _islandPanel(),
        _islandTip(),
        const SizedBox(height: 12),
        _DecorShopPanel(controller: widget.controller),
      ],
    );
  }

  /// 心岛面板：AspectRatio(428:300) 场景 + HUD 覆盖层（对齐原版 island-wrap）。
  Widget _islandPanel() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MoodisleColors.line, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFE3C98E), offset: Offset(0, 6), blurRadius: 0),
        ],
        color: const Color(0xFFBFE0C2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: kViewW / kViewH,
          child: Stack(children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: (d) => _lastFocal = d.localFocalPoint,
                onScaleUpdate: (d) {
                  // focal 差值驱动平移（与原版拖拽一致）
                  setState(() {
                    _camX -= d.localFocalPoint.dx - _lastFocal.dx;
                    _camY -= d.localFocalPoint.dy - _lastFocal.dy;
                    _lastFocal = d.localFocalPoint;
                    _clampCam();
                  });
                },
                onTapUp: (d) => _onTap(context, d.localPosition.dx + _camX,
                    d.localPosition.dy + _camY),
                child: AnimatedBuilder(
                    animation:
                        Listenable.merge([widget.controller, _particleCtrl]),
                    builder: (context, _) => _buildScene()),
              ),
            ),
            // HUD 覆盖层（对齐原版 island-hud）
            Positioned(
              left: 10,
              top: 10,
              right: 10,
              child: IgnorePointer(
                child: AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context, _) {
                      final s = widget.controller.state;
                      return Row(children: [
                        _pill('心屿放晴 ${s.clearing.round()}%'),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: s.clearing / 100,
                              minHeight: 7,
                              backgroundColor: const Color(0x80FFFFFF),
                              color: MoodisleColors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _pill('当季 ${seasonOf(DateTime.now()).cn}'),
                      ]);
                    }),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xEFFFFAF0),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: MoodisleColors.line),
        ),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF5A3E22))),
      );

  /// 提示行（对齐原版 island-tip，随状态切换文案）。
  Widget _islandTip() {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final s = widget.controller.state;
          final pend =
              s.tasks.where((t) => t.status == TaskStatus.pending).length;
          final tip = s.tasks.isEmpty
              ? '心屿还很安静。去「待办」录入今天要做的事，召唤第一只天气精灵吧。'
              : pend > 0
                  ? '心屿上还有 $pend 只精灵在雾中游荡，完成对应待办即可安抚收服它们。'
                  : '太棒了！今天的精灵都被安抚啦，心屿放晴 ${s.clearing.round()}%。';
          return Padding(
            padding: const EdgeInsets.fromLTRB(2, 12, 2, 0),
            child: Text(tip,
                style: const TextStyle(
                    fontSize: 12.5, color: MoodisleColors.ink2, height: 1.7)),
          );
        });
  }

  Widget _buildScene() {
    final s = widget.controller.state;
    final cam = Offset(_camX, _camY);
    final children = <Widget>[
      // ① 背景层：按原版心屿视口从世界地图的相机源区域直接裁切。
      Positioned.fill(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _mapImage == null
                ? _WorldFallbackPainter(cam: cam)
                : _MapImagePainter(image: _mapImage!, cam: cam),
          ),
        ),
      ),
      // ② 装饰摆件（世界坐标换算为视口坐标，与角色共用相机偏移）
      ..._decorWidgets(s),
      // ③ actor（视口空间：世界坐标 - 相机），y 排序遮挡
      for (final (a, sx, sy) in _visibleActors()) _actorWidget(a, sx, sy),
      // ④ 情绪气候光照层（视口空间）
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: _ClimateLightPainter(
              fog: s.climate.fog,
              clearing: s.clearing,
            ),
          ),
        ),
      ),
      // ⑤ 四季飘落粒子（视口空间）
      Positioned.fill(
        child: RepaintBoundary(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _SeasonParticlePainter(
                progress: _particleCtrl.value,
                particles: _particles,
                season: seasonOf(DateTime.now()),
              ),
            ),
          ),
        ),
      ),
    ];
    return Stack(children: children);
  }

  /// 视口内可见的 actor（世界坐标 → 视口坐标）。
  List<(IslandActor, double, double)> _visibleActors() {
    final out = <(IslandActor, double, double)>[];
    for (final a in widget.controller.eco.actors) {
      final sx = a.x - _camX;
      final sy = a.y - _camY;
      if (sx < -40 || sy < -50 || sx > kViewW + 40 || sy > kViewH + 50) {
        continue;
      }
      out.add((a, sx, sy));
    }
    out.sort((p, q) => p.$1.y.compareTo(q.$1.y)); // y 排序遮挡
    return out;
  }

  Widget _actorWidget(IslandActor a, double sx, double sy) {
    final rec = a.wild ? null : widget.controller.state.pets[a.emotion];
    final dir = a.facing == 0
        ? 'front'
        : (math.cos(a.facing) < -0.3
            ? 'left'
            : (math.sin(a.facing) < -0.5 ? 'back' : 'front'));
    return Positioned(
      left: sx - 18,
      top: sy - 40,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _tapActor(a),
        child: Column(children: [
          if (a.emote != null && a.emoteT > 0)
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                  color: MoodisleColors.paper,
                  shape: BoxShape.circle,
                  border: Border.all(color: MoodisleColors.line)),
              child: UiStickerIcon('emotes/${_emoteAsset(a.emote)}', size: 16),
            ),
          Stack(clipBehavior: Clip.none, children: [
            PetSprite(
              emotion: a.emotion,
              stage: a.wild ? PetStage.clear : (rec?.stage ?? PetStage.clear),
              branch: rec?.branch,
              size: 36,
              wild: a.wild,
              dir: dir,
            ),
            if (!a.wild && widget.controller.state.roam.pendant != null)
              Positioned(
                right: -4,
                top: -4,
                child: SouvenirIcon(widget.controller.state.roam.pendant!,
                    size: 14),
              ),
          ]),
        ]),
      ),
    );
  }

  List<Widget> _decorWidgets(GameState state) => [
        for (final entry in _decorAnchors.entries)
          if ((state.roam.souvenirs[entry.key] ?? 0) > 0 &&
              kSouvenirs[entry.key]?.pendant == false)
            Positioned(
              left: entry.value.$1 * kWorldW - _camX - 18,
              top: entry.value.$2 * kWorldH - _camY - 18,
              child: IgnorePointer(
                child: SouvenirIcon(entry.key, size: 36),
              ),
            ),
      ];

  String _emoteAsset(String? emote) => switch (emote) {
        'heart' => 'heart',
        'music' => 'music',
        'happy' => 'happy',
        'leaf' => 'leaf',
        'star' || 'sparkle' => 'sparkle',
        _ => 'heart',
      };

  /// 当季昼夜地图资产路径（18:00–6:00 为夜）。
  String _mapAssetPath() {
    final now = DateTime.now();
    final night = now.hour >= 18 || now.hour < 6;
    return 'assets/island/map_${seasonOf(now).id}_${night ? 'night' : 'day'}.png';
  }

  void _tapActor(IslandActor a) {
    MoodisleAudioScope.maybeOf(context)?.play([MoodisleSound.glance]);
    final zone = a.biome.cn;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(a.wild
            ? '${a.emotion.petCn} 还在$zone游荡，完成对应待办来安抚它吧'
            : '${a.emotion.petCn} 正在$zone快活地生活')));
    widget.controller.eco.tap(a.x, a.y);
  }

  void _onTap(BuildContext context, double wx, double wy) {
    widget.controller.eco.tap(wx, wy);
  }
}

const Map<String, (double, double)> _decorAnchors = {
  'windmillLamp': (0.62, 0.22),
  'rainGauge': (0.16, 0.44),
  'convectionFire': (0.62, 0.82),
  'auroraVeil': (0.84, 0.40),
  'breeze_chime_stand': (0.70, 0.30),
  'travel_mailbox': (0.24, 0.60),
  'warm_night_campfire': (0.55, 0.86),
  'star_wish_swing': (0.42, 0.24),
  'lotus_boat': (0.30, 0.34),
  'fog_lamp_ornament': (0.68, 0.34),
  'shell_wind_chime': (0.80, 0.72),
  'weather_house': (0.20, 0.72),
  'rainbow_arch': (0.50, 0.16),
  'meteor_wishing_pool': (0.40, 0.88),
  'aurora_curtain': (0.90, 0.16),
  'four_seasons_flower_clock': (0.10, 0.20),
};

/// 情绪气候光照层：心雾渐退 → 破晓暖光 → 极光带（视口空间）。
class _ClimateLightPainter extends CustomPainter {
  final double fog;
  final double clearing;
  _ClimateLightPainter({required this.fog, required this.clearing});

  @override
  void paint(Canvas canvas, Size size) {
    if (fog > 5) {
      final a = (fog / 100 * 0.5).clamp(0.0, 0.5);
      canvas.drawRect(Offset.zero & size,
          Paint()..color = Color.fromRGBO(196, 204, 224, a));
    }
    if (clearing > 40) {
      final warm = ((clearing - 40) / 35).clamp(0.0, 1.0);
      final rect =
          Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45);
      final paint = Paint()
        ..shader = ui.Gradient.linear(
          rect.topCenter,
          rect.bottomCenter,
          [
            const Color.fromRGBO(255, 214, 140, 0),
            Color.fromRGBO(255, 214, 140, 0.38 * warm),
          ],
        );
      canvas.drawRect(rect, paint);
    }
    if (clearing > 75) {
      final au = ((clearing - 75) / 25).clamp(0.0, 1.0);
      final bands = [
        const Color.fromRGBO(120, 240, 190, 1),
        const Color.fromRGBO(150, 180, 255, 1),
        const Color.fromRGBO(220, 150, 255, 1),
      ];
      canvas.save();
      canvas.clipRect(Offset.zero & size);
      for (var k = 0; k < bands.length; k++) {
        final paint = Paint()
          ..color = bands[k].withValues(alpha: 0.10 * au)
          ..blendMode = BlendMode.screen
          ..strokeWidth = 10
          ..style = PaintingStyle.stroke;
        final path = Path();
        for (var x = 0.0; x <= size.width; x += 10) {
          final y =
              size.height * 0.14 + math.sin(x * 0.02 + k * 1.8) * 9 + k * 9;
          if (x == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        canvas.drawPath(path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ClimateLightPainter old) =>
      old.fog != fog || old.clearing != clearing;
}

/// 四季飘落粒子（樱/萤/叶/雪；视口空间）。
class _SeasonParticlePainter extends CustomPainter {
  final double progress;
  final List<({double x, double y, double v, double s, double ph})> particles;
  final SeasonDef season;
  _SeasonParticlePainter(
      {required this.progress, required this.particles, required this.season});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final x = p.x * size.width + math.sin(progress * 6.28 + p.ph) * 10;
      double y;
      Color c;
      if (season.particle == 'firefly') {
        y = (p.y * size.height + math.sin(progress * 6.28 + p.ph) * 24) %
            size.height;
        c = const Color(0xFFFFF6A8);
      } else {
        y = ((p.y + progress * p.v) % 1.0) * size.height;
        c = switch (season.particle) {
          'sakura' => const Color(0xFFFFC6DD),
          'leaf' => const Color(0xFFE08A3C),
          _ => const Color(0xFFFFFFFF),
        };
      }
      canvas.drawCircle(
          Offset(x % size.width, y),
          p.s,
          Paint()
            ..color =
                c.withValues(alpha: season.particle == 'firefly' ? 0.75 : 0.8));
    }
  }

  @override
  bool shouldRepaint(_SeasonParticlePainter old) => old.progress != progress;
}

/// 世界空间程序化底图（正式地图资产缺失时的回退；含海/岛/五区/区名）。
class _WorldFallbackPainter extends CustomPainter {
  final Offset cam;
  _WorldFallbackPainter({required this.cam});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(-cam.dx, -cam.dy);
    canvas.drawRect(const Rect.fromLTWH(0, 0, kWorldW, kWorldH),
        Paint()..color = const Color(0xFF9BD4E8));
    const islandRect = Rect.fromLTWH(60, 60, kWorldW - 120, kWorldH - 120);
    canvas.drawOval(islandRect, Paint()..color = const Color(0xFFF2DCA0));
    canvas.drawOval(
        islandRect.deflate(34), Paint()..color = const Color(0xFF9FDFB2));
    for (final b in Biome.values) {
      final rect = Rect.fromCenter(
        center: Offset(b.cx * kWorldW, b.cy * kWorldH),
        width: b.rx * 2 * kWorldW,
        height: b.ry * 2 * kWorldH,
      );
      canvas.drawOval(
          rect, Paint()..color = biomeColor(b).withValues(alpha: 0.75));
      final tp = TextPainter(
        text: TextSpan(
            text: b.cn,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5A3E22).withValues(alpha: 0.45))),
      )
        ..textDirection = TextDirection.ltr
        ..layout();
      tp.paint(canvas, rect.center - Offset(tp.width / 2, tp.height / 2));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WorldFallbackPainter old) => old.cam != cam;
}

class _MapImagePainter extends CustomPainter {
  final ui.Image image;
  final Offset cam;
  const _MapImagePainter({required this.image, required this.cam});

  @override
  void paint(Canvas canvas, Size size) {
    final sx = image.width / kWorldW;
    final sy = image.height / kWorldH;
    final source = Rect.fromLTWH(
        cam.dx * sx, cam.dy * sy, size.width * sx, size.height * sy);
    canvas.drawImageRect(
      image,
      source,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.low,
    );
  }

  @override
  bool shouldRepaint(_MapImagePainter old) =>
      old.image != image || old.cam != cam;
}

/// 装扮商店（对齐原版 M6 面板；只卖外观，晴晶/星屑计价）。
class _DecorShopPanel extends StatelessWidget {
  final GameController controller;
  const _DecorShopPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final s = controller.state;
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: PaperPanel.decoration(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                UiStickerIcon('sections/store', size: 20),
                SizedBox(width: 5),
                Text('装扮商店',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF5A3E22))),
              ]),
              const SizedBox(height: 4),
              const Text('用回廊与专注收集的晴晶、星屑装点心屿。装饰只改变外观，不影响任何数值，纯粹为了更治愈的小岛。',
                  style: TextStyle(
                      fontSize: 11.5, color: MoodisleColors.ink2, height: 1.6)),
              const SizedBox(height: 8),
              Row(children: [
                _wallet(ItemId.sunnyCrystal,
                    '晴晶 ×${s.items[ItemId.sunnyCrystal] ?? 0}'),
                const SizedBox(width: 6),
                _wallet(
                    ItemId.stardust, '星屑 ×${s.items[ItemId.stardust] ?? 0}'),
              ]),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.94,
                children: [
                  for (final item in kDecorShop)
                    _DecorCard(controller: controller, item: item),
                ],
              ),
            ]),
          );
        });
  }

  Widget _wallet(ItemId item, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4D6),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: MoodisleColors.line),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ItemIcon(item, size: 15),
          const SizedBox(width: 3),
          Text(text,
              style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5A3E22))),
        ]),
      );
}

class _DecorCard extends StatelessWidget {
  final GameController controller;
  final DecorShopItem item;
  const _DecorCard({required this.controller, required this.item});

  @override
  Widget build(BuildContext context) {
    final s = controller.state;
    final def = kSouvenirs[item.souvenirId]!;
    final owned = (s.roam.souvenirs[item.souvenirId] ?? 0) > 0;
    final afford = (s.items[ItemId.sunnyCrystal] ?? 0) >= item.costSunny &&
        (s.items[ItemId.stardust] ?? 0) >= item.costStardust;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: owned ? MoodisleColors.green : const Color(0xFFEFE1C2)),
      ),
      child: Column(children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: SouvenirIcon(
                  item.souvenirId,
                  size: constraints.biggest.shortestSide * 0.88,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(def.cn,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
        if (owned)
          const Text('已摆上心屿 ✓',
              style: TextStyle(fontSize: 9.5, color: MoodisleColors.ink2))
        else
          Row(mainAxisSize: MainAxisSize.min, children: [
            const ItemIcon(ItemId.sunnyCrystal, size: 13),
            Text('×${item.costSunny}',
                style:
                    const TextStyle(fontSize: 9.5, color: MoodisleColors.ink2)),
            if (item.costStardust > 0) ...[
              const SizedBox(width: 3),
              const ItemIcon(ItemId.stardust, size: 13),
              Text('×${item.costStardust}',
                  style: const TextStyle(
                      fontSize: 9.5, color: MoodisleColors.ink2)),
            ],
          ]),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: owned || !afford
                ? null
                : () => controller.buyDecor(item.souvenirId),
            style: FilledButton.styleFrom(
                backgroundColor: MoodisleColors.orange,
                padding: const EdgeInsets.symmetric(vertical: 4)),
            child: Text(owned ? '已拥有' : '购买',
                style: const TextStyle(fontSize: 11)),
          ),
        ),
      ]),
    );
  }
}
