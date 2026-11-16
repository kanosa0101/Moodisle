import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/data/save_codec.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/entities/task.dart';
import 'package:moodisle_app/domain/game_core.dart';
import 'package:moodisle_app/domain/time/local_date.dart';
import 'package:moodisle_app/presentation/task_date_groups.dart';

void main() {
  test('跨日完成记录实际完成日，重复完成不修改原日期', () {
    final state = GameState.fresh();
    final core = GameCore(state);
    core.addTask('跨日任务', Emotion.sloth, 1, DateTime(2026, 11, 15, 23, 59));
    core.completeTask(1, now: DateTime(2026, 11, 16, 0, 1));
    core.completeTask(1, now: DateTime(2026, 11, 17));
    expect(state.tasks.single.createdOn, const LocalDate(2026, 11, 15));
    expect(state.tasks.single.completedOn, const LocalDate(2026, 11, 16));
    final restored = decodeSave(encodeSave(state));
    expect(restored.tasks.single.completedOn, state.tasks.single.completedOn);
    expect(state.tasks.single.copyWith(status: TaskStatus.pending).completedOn,
        isNull);
  });

  test('旧存档完成日期保持未知，分组不能伪造为创建日期', () {
    final state = GameState.fresh();
    final core = GameCore(state);
    core.addTask('历史任务', Emotion.sloth, 1, DateTime(2026, 10, 1));
    core.completeTask(1, now: DateTime(2026, 10, 5));
    final json = saveToJson(state);
    ((json['tasks'] as List).single as Map).remove('completedOn');
    final restored = decodeSave(jsonEncode(json));
    final groups = groupTasksByDate(restored.tasks, TaskStatus.done);
    expect(groups.single.day, isNull);
    expect(restored.tasks.single.createdOn, const LocalDate(2026, 10, 1));
  });

  test('按日期倒序分组，组内置顶优先且不改变原始任务顺序', () {
    final tasks = [
      for (final (id, day, pin) in [
        (1, 15, false),
        (2, 16, false),
        (3, 16, true)
      ])
        Task(
            id: id,
            text: '$id',
            emotion: Emotion.sloth,
            difficulty: 1,
            createdOn: LocalDate(2026, 11, day),
            pinned: pin),
    ];
    final groups = groupTasksByDate(tasks, TaskStatus.pending);
    expect(groups.map((g) => g.day),
        [const LocalDate(2026, 11, 16), const LocalDate(2026, 11, 15)]);
    expect(groups.first.tasks.map((t) => t.id), [3, 2]);
    expect(tasks.map((t) => t.id), [1, 2, 3]);
  });
}
