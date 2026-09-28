/// 心绪回廊数据模型（docs/04 §1/§3）。
///
/// 坐标键统一为 `"$x,$y"`；grid[y][x] 行主序。
library;

import 'zone_tuning.dart';

enum MazeTile { floor, wall, door }

enum MazeItemKind { power, shrine, key, trap, lantern }

enum FoeKind { normal, elite, boss }

class MazePos {
  final int x;
  final int y;
  const MazePos(this.x, this.y);

  String get key => '$x,$y';

  @override
  bool operator ==(Object other) =>
      other is MazePos && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x,$y)';
}

String cellKey(int x, int y) => '$x,$y';

/// 四邻（不含对角）。
List<MazePos> neighbors(int x, int y, int w, int h) {
  final r = <MazePos>[];
  if (x > 0) r.add(MazePos(x - 1, y));
  if (x < w - 1) r.add(MazePos(x + 1, y));
  if (y > 0) r.add(MazePos(x, y - 1));
  if (y < h - 1) r.add(MazePos(x, y + 1));
  return r;
}

class MazeFoe {
  final int level;
  final FoeKind kind;
  const MazeFoe(this.level, this.kind);
}

class MazeItem {
  final MazeItemKind kind;
  final int val;
  const MazeItem(this.kind, this.val);
}

class WarpTarget {
  final int toFloor;
  final String toKey;
  const WarpTarget(this.toFloor, this.toKey);
}

class FloorData {
  final int w;
  final int h;
  final List<List<MazeTile>> grid; // grid[y][x]
  final MazePos start;
  final MazePos exit;
  final Map<String, MazeFoe> foes;
  final Map<String, MazeItem> items;
  final Map<String, String> portals; // 单元格 -> 对端单元格键（成对双向）
  final Map<String, WarpTarget> warps; // 单元格 -> 跨层目标
  final MazePos? bossPos;

  const FloorData({
    required this.w,
    required this.h,
    required this.grid,
    required this.start,
    required this.exit,
    required this.foes,
    required this.items,
    required this.portals,
    required this.warps,
    this.bossPos,
  });

  MazeTile tileAt(int x, int y) => grid[y][x];

  FloorData copyWithFoes(Map<String, MazeFoe> newFoes) => FloorData(
        w: w,
        h: h,
        grid: grid,
        start: start,
        exit: exit,
        foes: newFoes,
        items: items,
        portals: portals,
        warps: warps,
        bossPos: bossPos,
      );

  /// 确定性指纹（同种子两次生成必须一致；测试用）。
  String fingerprint() {
    final sb = StringBuffer();
    for (final row in grid) {
      sb.write(row.map((t) => switch (t) {
            MazeTile.floor => '.',
            MazeTile.wall => '#',
            MazeTile.door => 'D',
          }).join());
      sb.write('|');
    }
    String dumpMap<M>(Map<String, M> m, String Function(M) f) {
      final keys = m.keys.toList()..sort();
      return keys.map((k) => '$k:${f(m[k] as M)}').join(';');
    }

    sb.write('F[${dumpMap(foes, (v) => '${v.level}${v.kind.name}')}]');
    sb.write('I[${dumpMap(items, (v) => '${v.kind.name}:${v.val}')}]');
    sb.write('P[${dumpMap(portals, (v) => v)}]');
    sb.write('W[${dumpMap(warps, (v) => '${v.toFloor}@${v.toKey}')}]');
    sb.write('B[${bossPos?.key}]');
    return sb.toString();
  }
}

/// 整座回廊：多层 + 每层起手等级链（docs/04 §3 步骤 12）。
class MazeData {
  final int zoneIndex;
  final ZoneTuning tuning;
  final List<FloorData> floors;
  final List<int> floorStartLevels;
  final int startLevel;

  /// 打完整座回廊（逐层吃满）后的终局等级。
  final int endLevel;

  const MazeData({
    required this.zoneIndex,
    required this.tuning,
    required this.floors,
    required this.floorStartLevels,
    required this.startLevel,
    required this.endLevel,
  });
}
