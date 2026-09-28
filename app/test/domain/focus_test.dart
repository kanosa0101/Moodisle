import 'dart:math' show Random;

import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
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

GameState _stateWith(Emotion pet, Bond bond) {
  final s = GameState.fresh();
  s.pets[pet] =
      PetRecord(emotion: pet, count: 1, stage: PetStage.clear, bond: bond);
  // 每日面初始化（任务槽就绪）
  GameCore(s, rng: _FixedRandom())
      .ensureDaily(DateTime(2026, 9, 25, 9, 0));
  return s;
}

void main() {
  group('TC-FOC-001 完成结算（docs/03 §8.1）', () {
    test('50→75 分钟升 Lv2；星屑按结算前等级计算 = 5', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 50));
      final c = GameCore(s, rng: _FixedRandom());
      final now = DateTime(2026, 9, 25, 9, 0);
      c.startFocus(Emotion.emo, 25, now);

      final events = c.focusTick(now.add(const Duration(minutes: 25)));
      final done = events.whereType<FocusCompleted>().toList();
      expect(done.length, 1);
      expect(done.first.minutes, 25);
      expect(done.first.stardust, 5); // ⌊25/5 ×1×(1+1×0.05)⌋ = 5
      expect(done.first.bondGain, 25);
      expect(done.first.bondLevelUpTo, 2);

      final rec = s.pets[Emotion.emo]!;
      expect(rec.bond.minutes, 75);
      expect(rec.bond.level, 2);
      expect(rec.bond.minutesToNext(), 75); // 距 Lv3(150) 还需 75 分钟

      expect(s.items[ItemId.stardust], 5);
      expect(s.focusMeta.todayMin, 25);
      expect(s.focusMeta.weekMin, 25);
      expect(s.stats.totalFocusSessions, 1);
      expect(s.session, isNull);
      expect(s.daily.quests['focus1']!.prog, 1);
      expect(
        s.climate.days
            .firstWhere((b) => b.date == const LocalDate(2026, 9, 25))
            .focusMin,
        25,
      );
    });
  });

  group('状态机：张望宽限与作废（docs/03 §8）', () {
    test('后台→宽限内回前台→无缝继续→完成', () {
      final s = _stateWith(Emotion.anxious, Bond(minutes: 0));
      final c = GameCore(s, rng: _FixedRandom());
      var now = DateTime(2026, 9, 25, 9, 0);
      c.startFocus(Emotion.anxious, 15, now);

      now = now.add(const Duration(minutes: 5));
      final interrupted = c.focusOnBackgrounded(now);
      expect(interrupted.whereType<FocusInterrupted>().length, 1);
      expect(s.session!.phase, 'glancing');

      now = now.add(const Duration(seconds: 90)); // ≤120s 宽限
      c.focusOnResumed(now);
      expect(s.session!.phase, 'focusing');

      now = now.add(const Duration(minutes: 14));
      final events = c.focusTick(now); // 累计 5+14=19min ≥ 15
      final done = events.whereType<FocusCompleted>().toList();
      expect(done.length, 1);
      expect(done.first.minutes, 15);
      expect(done.first.stardust, 3); // ⌊15/5×1×(1+0)⌋
      expect(s.focusMeta.glancesToday, 0);
    });

    test('宽限超时 → 作废（零惩罚，记一次张望）', () {
      final s = _stateWith(Emotion.anxious, Bond(minutes: 0));
      final c = GameCore(s, rng: _FixedRandom());
      var now = DateTime(2026, 9, 25, 10, 0);
      c.startFocus(Emotion.anxious, 25, now);

      now = now.add(const Duration(minutes: 10));
      c.focusOnBackgrounded(now);
      now = now.add(const Duration(seconds: 121)); // >120s
      final events = c.focusOnResumed(now);

      expect(events.whereType<FocusVoided>().length, 1);
      expect(s.session, isNull);
      expect(s.focusMeta.glancesToday, 1);
      expect(s.pets[Emotion.anxious]!.bond.minutes, 0); // 零惩罚
      expect(s.items[ItemId.stardust] ?? 0, 0);
    });

    test('主动取消不记张望', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s, rng: _FixedRandom());
      final now = DateTime(2026, 9, 25, 11, 0);
      c.startFocus(Emotion.emo, 25, now);
      final events = c.cancelFocus(now.add(const Duration(minutes: 3)));
      expect(events.whereType<FocusVoided>().length, 1);
      expect(s.focusMeta.glancesToday, 0);
      expect(s.session, isNull);
    });

    test('已有专注进行中时拒绝重复开始', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s, rng: _FixedRandom());
      final now = DateTime(2026, 9, 25, 12, 0);
      c.startFocus(Emotion.emo, 25, now);
      final again = c.startFocus(Emotion.emo, 15, now);
      expect(again.whereType<GameNotice>(), isNotEmpty);
      expect(s.session!.planMin, 25);
    });
  });
}
