/// 种子随机注册表（docs/03 §3 设计真源）。
///
/// 原则：确定性系统（每日回廊/罗盘）用日期派生种子；其余用注入 RNG；
/// 存档不保存 RNG 状态。
library;
import '../time/local_date.dart';

int _mask32(int x) => x & 0xFFFFFFFF;

/// 32 位混合（families of murmur-style finalizer，自实现版本）。
int _mix32(int h) {
  h = _mask32(h ^ (h >> 16));
  h = _mask32(h * 0x85EBCA6B);
  h = _mask32(h ^ (h >> 13));
  h = _mask32(h * 0xC2B2AE35);
  h = _mask32(h ^ (h >> 16));
  return h;
}

/// 某本地日的基准种子。
int dailySeed(LocalDate d) =>
    _mix32(_mask32(d.year * 10000 + d.month * 100 + d.day));

/// 回廊生成种子：每区每日一图（罗盘比拼可复现）。
int mazeSeed(LocalDate d, int zoneIndex) =>
    (dailySeed(d) ^ _mask32(zoneIndex * 2654435761)) & 0x7FFFFFFF;
