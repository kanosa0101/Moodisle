/// 待办实体（docs/02 §1.2）。
library;

import 'emotion.dart';
import '../time/local_date.dart';

enum TaskStatus { pending, done }

class Task {
  final int id;
  final String text;
  final Emotion emotion;

  /// 1 轻松 / 2 普通 / 3 挑战
  final int difficulty;
  final TaskStatus status;
  final LocalDate createdOn;
  final LocalDate? completedOn;
  bool pinned;

  Task({
    required this.id,
    required this.text,
    required this.emotion,
    required this.difficulty,
    required this.createdOn,
    this.completedOn,
    this.status = TaskStatus.pending,
    this.pinned = false,
  });

  Task markDone(LocalDate day) =>
      copyWith(status: TaskStatus.done, completedOn: day);

  Task copyWith({
    int? id,
    String? text,
    Emotion? emotion,
    int? difficulty,
    TaskStatus? status,
    LocalDate? createdOn,
    LocalDate? completedOn,
    bool? pinned,
  }) =>
      Task(
        id: id ?? this.id,
        text: text ?? this.text,
        emotion: emotion ?? this.emotion,
        difficulty: difficulty ?? this.difficulty,
        status: status ?? this.status,
        createdOn: createdOn ?? this.createdOn,
        completedOn: (status ?? this.status) == TaskStatus.done
            ? completedOn ?? this.completedOn
            : null,
        pinned: pinned ?? this.pinned,
      );
}
