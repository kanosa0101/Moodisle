import 'dart:math' show Random;

import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/engine/climate.dart';
import 'package:moodisle_app/domain/engine/daily_engine.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/events/game_events.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/game_core.dart';
import 'package:moodisle_app/domain/time/local_date.dart';

class _FixedRandom implements Random {
  @override
  bool nextBool() => false;
  @override
  int nextInt(int max) => max - 1;
  @override
  double nextDouble() => 0.99;
}

void main() {
  group('天气共鸣：环链、里程碑与 24h 窗口（docs/03 §6）', () {
    test('沿环连完 5 环 → len/best=5；虹晶=共演4+链3礼1=5；暖锋=1', () {
      final s = GameState.fresh();
      s.daily.date = const LocalDate(2026, 9, 25);
      final c = GameCore(s, rng: _FixedRandom());
      final base = DateTime(2026, 9, 25, 10, 0);
      final seq = [
        Emotion.anxious, // len1
        Emotion.emo, // len2 共演
        Emotion.sloth, // len3 共演+里程碑
        Emotion.burnout, // len4 共演
        Emotion.neikao, // len5 共演+里程碑
      ];
      for (var i = 0; i < seq.length; i++) {
        c.addTask('任务$i', seq[i], 1, base.add(Duration(hours: i)));
        c.completeTask(i + 1, now: base.add(Duration(hours: i)));
      }
      expect(s.resonance.len, 5);
      expect(s.resonance.best, 5);
      expect(s.resonance.last, Emotion.neikao);
      expect(s.items[ItemId.prismCrystal], 5);
      expect(s.items[ItemId.warmFront], 1);
    });

    test('超过 24h 窗口 → 断链重计（零惩罚）', () {
      final s = GameState.fresh();
      s.daily.date = const LocalDate(2026, 9, 25);
      final c = GameCore(s, rng: _FixedRandom());
      final t0 = DateTime(2026, 9, 25, 10, 0);
      c.addTask('A', Emotion.anxious, 1, t0);
      c.completeTask(1, now: t0);
      final t1 = t0.add(const Duration(hours: 25));
      c.ensureDaily(t1);
      c.addTask('B', Emotion.emo, 1, t1);
      c.completeTask(2, now: t1);
      expect(s.resonance.len, 1);
      expect(s.resonance.best, 1);
    });

    test('类型不承接 → 断链', () {
      final s = GameState.fresh();
      s.daily.date = const LocalDate(2026, 9, 25);
      final c = GameCore(s, rng: _FixedRandom());
      final t0 = DateTime(2026, 9, 25, 10, 0);
      c.addTask('A', Emotion.anxious, 1, t0);
      c.completeTask(1, now: t0);
      c.addTask('B', Emotion.sloth, 1, t0.add(const Duration(hours: 1)));
      c.completeTask(2, now: t0.add(const Duration(hours: 1)));
      expect(s.resonance.len, 1);
    });
  });

  group('每日引擎：跨天滚动 / 签到 / 任务（docs/03 §4）', () {
    test('跨天滚动幂等：同日多次调用只投一次雾露', () {
      final s = GameState.fresh();
      s.climate.tier = ClimateTier.mist;
      final c = GameCore(s, rng: _FixedRandom());
      final d1 = DateTime(2026, 9, 25, 10, 0);
      c.ensureDaily(d1);
      expect(s.items[ItemId.mistDew], 2);
      c.ensureDaily(d1.add(const Duration(hours: 1)));
      expect(s.items[ItemId.mistDew], 2); // 幂等
      c.ensureDaily(DateTime(2026, 9, 26, 9, 0));
      expect(s.items[ItemId.mistDew], 4); // 次日再投
    });

    test('签到：连续续算 / 断签重置 / 7 日循环奖励', () {
      final s = GameState.fresh();
      final c = GameCore(s, rng: _FixedRandom());
      final d1 = DateTime(2026, 9, 25, 9, 0);
      c.ensureDaily(d1);
      c.checkin(d1);
      expect(s.daily.checkinDays, 1);
      expect(s.items[ItemId.sunnyCrystal], 1);
      expect(s.daily.checkedToday, isTrue);

      final d2 = DateTime(2026, 9, 26, 9, 0);
      c.ensureDaily(d2); // checkedToday 重置，lastCheckin 保留
      expect(s.daily.checkedToday, isFalse);
      c.checkin(d2);
      expect(s.daily.checkinDays, 2);
      expect(s.items[ItemId.morningDew], 1); // 循环表第 2 天

      final d4 = DateTime(2026, 9, 28, 9, 0); // 跳过 9/27
      c.ensureDaily(d4);
      c.checkin(d4);
      expect(s.daily.checkinDays, 1); // 断签零惩罚重置
      expect(s.daily.checkinBest, 2);

      final dup = c.checkin(d4);
      expect(dup.whereType<GameNotice>(), isNotEmpty); // 重复签到被拒
    });

    test('每日任务：加法/取峰两种计法与领取', () {
      final s = GameState.fresh();
      final c = GameCore(s, rng: _FixedRandom());
      c.ensureDaily(DateTime(2026, 9, 25, 9, 0)); // 任务槽就绪
      DailyEngine.bumpQuest(s, 'task', 1);
      DailyEngine.bumpQuest(s, 'task', 1);
      DailyEngine.bumpQuest(s, 'task', 1);
      expect(s.daily.quests['do3']!.prog, 3);

      DailyEngine.bumpQuest(s, 'chain', 2);
      DailyEngine.bumpQuest(s, 'chain', 5); // 取峰后夹到 goal
      expect(s.daily.quests['chain3']!.prog, 3);

      c.claimQuest('do3');
      expect(s.daily.quests['do3']!.claimed, isTrue);
      expect(s.items[ItemId.morningDew], 1);
      final again = c.claimQuest('do3');
      expect(again.whereType<GameNotice>(), isNotEmpty);
      expect(s.items[ItemId.morningDew], 1);
    });
  });
}
