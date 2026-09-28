import 'dart:math' show Random;

import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/data/save_codec.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/entities/task.dart';
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

(GameState, GameCore) _build() {
  final now = DateTime(2026, 9, 25, 9, 0);
  final s = GameState.fresh();
  final c = GameCore(s, rng: _FixedRandom());
  c.ensureDaily(now);
  c.addTask('写周报', Emotion.anxious, 2, now);
  c.addTask('散步', Emotion.emo, 1, now);
  c.addTask('整理房间', Emotion.sloth, 3, now);
  c.completeTask(1, feedback: FeedbackKind.relieved, now: now);
  s.items[ItemId.morningDew] = 3;
  c.cultivate(Emotion.anxious, now: now); // count 1 → 2
  c.completeTask(2, now: now.add(const Duration(hours: 1))); // 雷→雨 len2
  c.startFocus(
      Emotion.anxious, 25, now.add(const Duration(hours: 1, minutes: 5)));
  c.checkin(now);
  c.greet(now);
  return (s, c);
}

void main() {
  test('存档 v2 roundtrip：编码→解码→再编码 逐字节一致', () {
    final (s, _) = _build();
    final json1 = encodeSave(s);
    final restored = decodeSave(json1);
    expect(encodeSave(restored), json1);
  });

  test('恢复后的档位字段完整', () {
    final (s, _) = _build();
    final restored = decodeSave(encodeSave(s));

    // 任务列表（addTask 头插 → [3,2,1]）
    expect(restored.tasks.length, 3);
    expect(restored.tasks[0].id, 3);
    expect(restored.tasks[2].id, 1);
    expect(restored.tasks[2].status, TaskStatus.done);
    expect(restored.nextTaskId, 4);

    // 精灵与培育
    expect(restored.pets[Emotion.anxious]!.count, 2);
    expect(restored.pets[Emotion.anxious]!.stage, PetStage.clear);

    // 共鸣与经济
    expect(restored.resonance.len, 2);
    expect(restored.resonance.last, Emotion.emo);
    expect(restored.items[ItemId.prismCrystal], 1);
    expect(restored.items[ItemId.morningDew], 2);
    expect(restored.energy, 2);
    expect(restored.clearing, 15.0); // 7 + (7+1)

    // 每日与签到
    expect(restored.daily.checkinDays, 1);
    expect(restored.daily.checkedToday, isTrue);
    expect(restored.daily.lastGreet, const LocalDate(2026, 9, 25));

    // 进行中的专注会话原样恢复
    expect(restored.session, isNotNull);
    expect(restored.session!.pet, Emotion.anxious);
    expect(restored.session!.planMin, 25);
    expect(restored.session!.phase, 'focusing');
  });

  test('恢复后可继续游戏：专注完成 + 第三件待办收服', () {
    final (s, _) = _build();
    final restored = decodeSave(encodeSave(s));
    final c2 = GameCore(restored, rng: _FixedRandom());

    final t = DateTime(2026, 9, 25, 11, 0);
    final events = c2.focusTick(t); // 25min 达标 → 结算
    expect(events.whereType<FocusCompleted>().length, 1);
    expect(restored.session, isNull);
    expect(restored.pets[Emotion.anxious]!.bond.minutes, 25);

    final cap = c2.completeTask(3, now: t.add(const Duration(minutes: 5)));
    expect(cap.whereType<TaskCaptured>().length, 1);
    expect(restored.pets[Emotion.sloth], isNotNull);
    // 雷→雨→雾 len3：共演 + 里程碑 = 虹晶再 +2
    expect(restored.items[ItemId.prismCrystal], 3);
  });
}
