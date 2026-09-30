/// 回廊页：区域列表 → 迷宫运行（画布 + 方向垫 + 撤销重开 + 结算）。
library;

import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyEvent, KeyRepeatEvent, LogicalKeyboardKey, rootBundle;

import '../../application/game_controller.dart';
import '../../domain/engine/maze/maze_models.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/events/game_events.dart';
import '../../domain/engine/maze/maze_runtime.dart';
import '../../domain/engine/maze/zone_tuning.dart';
import '../../shared/audio/moodisle_audio_scope.dart';
import '../../shared/audio/moodisle_audio_service.dart';
import '../../shared/theme/tokens.dart';
import '../widgets/game_icons.dart';
import '../widgets/pet_sprite.dart' show petAssetPath, PetSprite;

class MazePage extends StatelessWidget {
  final GameController controller;
  const MazePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final run = controller.mazeRun;
          if (run != null) {
            return _MazeBoardPage(controller: controller, run: run);
          }
          return _ZoneList(controller: controller);
        });
  }
}

class _ZoneList extends StatelessWidget {
  final GameController controller;
  const _ZoneList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final runs = controller.state.stats.mazeRuns;
    return ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: PaperPanel.decoration(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.explore_rounded,
                    color: MoodisleColors.orange, size: 20),
                SizedBox(width: 5),
                Text('心绪回廊',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
              ]),
              const SizedBox(height: 4),
              const Text('派伙伴进入该情绪的回廊清理心结。等级吞噬：我方 ≥ 怪即必胜并吞并其等级；完全信息、可撤销，先想后走。',
                  style: TextStyle(
                      fontSize: 11.5, color: MoodisleColors.ink2, height: 1.5)),
              const SizedBox(height: 8),
              Text(
                  '行动力 ${controller.state.energy} · 今日剩余 ${controller.dailyMazeLeft()} 次 · 累计探索 $runs 次',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                  controller.state.companion != null
                      ? '出战伙伴：${controller.state.companion!.petCn}'
                      : controller.state.pets.isEmpty
                          ? '先去待办收服一位伙伴，再回来选择出战伙伴'
                          : '先在下方选择一位出战伙伴',
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: controller.state.companion == null
                          ? Colors.redAccent
                          : const Color(0xFF2EA05F))),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final e in controller.state.pets.keys)
                    InkWell(
                      onTap: () => controller.setCompanion(e),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: controller.state.companion == e
                                  ? MoodisleColors.orange
                                  : const Color(0xFFEFE1C2),
                              width: controller.state.companion == e ? 2 : 1),
                        ),
                        child: Column(children: [
                          PetSprite(
                              emotion: e,
                              stage: controller.state.pets[e]!.stage,
                              branch: controller.state.pets[e]!.branch,
                              size: 30),
                          Text(e.petCn, style: const TextStyle(fontSize: 9)),
                        ]),
                      ),
                    ),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < kZoneTuning.length; i++)
            _ZoneRow(
                controller: controller,
                zoneIndex: i,
                unlocked: runs >= kZoneUnlockExp[i]),
        ]);
  }
}

class _ZoneRow extends StatelessWidget {
  final GameController controller;
  final int zoneIndex;
  final bool unlocked;
  const _ZoneRow(
      {required this.controller,
      required this.zoneIndex,
      required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final t = kZoneTuning[zoneIndex];
    final emotion = kZoneEmotions[zoneIndex];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: unlocked ? const Color(0xFFEFE1C2) : const Color(0xFFEFE1C2),
            width: 1),
      ),
      child: Row(children: [
        Opacity(
          opacity: unlocked ? 1 : 0.45,
          child: PetSprite(emotion: emotion, size: 40, wild: !unlocked),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                '${unlocked ? kZoneNames[zoneIndex] : "未解锁 · ${kZoneNames[zoneIndex]}"}'
                ' · ${'★' * t.tier}${'☆' * (3 - t.tier)}',
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w800)),
            Text(
              unlocked
                  ? '${t.size}×${t.size} · ${t.floorCount} 层 · 陷阱${t.traps} 神龛${t.shrines} 锁门${t.keyDoors}'
                  : '累计探索 ${kZoneUnlockExp[zoneIndex]} 次解锁'
                      '（当前 ${controller.state.stats.mazeRuns}）',
              style:
                  const TextStyle(fontSize: 10.5, color: MoodisleColors.ink2),
            ),
          ]),
        ),
        FilledButton(
          onPressed: unlocked ? () => _enter(context) : null,
          style: FilledButton.styleFrom(backgroundColor: MoodisleColors.orange),
          child: const Text('进入', style: TextStyle(fontSize: 12.5)),
        ),
      ]),
    );
  }

  void _enter(BuildContext context) {
    final ev = controller.startMaze(zoneIndex);
    if (controller.mazeRun == null) {
      // 未进入（解锁/伙伴/次数/行动力任一门槛未过）→ 展示最后一条提示
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              controller.state.pets.isEmpty
                  ? '先去「待办」完成任务并收服一位伙伴，再回来选择出战伙伴。'
                  : ev.whereType<GameNotice>().isEmpty
                      ? '暂时无法进入'
                      : ev.whereType<GameNotice>().map((n) => n.text).join('；'),
              style: const TextStyle(fontSize: 12))));
    }
  }
}

class _MazeBoardPage extends StatefulWidget {
  final GameController controller;
  final MazeRun run;
  const _MazeBoardPage({required this.controller, required this.run});

  @override
  State<_MazeBoardPage> createState() => _MazeBoardPageState();
}

class _MazeBoardPageState extends State<_MazeBoardPage> {
  GameController get controller => widget.controller;
  MazeRun get run => widget.run;

  final Map<String, ui.Image> _tileImages = {};
  ui.Image? _foeImage;
  ui.Image? _bossImage;
  ui.Image? _petImage;
  ui.Image? _powerImage;
  final FocusNode _keyboardFocus = FocusNode(debugLabel: 'maze_board');
  bool _loaded = false;

  @override
  void dispose() {
    _keyboardFocus.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _preload();
  }

  Future<void> _preload() async {
    for (final kind in const [
      'floor',
      'wall',
      'start',
      'exit',
      'portal',
      'door',
      'trap',
      'shrine',
      'warp',
      'key',
      'lantern',
    ]) {
      final img = await _loadUiImage('assets/maze/tile_$kind.png');
      if (img != null && mounted) {
        setState(() => _tileImages[kind] = img);
      }
    }
    final zoneIndex = widget.run.maze.zoneIndex;
    final foe = await _loadUiImage(
        'assets/maze/foes/${kZoneEmotions[zoneIndex].name}.png');
    if (foe != null && mounted) setState(() => _foeImage = foe);
    final boss =
        await _loadUiImage('assets/bosses/${_bossFiles[zoneIndex]}.png');
    if (boss != null && mounted) setState(() => _bossImage = boss);
    // run 通过 getter 访问（见上方 run getter）
    final rec = widget.controller.state.pets[widget.controller.state.companion];
    if (rec != null) {
      final path = petAssetPath(rec.emotion, rec.stage, rec.branch, 'front');
      final img = await _loadUiImage(path);
      if (img != null && mounted) setState(() => _petImage = img);
    }
    _powerImage = await _loadUiImage('assets/items/icons/star_badge.png');
    if (mounted) setState(() {});
  }

  Future<ui.Image?> _loadUiImage(String path) async {
    try {
      final data = await rootBundle.load(path);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (_) {
      return null; // 资产缺失 → 程序化回退
    }
  }

  @override
  Widget build(BuildContext context) {
    final run = widget.run;
    final controller = widget.controller;
    final f = run.floor;
    return Focus(
        focusNode: _keyboardFocus,
        autofocus: true,
        onKeyEvent: (node, event) => _onKeyEvent(context, event),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: PaperPanel.decoration(),
              child: Row(children: [
                Text(
                    '${kZoneNames[run.maze.zoneIndex]} · 第 ${run.fi + 1}/${run.maze.floors.length} 层',
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w900)),
                const Spacer(),
                _pill('等级 ${run.level}'),
                const SizedBox(width: 6),
                if (run.keys > 0) _pill('钥匙 ×${run.keys}'),
                const SizedBox(width: 6),
                _pill('步数 ${run.steps}'),
              ]),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(builder: (context, cons) {
                final boardSize = cons.maxWidth < cons.maxHeight
                    ? cons.maxWidth
                    : cons.maxHeight;
                final cell = boardSize / (f.w > f.h ? f.w : f.h);
                return GestureDetector(
                  onTapDown: (_) => _keyboardFocus.requestFocus(),
                  onTapUp: (d) {
                    final cx = (d.localPosition.dx / cell).floor();
                    final cy = (d.localPosition.dy / cell).floor();
                    _doClick(context, cx, cy);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: MoodisleColors.line, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomPaint(
                        size: Size(cell * f.w, cell * f.h),
                        painter: _MazePainter(
                            run: run,
                            cell: cell,
                            controller: controller,
                            tileImages: Map.of(_tileImages),
                            foeImage: _foeImage,
                            bossImage: _bossImage,
                            petImage: _petImage,
                            powerImage: _powerImage),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              // 方向垫
              Column(children: [
                _dirBtn(context, Icons.arrow_upward_rounded,
                    () => _doStep(context, 0, -1)),
                Row(children: [
                  _dirBtn(context, Icons.arrow_back_rounded,
                      () => _doStep(context, -1, 0)),
                  const SizedBox(width: 34),
                  _dirBtn(context, Icons.arrow_forward_rounded,
                      () => _doStep(context, 1, 0)),
                ]),
                _dirBtn(context, Icons.arrow_downward_rounded,
                    () => _doStep(context, 0, 1)),
              ]),
              const Spacer(),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                FilledButton(
                  onPressed: () => controller.mazeUndo(),
                  style: FilledButton.styleFrom(
                      backgroundColor: MoodisleColors.green),
                  child: const Text('撤销', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: 6),
                FilledButton(
                  onPressed: () => controller.mazeRestart(),
                  style: FilledButton.styleFrom(
                      backgroundColor: MoodisleColors.orange),
                  child: const Text('重开本层', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: () => _leave(context),
                  child: const Text('离开', style: TextStyle(fontSize: 12)),
                ),
              ]),
            ]),
          ),
        ]));
  }

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4D6),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: MoodisleColors.line),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
      );

  Widget _dirBtn(BuildContext context, IconData arrow, VoidCallback onTap) =>
      InkWell(
        onTap: () {
          _keyboardFocus.requestFocus();
          onTap();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 44,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4D6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MoodisleColors.line),
          ),
          child: Icon(arrow, size: 18, color: MoodisleColors.ink),
        ),
      );

  KeyEventResult _onKeyEvent(BuildContext context, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    late final int dx;
    late final int dy;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyW:
        dx = 0;
        dy = -1;
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.keyS:
        dx = 0;
        dy = 1;
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyA:
        dx = -1;
        dy = 0;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyD:
        dx = 1;
        dy = 0;
      default:
        return KeyEventResult.ignored;
    }
    _doStep(context, dx, dy);
    return KeyEventResult.handled;
  }

  void _toast(BuildContext context, List<MazeRunEvent> events) {
    if (events.isEmpty) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 900),
        content: Text(events.map((e) => e.text).join(' · '),
            style: const TextStyle(fontSize: 12))));
    if (controller.mazeRun != null && !controller.mazeRun!.active) {
      _showResult(context);
    }
  }

  void _doClick(BuildContext context, int cx, int cy) {
    final pickedBefore = controller.mazeRun?.picked.length ?? 0;
    final lanternsBefore = controller.mazeRun?.lanterns ?? 0;
    final events = controller.mazeClick(cx, cy);
    _playMazeOutcome(context, events, pickedBefore, lanternsBefore);
    _toast(context, events);
  }

  void _doStep(BuildContext context, int dx, int dy) {
    final pickedBefore = controller.mazeRun?.picked.length ?? 0;
    final lanternsBefore = controller.mazeRun?.lanterns ?? 0;
    final events = controller.mazeStep(dx, dy);
    _playMazeOutcome(context, events, pickedBefore, lanternsBefore);
    _toast(context, events);
  }

  void _playMazeOutcome(
    BuildContext context,
    List<MazeRunEvent> events,
    int pickedBefore,
    int lanternsBefore,
  ) {
    final run = controller.mazeRun;
    final pickedAfter = run?.picked.length ?? 0;
    final lanternsAfter = run?.lanterns ?? 0;
    final sound = events.any((event) => event.isError)
        ? MoodisleSound.error
        : lanternsAfter > lanternsBefore
            ? MoodisleSound.light
            : pickedAfter > pickedBefore
                ? MoodisleSound.loot
                : null;
    if (sound != null) {
      MoodisleAudioScope.maybeOf(context)?.play([sound]);
    }
  }

  void _leave(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('离开回廊？'),
        content: const Text('本次进度将放弃（行动力已消耗）。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('继续探索')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.abandonMaze();
            },
            child: const Text('离开'),
          ),
        ],
      ),
    );
  }

  static const List<String> _bossFiles = [
    'shocking_storm_knot',
    'stagnant_rain_knot',
    'lost_fog_knot',
    'heavy_twilight_mist_knot',
    'spiral_cloud_knot',
    'chaotic_current_knot',
    'scattered_wind_knot',
    'strict_frost_knot',
    'misplaced_star_knot',
    'shy_sunset_knot',
  ];

  void _showResult(BuildContext context) {
    final run = controller.mazeRun!;
    final settlement = run.settlement!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: MoodisleColors.paper,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MoodisleRadii.xl)),
        title:
            Text(run.bossBeaten ? '通关！' : '安然归来', textAlign: TextAlign.center),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          if (run.bossBeaten)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Image.asset(
                'assets/bosses/${_bossFiles[run.maze.zoneIndex]}.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          Text(
              '${kZoneNames[run.maze.zoneIndex]} · 战至 Lv.${run.level} · '
              '击败 ${run.kills} 怪 · ${run.steps} 步',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: MoodisleColors.ink2)),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: [
              for (final e in settlement.loot.entries)
                Column(children: [
                  ItemIcon(e.key, size: 28),
                  Text('×${e.value}',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w800)),
                ]),
            ],
          ),
          if (settlement.perfect)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('完美通关：全收集 · 未撤销',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
            ),
        ]),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.finishMaze();
            },
            style:
                FilledButton.styleFrom(backgroundColor: MoodisleColors.orange),
            child: const Text('收下战利品'),
          ),
        ],
      ),
    );
  }
}

class _MazePainter extends CustomPainter {
  final MazeRun run;
  final double cell;
  final GameController controller;
  final Map<String, ui.Image> tileImages;
  final ui.Image? foeImage;
  final ui.Image? bossImage;
  final ui.Image? petImage;
  final ui.Image? powerImage;
  _MazePainter(
      {required this.run,
      required this.cell,
      required this.controller,
      this.tileImages = const {},
      this.foeImage,
      this.bossImage,
      this.petImage,
      this.powerImage});

  @override
  void paint(Canvas canvas, Size size) {
    final f = run.floor;
    final fogMode = f.items.values
        .any((i) => i.kind == MazeItemKind.lantern); // 该层带提灯 → 迷雾模式
    final vision = 2 + run.lanterns;
    final reach = run.reachable(visionRadius: vision, fogMode: fogMode);
    // 地板
    final floorPaint = Paint()..color = const Color(0xFFEFE2C0);
    final wallPaint = Paint()..color = const Color(0xFF8A6B4F);
    for (var y = 0; y < f.h; y++) {
      for (var x = 0; x < f.w; x++) {
        final rect = Rect.fromLTWH(x * cell, y * cell, cell, cell);
        final k = cellKey(x, y);
        final t = f.tileAt(x, y);
        final isWall = t == MazeTile.wall;
        canvas.drawRect(rect, isWall ? wallPaint : floorPaint);
        _drawTile(canvas, tileImages[isWall ? 'wall' : 'floor'], rect);
        if (!isWall) {
          if (x == f.start.x && y == f.start.y) {
            _drawTile(canvas, tileImages['start'], rect);
          }
          if (x == f.exit.x && y == f.exit.y) {
            _drawTile(canvas, tileImages['exit'], rect);
          }
          if (t == MazeTile.door) {
            _drawTile(canvas, tileImages['door'], rect);
            canvas.drawRect(
              rect,
              Paint()
                ..color = run.opened.contains('${run.fi}:$k')
                    ? const Color(0x24BFE3A8)
                    : const Color(0x24C98850),
            );
          }
          if (f.portals.containsKey(k)) {
            _drawTile(canvas, tileImages['portal'], rect);
          }
        }
        if (reach.contains(k)) {
          canvas.drawRect(rect, Paint()..color = const Color(0x2E5FE08E));
        }
        // 迷雾模式：视野圈外压暗（提灯扩圈）
        if (fogMode) {
          final dx = (x - run.pos.x).abs();
          final dy = (y - run.pos.y).abs();
          final cheb = dx > dy ? dx : dy;
          if (cheb > vision) {
            canvas.drawRect(rect, Paint()..color = const Color(0x8F2A2318));
          }
        }
        // 标记
        final item = f.items[k];
        final picked = run.picked.contains('${run.fi}:$k');
        final foe = f.foes[k];
        final consumed = run.consumed.contains('${run.fi}:$k');
        final cx = x * cell + cell / 2;
        final cy = y * cell + cell / 2;
        if (item != null && !picked) {
          final marker = switch (item.kind) {
            MazeItemKind.trap => tileImages['trap'],
            MazeItemKind.shrine => tileImages['shrine'],
            MazeItemKind.key => tileImages['key'],
            MazeItemKind.lantern => tileImages['lantern'],
            MazeItemKind.power => powerImage,
          };
          _drawMarker(canvas, marker, cx, cy, cell);
        }
        if (f.warps.containsKey(k)) {
          _drawMarker(canvas, tileImages['warp'], cx, cy, cell);
        }
        if (foe != null && !consumed) {
          final beatable = run.level >= foe.level;
          _foe(canvas, cx, cy, cell, foe, beatable);
        }
      }
    }
    // 玩家
    final companion = controller.state.companion;
    final px = run.pos.x * cell + cell / 2;
    final py = run.pos.y * cell + cell / 2;
    canvas.drawCircle(Offset(px, py + cell * 0.3), cell * 0.22,
        Paint()..color = const Color(0x30000000));
    final rec = companion != null ? controller.state.pets[companion] : null;
    if (companion != null && rec != null) {
      final img = petImage;
      if (img != null) {
        final s = cell * 0.86;
        canvas.drawImageRect(
            img,
            Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
            Rect.fromCenter(center: Offset(px, py), width: s, height: s),
            Paint());
      } else {
        canvas.drawCircle(Offset(px, py), cell * 0.3,
            Paint()..color = Color(companion.colorValue));
      }
    }
  }

  void _drawMarker(
      Canvas canvas, ui.Image? image, double cx, double cy, double cell) {
    if (image == null) return;
    final size = cell * 0.68;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromCenter(center: Offset(cx, cy), width: size, height: size),
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  void _drawTile(Canvas canvas, ui.Image? image, Rect rect) {
    if (image == null) return;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      rect,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  void _foe(Canvas canvas, double cx, double cy, double cell, MazeFoe foe,
      bool beatable) {
    final isBoss = foe.kind == FoeKind.boss;
    final image = isBoss ? bossImage : foeImage;
    if (image != null) {
      final size = cell * (isBoss ? 0.9 : 0.78);
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromCenter(
            center: Offset(cx, cy - cell * 0.08), width: size, height: size),
        Paint()..filterQuality = FilterQuality.medium,
      );
    }
    _drawFoeLevel(
        canvas, cx, cy + cell * 0.3, cell, foe.level, beatable, isBoss);
    if (foe.kind == FoeKind.elite) {
      _drawEliteMark(canvas, cx + cell * 0.29, cy - cell * 0.34, cell);
    }
  }

  void _drawFoeLevel(Canvas canvas, double cx, double cy, double cell,
      int level, bool beatable, bool isBoss) {
    final label = 'Lv.$level';
    final tp = TextPainter(
      text: TextSpan(
          text: label,
          style: TextStyle(
              fontFamily: MoodisleColors.fontFamily,
              fontSize: cell * 0.19,
              fontWeight: FontWeight.w800,
              color: Colors.white)),
      textAlign: TextAlign.center,
    )
      ..textDirection = TextDirection.ltr
      ..layout();
    final badgeWidth = (tp.width + cell * 0.18).clamp(cell * 0.48, cell * 0.76);
    final badgeHeight = cell * 0.2;
    final badge = Rect.fromCenter(
        center: Offset(cx, cy), width: badgeWidth, height: badgeHeight);
    final fill = isBoss
        ? const Color(0xFF8A4FBF)
        : beatable
            ? const Color(0xFF4C9A70)
            : const Color(0xFFAD5D4E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(badge, Radius.circular(cell * 0.08)),
      Paint()..color = fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(badge, Radius.circular(cell * 0.08)),
      Paint()
        ..color = const Color(0xFF5A3E22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = cell * 0.025,
    );
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  void _drawEliteMark(Canvas canvas, double cx, double cy, double cell) {
    final radius = cell * 0.11;
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * math.pi / 5;
      final r = i.isEven ? radius : radius * 0.48;
      final point = Offset(cx + math.cos(angle) * r, cy + math.sin(angle) * r);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFD36B));
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF5A3E22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = cell * 0.025,
    );
  }

  @override
  bool shouldRepaint(_MazePainter old) =>
      old.run != run ||
      old.cell != cell ||
      old.tileImages != tileImages ||
      old.foeImage != foeImage ||
      old.bossImage != bossImage ||
      old.petImage != petImage ||
      old.powerImage != powerImage ||
      old.run.level != run.level ||
      old.run.pos != run.pos ||
      old.run.steps != run.steps ||
      old.run.keys != run.keys;
}
