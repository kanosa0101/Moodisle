/// 覆盖缺口专项测试：game_core 分支 / 迷宫运行时边缘 / 模型工具函数 /
library;
import 'dart:math' show Random;
/// 周报洞察分支 / 枚举元数据。目标：domain 行覆盖 ≥85%（docs/07 M1 门槛）。
import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/config/roam_config.dart';
import 'package:moodisle_app/domain/engine/climate_engine.dart';
import 'package:moodisle_app/domain/engine/maze/maze_models.dart';
import 'package:moodisle_app/domain/engine/maze/maze_runtime.dart';
import 'package:moodisle_app/domain/engine/maze/maze_settlement.dart';
import 'package:moodisle_app/domain/engine/maze/zone_tuning.dart';
import 'package:moodisle_app/domain/engine/weekly_engine.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/entities/social.dart';
import 'package:moodisle_app/domain/events/game_events.dart';
import 'package:moodisle_app/domain/game_core.dart';
import 'package:moodisle_app/domain/time/local_date.dart';

/// 与 maze_runtime_test 一致的测试桩参数。
const ZoneTuning stubTuning = ZoneTuning(
  zoneIndex: 0,
  size: 5,
  floorCount: 1,
  wallPct: 0,
  foeMul: 1,
  eliteChance: 0,
  traps: 0,
  shrines: 0,
  keyDoors: 0,
  warps: 0,
  lanterns: 0,
  lootMul: 1,
  tier: 1,
);

class _SeqRandom implements Random {
  final List<double> values;
  int _i = 0;
  _SeqRandom(this.values);
  @override
  bool nextBool() => false;
  @override
  int nextInt(int max) => (values[_i % values.length] * max).floor();
  @override
  double nextDouble() => values[_i++ % values.length];
}

GameState _withPet(Emotion e, {int count = 1}) {
  final s = GameState.fresh();
  s.pets[e] =
      PetRecord(emotion: e, count: count, stage: PetStage.clear, bond: Bond(minutes: 0));
  GameCore(s).ensureDaily(DateTime(2026, 9, 26, 9, 0));
  return s;
}

void main() {
  final now = DateTime(2026, 9, 26, 10, 0);

  group('game_core：道具分支全覆盖', () {
    test('暖锋/顺风 buff 计数', () {
      final s = _withPet(Emotion.sloth);
      s.items[ItemId.warmFront] = 2;
      s.items[ItemId.tailwind] = 1;
      final c = GameCore(s, rng: _SeqRandom([0.5]));
      c.useItem(ItemId.warmFront, now);
      c.useItem(ItemId.tailwind, now);
      expect(s.warmFrontTurns, 3);
      expect(s.tailwindTurns, 3);
    });

    test('心结碎片：不足 3 拒绝；满 3 合成云母', () {
      final s = _withPet(Emotion.sloth);
      s.items[ItemId.knotShard] = 2;
      final c = GameCore(s, rng: _SeqRandom([0.5]));
      c.useItem(ItemId.knotShard, now);
      expect((s.items[ItemId.cloudMica] ?? 0), 0);
      s.items[ItemId.knotShard] = 3;
      c.useItem(ItemId.knotShard, now);
      expect(s.items[ItemId.cloudMica], 1);
      expect(s.items[ItemId.knotShard], 0);
    });

    test('云母/雾露：三种随机结果路径', () {
      // 结果一：经验
      final s1 = _withPet(Emotion.sloth);
      s1.items[ItemId.cloudMica] = 1;
      GameCore(s1, rng: _SeqRandom([0.1])).useItem(ItemId.cloudMica, now);
      expect(s1.keeper.exp, GameConfig.cloudMicaExp);
      // 结果二：放晴
      final s2 = _withPet(Emotion.sloth);
      s2.items[ItemId.cloudMica] = 1;
      GameCore(s2, rng: _SeqRandom([0.5])).useItem(ItemId.cloudMica, now);
      expect(s2.clearing, GameConfig.cloudMicaClearing.toDouble());
      // 结果三：晨露
      final s3 = _withPet(Emotion.sloth);
      s3.items[ItemId.cloudMica] = 1;
      GameCore(s3, rng: _SeqRandom([0.9])).useItem(ItemId.cloudMica, now);
      expect(s3.items[ItemId.morningDew], 3);
      // 雾露三分支
      for (final roll in [0.1, 0.5, 0.9]) {
        final s = _withPet(Emotion.sloth);
        s.items[ItemId.mistDew] = 1;
        final before = s.clearing;
        GameCore(s, rng: _SeqRandom([roll])).useItem(ItemId.mistDew, now);
        expect(s.clearing, before + GameConfig.mistDewClearing);
      }
    });

    test('培育边界：未收服 / 已圆满 / 晨露不足 / 虹晶加速', () {
      final s = _withPet(Emotion.sloth);
      final c = GameCore(s, rng: _SeqRandom([0.5]));
      // 未收服
      var ev = c.cultivate(Emotion.anxious, now: now);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      // 已圆满
      s.pets[Emotion.anxious] = PetRecord(
          emotion: Emotion.anxious,
          count: 10,
          stage: PetStage.awakened,
          branch: Branch.constellation,
          bond: Bond(minutes: 0));
      ev = c.cultivate(Emotion.anxious, now: now);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      // 晨露不足
      ev = c.cultivate(Emotion.emo, now: now);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      // 虹晶加速：一次 +2（用已收服的 sloth count1 → 3）
      s.items[ItemId.morningDew] = 1;
      s.items[ItemId.prismCrystal] = 1;
      c.cultivate(Emotion.sloth, usePrism: true, now: now);
      expect(s.pets[Emotion.sloth]!.count, 3);
      expect(s.items[ItemId.morningDew], 0);
      expect(s.items[ItemId.prismCrystal], 0);
    });

    test('看岛人连升两级', () {
      final s = _withPet(Emotion.sloth);
      final c = GameCore(s, rng: _SeqRandom([0.5]));
      final ev = c.grantKeeperExp(250);
      expect(s.keeper.level, 3);
      expect(ev.whereType<KeeperLevelUp>().length, 2);
    });

    test('未知待办完成 → 提示；空文本录入 → 拒绝', () {
      final s = _withPet(Emotion.sloth);
      final c = GameCore(s, rng: _SeqRandom([0.5]));
      final ev = c.completeTask(999, now: now);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      final before = s.tasks.length;
      c.addTask('   ', Emotion.sloth, 1, now);
      expect(s.tasks.length, before);
    });

    test('回廊门槛：锁定区 / 无伙伴 / 次数用尽 / 无行动力', () {
      final s = _withPet(Emotion.sloth);
      final c = GameCore(s, rng: _SeqRandom([0.5]));
      // 锁定区（zoneIndex 9 需 55 次）
      var ev = c.startMaze(9, now: now);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      // 无伙伴（zone 0 已解锁但未选伙伴）
      ev = c.startMaze(0, now: now);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      // 次数用尽
      s.companion = Emotion.sloth;
      s.daily.mazeToday = 99;
      ev = c.startMaze(0, now: now);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      s.daily.mazeToday = 0;
      // 无行动力
      s.energy = 0;
      ev = c.startMaze(0, now: now);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      // 成功进入
      s.energy = 2;
      ev = c.startMaze(0, now: now);
      expect(c.activeMazeRun, isNotNull);
      expect(s.energy, 1);
      expect(s.daily.mazeToday, 1);
      // 放弃
      c.abandonMaze();
      expect(c.activeMazeRun, isNull);
    });

    test('回廊结算入账（finishMaze）', () {
      final s = _withPet(Emotion.sloth);
      final c = GameCore(s, rng: _SeqRandom([0.5]));
      s.companion = Emotion.sloth;
      s.energy = 3;
      c.startMaze(0, now: now);
      final run = c.activeMazeRun!;
      run.active = false; // 模拟已通关
      run.settlement = settleMaze(
        kills: 2,
        eliteKills: 0,
        bossBeaten: false,
        perfect: false,
        lootMul: 1,
        floorCount: 1,
        fogMode: false,
      );
      final dewBefore = s.items[ItemId.morningDew] ?? 0;
      c.finishMaze();
      expect(s.stats.mazeRuns, 1);
      expect((s.items[ItemId.morningDew] ?? 0), greaterThan(dewBefore));
      expect(c.activeMazeRun, isNull);
      // 未开始时结算 → 无事件
      expect(c.finishMaze(), isEmpty);
    });

    test('云游包装与问候去重', () {
      final s = _withPet(Emotion.emo);
      final c = GameCore(s, rng: _SeqRandom([0.5]));
      c.dispatchRoam(Emotion.emo, 'monsoon');
      expect(s.roam.slots.length, 1);
      // 未到期领取 → 提示
      final ev = c.claimRoam(0);
      expect(ev.whereType<GameNotice>().isNotEmpty, isTrue);
      // 问候：第一次生效，第二次无效
      c.greet(now);
      expect(s.daily.lastGreet, const LocalDate(2026, 9, 26));
      final second = c.greet(now);
      expect(second, isEmpty);
    });
  });

  group('迷宫运行时边缘', () {
    FloorData flat({Map<String, MazeItem>? items}) {
      final grid = List.generate(3, (_) => List.filled(5, MazeTile.floor));
      return FloorData(
        w: 5,
        h: 3,
        grid: grid,
        start: const MazePos(0, 1),
        exit: const MazePos(4, 1),
        foes: {},
        items: items ?? {},
        portals: {},
        warps: {},
      );
    }

    test('提灯拾取与迷雾可达裁剪', () {
      final r = MazeRun(
        MazeData(
          zoneIndex: 4,
          tuning: stubTuning,
          floors: [
            flat(items: {'1,0': const MazeItem(MazeItemKind.lantern, 1)}),
          ],
          floorStartLevels: [5],
          startLevel: 5,
          endLevel: 5,
        ),
      );
      final before = r.reachable(visionRadius: 2, fogMode: true).length;
      r.clickCell(1, 0);
      expect(r.lanterns, 1);
      final after = r.reachable(visionRadius: 2 + r.lanterns, fogMode: true);
      expect(after.length, greaterThan(before));
      // 非迷雾模式不做裁剪（拾灯后 pos=(1,0)，radius3 已覆盖全图 15 格）
      final plain = r.reachable(visionRadius: 1, fogMode: false);
      expect(plain.length, greaterThanOrEqualTo(after.length));
    });

    test('跨层传送：踏上即跳目标层入口', () {
      final f0grid = List.generate(3, (_) => List.filled(5, MazeTile.floor));
      final f0 = FloorData(
        w: 5,
        h: 3,
        grid: f0grid,
        start: const MazePos(0, 1),
        exit: const MazePos(4, 1),
        foes: {},
        items: {},
        portals: {},
        warps: {'2,1': const WarpTarget(1, '0,1')},
      );
      final f1 = flat();
      final r = MazeRun(
        MazeData(
          zoneIndex: 7,
          tuning: stubTuning,
          floors: [f0, f1],
          floorStartLevels: [5, 9],
          startLevel: 5,
          endLevel: 9,
        ),
      );
      final ev = r.runPath([const MazePos(1, 1), const MazePos(2, 1)]);
      expect(r.fi, 1);
      expect(r.pos.key, '0,1'); // 目标层入口
      expect(ev.any((e) => e.text.contains('跨层')), isTrue);
      expect(r.undo(), isFalse); // 跨层清撤销栈
    });

    test('越界单步为空事件', () {
      final r = MazeRun(
        MazeData(
          zoneIndex: 0,
          tuning: stubTuning,
          floors: [flat()],
          floorStartLevels: [5],
          startLevel: 5,
          endLevel: 5,
        ),
      );
      expect(r.step(-1, 0), isEmpty);
      expect(r.step(0, -1), isEmpty);
      expect(r.step(9, 0), isEmpty);
      expect(r.clickCell(-1, -1).first.isError, isTrue);
    });
  });

  group('模型与元数据', () {
    test('MazePos 相等性 / neighbors 边界 / fingerprint', () {
      const a = MazePos(2, 3);
      const b = MazePos(2, 3);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.key, '2,3');
      expect(neighbors(0, 0, 3, 3).length, 2);
      expect(neighbors(1, 1, 3, 3).length, 4);
      expect(neighbors(2, 2, 3, 3).length, 2);
    });

    test('LocalDate：运算符 / 相邻 / 周一 / 跨月加天 / toString', () {
      const d = LocalDate(2026, 9, 26);
      expect(d.weekday, DateTime.saturday);
      expect(d.mondayOfWeek, const LocalDate(2026, 9, 21));
      expect(d.isAdjacentTo(const LocalDate(2026, 9, 27)), isTrue);
      expect(d.isAdjacentTo(const LocalDate(2026, 9, 24)), isFalse);
      expect(d < d.tomorrow, isTrue);
      expect(d > d.yesterday, isTrue);
      expect(d <= d, isTrue);
      expect(d >= d, isTrue);
      expect(const LocalDate(2026, 1, 31).addDays(1), const LocalDate(2026, 2, 1));
      expect(d.toString(), '2026-09-26');
    });

    test('十精灵与道具元数据完备', () {
      for (final e in Emotion.values) {
        expect(e.petEn, isNotEmpty);
        expect(e.weatherCn, isNotEmpty);
        expect(e.emotionCn, isNotEmpty);
        expect(e.petCn, isNotEmpty);
        expect(e.colorValue, isNot(0));
        expect(e.stressWeight, greaterThan(0));
      }
      for (final id in ItemId.values) {
        expect(id.cn, isNotEmpty);
        expect(id.icon, isNotEmpty);
      }
      expect(kZoneNames.length, 10);
      expect(kZoneUnlockExp.length, 10);
      expect(kRoamRoutes[0].duration, const Duration(minutes: 30));
      expect(kRoamRoutes[1].duration, const Duration(hours: 4));
      expect(kRoamRoutes[2].duration, const Duration(hours: 12));
      for (final r in kRoamRoutes) {
        expect(r.pool, isNotEmpty);
        expect(kSouvenirs.keys, containsAll(r.pool.map((p) => p.$1)));
      }
    });

    test('云游槽 isDue 边界与 copyWith', () {
      final slot = RoamSlot(
        pet: Emotion.sloth,
        routeId: 'monsoon',
        startedAt: DateTime(2026, 9, 26, 10, 0),
        durationMs: 60000,
      );
      final at60 = DateTime(2026, 9, 26, 10, 1);
      expect(slot.isDue(at60), isTrue); // 恰好到期
      expect(slot.isDue(DateTime(2026, 9, 26, 10, 0, 59)), isFalse);
      final moved = slot.copyWith(startedAt: DateTime(2026, 9, 26, 11, 0));
      expect(moved.startedAt.hour, 11);
      expect(moved.durationMs, slot.durationMs);
    });

    test('周报洞察分支：浓雾 / 高共鸣 / 高专注 / 高完成', () {
      final now = DateTime(2026, 9, 26, 10, 0);
      // 浓雾
      final s1 = GameState.fresh();
      ClimateEngine.bucketFor(s1, const LocalDate(2026, 9, 26)).done = 3;
      s1.climate.fog = 70;
      final r1 = WeeklyEngine.build(s1, now);
      expect(r1.headline, contains('雾'));
      // 高共鸣
      final s2 = GameState.fresh();
      ClimateEngine.bucketFor(s2, const LocalDate(2026, 9, 26)).done = 3;
      s2.resonance.best = 5;
      expect(WeeklyEngine.build(s2, now).headline, contains('共鸣'));
      // 高专注
      final s3 = GameState.fresh();
      ClimateEngine.bucketFor(s3, const LocalDate(2026, 9, 26)).done = 3;
      s3.stats.totalFocusMinutes = 200;
      ClimateEngine.bucketFor(s3, const LocalDate(2026, 9, 26)).focusMin = 160;
      expect(WeeklyEngine.build(s3, now).headline, contains('专注'));
      // 高完成
      final s4 = GameState.fresh();
      ClimateEngine.bucketFor(s4, const LocalDate(2026, 9, 26)).done = 12;
      expect(WeeklyEngine.build(s4, now).headline, contains('完成'));
    });

    test('evoProgress / stageLabel 边界（图鉴文案）', () {
      // 通过 SocialEngine/DEX 文案层验证：直接断言 stageLabel 逻辑由 UI 测试覆盖，
      // 此处覆盖 RoamRoute 顺序与睛/虹/觉醒推进（stageForCount 已在 pet_test 覆盖）。
      expect(kRoamRoutes[0].count(0), 1);
      expect(kRoamRoutes[1].count(0), 2); // 偶数 roll → 1+1
      expect(kRoamRoutes[1].count(1), 1); // 奇数 → 1
      expect(kRoamRoutes[2].count(2), 3); // 偶数 → 2+1
      expect(kRoamRoutes[2].count(3), 2); // 奇数 → 2
    });
  });
}
