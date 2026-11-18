import 'dart:convert';
import 'dart:math' show Random;

import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/data/save_codec.dart';
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
  group('自定义专注', () {
    final start = DateTime(2026, 11, 18, 10);
    for (final minutes in [4, 121]) {
      test('$minutes 分钟不能建立会话', () {
        final s = _stateWith(Emotion.emo, Bond(minutes: 0));
        GameCore(s).startFocus(Emotion.emo, minutes, start, custom: true);
        expect(s.session, isNull);
      });
    }
    for (final (minutes, custom, dust, dives) in [
      (5, true, 1, 0),
      (120, true, 24, 0),
      (50, true, 10, 0),
      (60, true, 12, 0),
      (50, false, 15, 1),
    ]) {
      test('$minutes 分钟 custom=$custom 存档恢复后按所选档位结算', () {
        final s = _stateWith(Emotion.emo, Bond(minutes: 0));
        GameCore(s).startFocus(Emotion.emo, minutes, start, custom: custom);
        final restored = decodeSave(encodeSave(s));
        final end = start.add(Duration(minutes: minutes));
        expect(restored.session!.endsAt, end);
        final events = GameCore(restored).focusTick(end);
        expect(events.whereType<FocusCompleted>().single.stardust, dust);
        expect(restored.stats.deepDives, dives);
        expect(restored.stats.totalFocusMinutes, minutes);
      });
    }
  });

  group('截止时间计时', () {
    test('无心跳也能计算剩余时间，截止前不提前完成，重复回调只结算一次', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      final start = DateTime(2026, 11, 15, 10, 0, 0, 350);
      c.startFocus(Emotion.emo, 25, start);
      final deadline = start.add(const Duration(minutes: 25));
      expect(s.session!.endsAt, deadline);
      expect(s.session!.remainingSecondsAt(start), 1500);
      expect(s.session!.remainingSecondsAt(
          start.add(const Duration(minutes: 10))), 900);
      expect(s.session!.accumSeconds, 0);
      final before = deadline.subtract(const Duration(milliseconds: 1));
      expect(s.session!.remainingSecondsAt(before), 1);
      expect(c.focusTick(before), isEmpty);
      expect(c.focusTick(deadline).whereType<FocusCompleted>(), hasLength(1));
      c.focusOnScreenUnlocked(deadline);
      c.focusOnResumed(deadline);
      c.focusTick(deadline.add(const Duration(hours: 1)));
      expect(s.stats.totalFocusSessions, 1);
      expect(s.focusMeta.todayMin, 25);
    });

    test('反复暂停精确保留剩余小数秒，重复生命周期通知不重复顺延', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      var now = DateTime(2026, 11, 15, 10);
      c.startFocus(Emotion.emo, 25, now);
      var expectedEnd = s.session!.endsAt;
      for (var i = 0; i < 5; i++) {
        now = now.add(const Duration(milliseconds: 350));
        c.focusOnBackgrounded(now);
        c.focusOnBackgrounded(now.add(const Duration(milliseconds: 100)));
        final remaining = s.session!.remainingAt(now);
        now = now.add(const Duration(minutes: 3, milliseconds: 125));
        c.focusTick(now);
        expect(s.session!.remainingAt(now), remaining);
        c.focusOnResumed(now);
        c.focusOnResumed(now);
        expectedEnd = expectedEnd.add(
            const Duration(minutes: 3, milliseconds: 125));
        expect(s.session!.endsAt, expectedEnd);
        expect(s.session!.remainingAt(now), remaining);
      }
      expect(s.session!.accumSeconds, 1);
      expect(s.focusMeta.glancesToday, 5);
      c.focusTick(expectedEnd);
      expect(s.session, isNull);
    });

    test('息屏保持截止时间；解锁后停留其他应用则冻结到重新返回', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      final start = DateTime(2026, 11, 15, 10);
      c.startFocus(Emotion.emo, 25, start);
      final deadline = s.session!.endsAt;
      c.focusOnScreenLocked(start.add(const Duration(minutes: 2)));
      c.focusOnBackgrounded(start.add(const Duration(minutes: 2)));
      c.focusOnScreenLocked(start.add(const Duration(minutes: 2)));
      expect(s.session!.endsAt, deadline);
      // 锁屏期间没有任何 tick。
      final unlocked = start.add(const Duration(minutes: 10));
      c.focusOnScreenUnlocked(unlocked);
      c.focusOnScreenUnlocked(unlocked);
      expect(s.session!.remainingSecondsAt(unlocked), 900);
      final returned = unlocked.add(const Duration(minutes: 7));
      expect(s.session!.remainingSecondsAt(returned), 900);
      c.focusOnResumed(returned);
      expect(s.session!.endsAt, deadline.add(const Duration(minutes: 7)));
      expect(s.session!.remainingSecondsAt(returned), 900);
    });

    test('切应用较久后息屏不能把原暂停改成继续计时', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      final start = DateTime(2026, 11, 15, 10);
      c.startFocus(Emotion.emo, 25, start);
      c.focusOnBackgrounded(start.add(const Duration(minutes: 1)));
      c.focusOnScreenLocked(start.add(const Duration(minutes: 2)));
      expect(s.session!.phase, 'glancing');
      expect(s.session!.remainingSecondsAt(
          start.add(const Duration(hours: 1))), 1440);
    });

    test('旧 JSON 没有截止时间时按历史进度补算，新 JSON 保留截止时间', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final start = DateTime(2026, 11, 15, 10);
      GameCore(s).startFocus(Emotion.emo, 25, start);
      final json = saveToJson(s);
      final session = json['session'] as Map<String, dynamic>;
      session.remove('endsAtMs');
      session['accumSeconds'] = 120;
      session['lastTickAtMs'] =
          start.add(const Duration(minutes: 7)).millisecondsSinceEpoch;
      final restored = decodeSave(jsonEncode(json));
      expect(restored.session!.endsAt,
          start.add(const Duration(minutes: 30)));
      expect(restored.session!.remainingSecondsAt(
          start.add(const Duration(minutes: 10))), 1200);
      final again = decodeSave(encodeSave(restored));
      expect(again.session!.endsAt, restored.session!.endsAt);
    });
  });

  group('计时精度回归', () {
    test('不规则心跳保留不足一秒的余量，并在真实时长达标时结算一次', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      final start = DateTime(2026, 11, 15, 10);
      c.startFocus(Emotion.emo, 25, start);
      for (final ms in [650, 1651, 2649, 3652, 4650, 9900]) {
        c.focusTick(start.add(Duration(milliseconds: ms)));
        expect(s.session!.accumSeconds, ms ~/ 1000);
      }
      c.focusTick(start.add(
          const Duration(minutes: 24, seconds: 59, milliseconds: 999)));
      expect(s.session!.accumSeconds, 1499);
      expect(
          c.focusTick(start.add(const Duration(minutes: 25)))
              .whereType<FocusCompleted>(),
          hasLength(1));
      expect(c.focusTick(start.add(const Duration(minutes: 26))), isEmpty);
      expect(s.stats.totalFocusSessions, 1);
    });

    test('暂停排除后台时间，同时保留离开前不足一秒的专注时间', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      final start = DateTime(2026, 11, 15, 10);
      c.startFocus(Emotion.emo, 25, start);
      c.focusOnBackgrounded(start.add(const Duration(milliseconds: 750)));
      c.focusOnResumed(
          start.add(const Duration(minutes: 5, milliseconds: 750)));
      c.focusTick(start.add(const Duration(minutes: 5, seconds: 1)));
      expect(s.session!.accumSeconds, 1);
    });

    test('锁屏通知晚于后台通知时仍补齐连续专注时间', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      final start = DateTime(2026, 11, 15, 10);
      c.startFocus(Emotion.emo, 25, start);
      c.focusOnBackgrounded(start.add(const Duration(milliseconds: 750)));
      c.focusOnScreenLocked(start.add(const Duration(milliseconds: 900)));
      c.focusOnResumed(
          start.add(const Duration(minutes: 10, milliseconds: 250)));
      expect(s.session!.accumSeconds, 600);
      c.focusTick(start.add(const Duration(minutes: 10, seconds: 1)));
      expect(s.session!.accumSeconds, 601);
    });

    test('较早的时间戳不倒扣已累计时长', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      final start = DateTime(2026, 11, 15, 10);
      c.startFocus(Emotion.emo, 25, start);
      c.focusTick(start.add(const Duration(seconds: 5)));
      c.focusTick(start.add(const Duration(seconds: 3)));
      expect(s.session!.accumSeconds, 5);
      c.focusTick(start.add(const Duration(seconds: 6)));
      expect(s.session!.accumSeconds, 6);
    });

    test('暂停存档恢复后仍保留小数秒余量，且不计入暂停时长', () {
      final s = _stateWith(Emotion.emo, Bond(minutes: 0));
      final c = GameCore(s);
      final start = DateTime(2026, 11, 15, 10);
      c.startFocus(Emotion.emo, 25, start);
      c.focusOnBackgrounded(start.add(const Duration(milliseconds: 1750)));
      final restored = decodeSave(encodeSave(s));
      final resumed = GameCore(restored);
      resumed.focusOnResumed(start.add(const Duration(minutes: 5)));
      resumed.focusTick(
          start.add(const Duration(minutes: 5, milliseconds: 250)));
      expect(restored.session!.accumSeconds, 2);
    });
  });

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

  group('状态机：应用切换暂停与锁屏计时（docs/03 §8）', () {
    test('切到其他应用并暂停超过两分钟→回来继续→完成', () {
      final s = _stateWith(Emotion.anxious, Bond(minutes: 0));
      final c = GameCore(s, rng: _FixedRandom());
      var now = DateTime(2026, 9, 25, 9, 0);
      c.startFocus(Emotion.anxious, 15, now);

      now = now.add(const Duration(minutes: 5));
      final interrupted = c.focusOnBackgrounded(now);
      expect(interrupted.whereType<FocusInterrupted>().length, 1);
      expect(s.session!.phase, 'glancing');

      now = now.add(const Duration(minutes: 10)); // 暂停不因超时作废
      c.focusOnResumed(now);
      expect(s.session!.phase, 'focusing');
      expect(s.focusMeta.glancesToday, 1);

      now = now.add(const Duration(minutes: 10));
      final events = c.focusTick(now); // 累计 5+10=15min
      final done = events.whereType<FocusCompleted>().toList();
      expect(done.length, 1);
      expect(done.first.minutes, 15);
      expect(done.first.stardust, 3); // ⌊15/5×1×(1+0)⌋
      expect(s.focusMeta.glancesToday, 1);
    });

    test('熄屏期间继续累计；解锁后达标并结算', () {
      final s = _stateWith(Emotion.anxious, Bond(minutes: 0));
      final c = GameCore(s, rng: _FixedRandom());
      var now = DateTime(2026, 9, 25, 10, 0);
      c.startFocus(Emotion.anxious, 25, now);

      now = now.add(const Duration(minutes: 10));
      c.focusOnScreenLocked(now);
      expect(s.session!.phase, 'screenLocked');

      now = now.add(const Duration(minutes: 15));
      final events = c.focusOnResumed(now);

      expect(events.whereType<FocusCompleted>().length, 1);
      expect(s.session, isNull);
      expect(s.focusMeta.todayMin, 25);
      expect(s.focusMeta.glancesToday, 0);
      expect(s.pets[Emotion.anxious]!.bond.minutes, 25);
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
