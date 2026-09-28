/// 心岛生态模拟（docs/05 §3.1 的逻辑侧；原设计 F1 思想的自研实现）。
///
/// 纯 Dart：actor 状态机（idle/walk/act）+ 微气候区落户 + 命中检测。
/// UI（IslandPainter）只消费本模拟的快照，不做任何规则计算。
library;

import 'dart:math' as math;
import 'dart:math';

import '../entities/emotion.dart';
import '../entities/game_state.dart';
import '../entities/task.dart';

/// 世界逻辑尺寸（docs/05 §3.1）。
const double kWorldW = 1200;
const double kWorldH = 800;

/// 五微气候区（docs/08 §4.1 布局：雨湖西北/雾林东北/晴坪中央/霞滩东南/风崖西南）。
enum Biome {
  sunnyMeadow(0.50, 0.55, 0.20, 0.18, '晴坪'),
  rainLake(0.28, 0.30, 0.14, 0.12, '雨湖'),
  mistWoods(0.72, 0.28, 0.15, 0.13, '雾林'),
  windCliff(0.26, 0.76, 0.14, 0.10, '风崖'),
  sunsetShore(0.72, 0.74, 0.15, 0.11, '霞滩');

  final double cx, cy, rx, ry; // 椭圆中心/半径（占世界比例）
  final String cn;
  const Biome(this.cx, this.cy, this.rx, this.ry, this.cn);

  /// 精灵落户映射（每区两类气质相近的情绪）。
  static Biome of(Emotion e) => switch (e) {
        Emotion.anxious || Emotion.neikao => Biome.sunnyMeadow,
        Emotion.emo || Emotion.shy => Biome.rainLake,
        Emotion.sloth || Emotion.burnout => Biome.mistWoods,
        Emotion.distract || Emotion.fomo => Biome.windCliff,
        Emotion.chaos || Emotion.perfect => Biome.sunsetShore,
      };
}

enum ActorState { idle, walk, act }

/// 一个岛上角色（野生=未收服待办怪 / 定居=已收服精灵）。
class IslandActor {
  final String key;
  final Emotion emotion;
  final bool wild;
  final Biome biome;
  double x, y;
  double tx, ty;
  ActorState state;
  double facing; // 朝向弧度（UI 翻转用）
  double timer;
  int t; // 动画钟
  String? emote; // 心情气泡
  double emoteT;

  IslandActor({
    required this.key,
    required this.emotion,
    required this.wild,
    required this.biome,
    required this.x,
    required this.y,
  })  : tx = x,
        ty = y,
        state = ActorState.idle,
        facing = 0,
        timer = 1,
        t = 0,
        emote = null,
        emoteT = 0;
}

class EcoSim {
  final List<IslandActor> actors = [];
  final Random rng;

  EcoSim({Random? rng}) : rng = rng ?? Random(1);

  /// 按当前存档重建角色集合（保留旧角色位置，新增随机落户）。
  void rebuild(GameState s) {
    final want = <String, IslandActor>{};
    for (final t in s.tasks) {
      if (t.status == TaskStatus.done) continue;
      final key = 'wild:${t.id}';
      want[key] = IslandActor(
          key: key,
          emotion: t.emotion,
          wild: true,
          biome: Biome.of(t.emotion),
          x: 0,
          y: 0);
    }
    s.pets.forEach((emotion, rec) {
      final key = 'pet:${emotion.name}';
      want[key] = IslandActor(
          key: key,
          emotion: emotion,
          wild: false,
          biome: Biome.of(emotion),
          x: 0,
          y: 0);
    });
    // 好友到访精灵（群岛明信片，72h 客住，纯外观 NPC）
    if (s.social.hasVisitor) {
      final key = 'visitor:${s.social.visitingPet!.name}';
      want[key] = IslandActor(
          key: key,
          emotion: s.social.visitingPet!,
          wild: false,
          biome: Biome.of(s.social.visitingPet!),
          x: 0,
          y: 0);
    }
    // 复用既有 / 落户新角色
    final next = <IslandActor>[];
    want.forEach((key, w) {
      final old = actors.where((a) => a.key == key).firstOrNull;
      if (old != null) {
        next.add(old);
      } else {
        final p = zonePoint(w.biome);
        w.x = p.dx;
        w.y = p.dy;
        w.tx = p.dx;
        w.ty = p.dy;
        next.add(w);
      }
    });
    actors
      ..clear()
      ..addAll(next);
  }

  /// 在某微气候区椭圆内随机取点（世界坐标）。
  ({double dx, double dy}) zonePoint(Biome b, {double scale = 0.85}) {
    final a = rng.nextDouble() * math.pi * 2;
    final r = math.sqrt(rng.nextDouble()) * scale;
    return (
      dx: (b.cx + math.cos(a) * b.rx * r) * kWorldW,
      dy: (b.cy + math.sin(a) * b.ry * r) * kWorldH,
    );
  }

  /// 推进一帧（dt 秒）。
  void tick(double dt) {
    for (final a in actors) {
      a.t++;
      if (a.emoteT > 0) a.emoteT -= dt;
      switch (a.state) {
        case ActorState.walk:
          final dx = a.tx - a.x;
          final dy = a.ty - a.y;
          final d = math.sqrt(dx * dx + dy * dy);
          final speed = (a.wild ? 27 : 37) * dt; // 野生慢、定居快（px/s）
          if (d < speed || d < 2) {
            a.x = a.tx;
            a.y = a.ty;
            a.state = ActorState.idle;
            a.timer = 1 + rng.nextDouble() * 2.3;
          } else {
            a.x += dx / d * speed;
            a.y += dy / d * speed;
            a.facing = math.atan2(dy, dx);
          }
        case ActorState.act:
          a.timer -= dt;
          if (a.timer <= 0) {
            a.state = ActorState.idle;
            a.timer = 1 + rng.nextDouble() * 2;
          }
        case ActorState.idle:
          a.timer -= dt;
          if (a.timer <= 0) {
            final r = rng.nextDouble();
            if (r < 0.6) {
              final p = zonePoint(a.biome);
              a.tx = p.dx;
              a.ty = p.dy;
              a.state = ActorState.walk;
            } else if (r < 0.85 && !a.wild) {
              a.state = ActorState.act;
              a.timer = 0.67 + rng.nextDouble() * 0.66;
              if (rng.nextBool()) {
                a.emote = const [
                  'heart',
                  'sparkle',
                  'music',
                  'happy',
                  'star',
                  'leaf'
                ][rng.nextInt(6)];
                a.emoteT = 1.5;
              }
            } else {
              a.timer = 1 + rng.nextDouble() * 2;
            }
          }
      }
    }
  }

  /// 点击命中（世界坐标）：返回被打断做小动作的 actor。
  IslandActor? tap(double wx, double wy) {
    IslandActor? hit;
    var best = 1e9;
    for (final a in actors) {
      final d = math.sqrt(math.pow(a.x - wx, 2) + math.pow(a.y - (wy + 18), 2));
      if (d < 28 && d < best) {
        best = d;
        hit = a;
      }
    }
    if (hit != null) {
      hit.emote = const ['heart', 'sparkle', 'music', 'happy'][rng.nextInt(4)];
      hit.emoteT = 1.8;
      hit.state = ActorState.act;
      hit.timer = 1.2;
    }
    return hit;
  }
}
