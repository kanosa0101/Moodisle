import '../domain/entities/task.dart';
import '../domain/time/local_date.dart';

class TaskDateGroup {
  final LocalDate? day;
  final List<Task> tasks;
  TaskDateGroup(this.day, this.tasks);
}

/// 共用日期归档：未完成按创建日；已完成按完成日，未知历史日期独立列出。
List<TaskDateGroup> groupTasksByDate(Iterable<Task> tasks, TaskStatus status) {
  final groups = <LocalDate?, List<Task>>{};
  for (final task in tasks.where((task) => task.status == status)) {
    final date =
        status == TaskStatus.pending ? task.createdOn : task.completedOn;
    (groups[date] ??= []).add(task);
  }
  final days = groups.keys.toList()
    ..sort((a, b) {
      if (a == null) return b == null ? 0 : 1;
      if (b == null) return -1;
      return b.compareTo(a);
    });
  return [
    for (final day in days)
      TaskDateGroup(
          day,
          groups[day]!
            ..sort((a, b) {
              if (status == TaskStatus.pending && a.pinned != b.pinned) {
                return a.pinned ? -1 : 1;
              }
              return b.id.compareTo(a.id);
            })),
  ];
}
