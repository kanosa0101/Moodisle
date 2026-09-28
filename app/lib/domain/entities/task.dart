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
  bool pinned;

  Task({
    required this.id,
    required this.text,
    required this.emotion,
    required this.difficulty,
    required this.createdOn,
    this.status = TaskStatus.pending,
    this.pinned = false,
  });

  Task markDone() => copyWith(status: TaskStatus.done);

  Task copyWith({
    int? id,
    String? text,
    Emotion? emotion,
    int? difficulty,
    TaskStatus? status,
    LocalDate? createdOn,
    bool? pinned,
  }) =>
      Task(
        id: id ?? this.id,
        text: text ?? this.text,
        emotion: emotion ?? this.emotion,
        difficulty: difficulty ?? this.difficulty,
        status: status ?? this.status,
        createdOn: createdOn ?? this.createdOn,
        pinned: pinned ?? this.pinned,
      );
}
