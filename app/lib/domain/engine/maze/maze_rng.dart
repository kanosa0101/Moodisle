/// 回廊专用可复现随机源（mulberry32 公开算法的自实现版本）。
///
/// 每座回廊一个种子（docs/03 §3：`mazeSeed(localDate, zoneIndex)`），
/// 同种子生成逐格一致——「回廊罗盘」每日比拼与属性测试的基础。
library;

class MazeRng {
  int _s;

  MazeRng(int seed) : _s = seed & 0xFFFFFFFF;

  static int _mask32(int x) => x & 0xFFFFFFFF;

  static int _imul32(int a, int b) => _mask32(a * b);

  /// [0, 1) 均匀分布。
  double next() {
    _s = _mask32(_s + 0x6D2B79F5);
    var t = _s;
    t = _imul32(t ^ (t >>> 15), t | 1);
    t = _mask32(t ^ (t + _imul32(t ^ (t >>> 7), t | 61)));
    return ((t ^ (t >>> 14)) & 0xFFFFFFFF) / 4294967296.0;
  }

  /// [0, max) 整数；max 必须 > 0。
  int nextInt(int max) => (next() * max).floor();

  /// 以概率 p 返回 true。
  bool chance(double p) => next() < p;

  /// Fisher-Yates 洗牌（原地）。
  List<T> shuffle<T>(List<T> list) {
    for (var i = list.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
    return list;
  }
}
