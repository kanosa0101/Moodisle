/// 本地日历日期。
///
/// 设计真源：docs/03 §1/§4 —— 全项目禁止 `toUtc` / ISO 截断式日期，
/// 「今天」一律经本类型从设备本地时区取 y/m/d，修复跨时区晨间判定错位问题。
class LocalDate implements Comparable<LocalDate> {
  final int year;
  final int month;
  final int day;

  const LocalDate(this.year, this.month, this.day);

  factory LocalDate.fromDateTime(DateTime dt) =>
      LocalDate(dt.year, dt.month, dt.day);

  /// 设备本地「今天」。测试可注入固定时刻。
  factory LocalDate.today([DateTime? now]) =>
      LocalDate.fromDateTime(now ?? DateTime.now());

  LocalDate addDays(int n) {
    final d = DateTime(year, month, day).add(Duration(days: n));
    return LocalDate(d.year, d.month, d.day);
  }

  LocalDate get yesterday => addDays(-1);
  LocalDate get tomorrow => addDays(1);

  /// ISO 周几：1 = 周一 … 7 = 周日。
  int get weekday => DateTime(year, month, day).weekday;

  /// 本周的周一。
  LocalDate get mondayOfWeek => addDays(-(weekday - 1));

  bool isAdjacentTo(LocalDate other) =>
      other == tomorrow || other == yesterday;

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year - other.year;
    if (month != other.month) return month - other.month;
    return day - other.day;
  }

  bool operator <(LocalDate other) => compareTo(other) < 0;
  bool operator >(LocalDate other) => compareTo(other) > 0;
  bool operator <=(LocalDate other) => compareTo(other) <= 0;
  bool operator >=(LocalDate other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  String get _p2 => day.toString().padLeft(2, '0');

  @override
  String toString() =>
      '$year-${month.toString().padLeft(2, '0')}-$_p2';
}
