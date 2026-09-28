/// 心绪回廊贪心求解器（docs/04 §4 设计真源）。
///
/// 判定「是否存在通关吃级顺序」。完备性论证：等级与已收集/已吞并集合
/// 均单调递增，任何可行解的中间状态都可被「最弱优先」贪心到达，
/// 故贪心失败 ⇒ 无解。
///
/// Boss 语义：Boss 镇守出口（docs/04 §3 步骤 10）——存在 Boss 的层，
/// 出口仅在 Boss 被吞并后才视为可达，与运行时规则一致。
library;

import 'maze_models.dart';

class MazeSolveResult {
  final bool ok;
  final int finalLevel;
  const MazeSolveResult(this.ok, this.finalLevel);
}

class MazeSolver {
  MazeSolver._();

  static MazeSolveResult solve(FloorData f, int startLevel) {
    var level = startLevel;
    final consumed = <String>{};
    final picked = <String>{};
    final opened = <String>{};
    var keys = 0;

    bool walkable(int x, int y) {
      final t = f.tileAt(x, y);
      if (t == MazeTile.wall) return false;
      final k = cellKey(x, y);
      if (t == MazeTile.door && !opened.contains(k)) return false;
      final foe = f.foes[k];
      if (foe != null && !consumed.contains(k)) return false;
      final item = f.items[k];
      if (item != null &&
          item.kind == MazeItemKind.trap &&
          !picked.contains(k)) {
        return false;
      }
      return true;
    }

    Set<String> reach() {
      final seen = <String>{f.start.key};
      final queue = <MazePos>[f.start];
      while (queue.isNotEmpty) {
        final c = queue.removeAt(0);
        final portalTo = f.portals[c.key];
        if (portalTo != null && !seen.contains(portalTo)) {
          final p = portalTo.split(',');
          final tp = MazePos(int.parse(p[0]), int.parse(p[1]));
          seen.add(portalTo);
          queue.add(tp);
        }
        for (final n in neighbors(c.x, c.y, f.w, f.h)) {
          final nk = n.key;
          if (seen.contains(nk) || !walkable(n.x, n.y)) continue;
          seen.add(nk);
          queue.add(n);
        }
      }
      return seen;
    }

    final bossKey = f.bossPos?.key;

    for (var guard = 0; guard < 800; guard++) {
      final reachSet = reach();
      final exitOpen =
          reachSet.contains(f.exit.key) && (bossKey == null || consumed.contains(bossKey));
      if (exitOpen) return MazeSolveResult(true, level);

      var progressed = false;

      // ① 收取所有可达的非陷阱道具（钥匙计数 / 战力·神龛加级）
      for (final e in f.items.entries) {
        final k = e.key;
        if (picked.contains(k)) continue;
        final it = e.value;
        if (it.kind == MazeItemKind.trap) continue;
        if (reachSet.contains(k)) {
          if (it.kind == MazeItemKind.key) {
            keys++;
          } else {
            level += it.val;
          }
          picked.add(k);
          progressed = true;
        }
      }
      if (progressed) continue;

      // ② 有钥匙则开一扇与可达区相邻的门
      if (keys > 0) {
        String? doorK;
        for (var y = 0; y < f.h && doorK == null; y++) {
          for (var x = 0; x < f.w; x++) {
            if (f.tileAt(x, y) != MazeTile.door) continue;
            final k = cellKey(x, y);
            if (opened.contains(k)) continue;
            final adjacent =
                neighbors(x, y, f.w, f.h).any((n) => reachSet.contains(n.key));
            if (adjacent) {
              doorK = k;
              break;
            }
          }
        }
        if (doorK != null) {
          opened.add(doorK);
          keys--;
          continue;
        }
      }

      // ③ 吃掉「与可达区相邻（或经传送阵）且打得过」的最弱怪
      String? target;
      var minLv = 1 << 30; // 哨兵：怪等级远小于此
      for (final e in f.foes.entries) {
        final k = e.key;
        if (consumed.contains(k)) continue;
        if (e.value.level > level) continue;
        final p = k.split(',');
        final fx = int.parse(p[0]);
        final fy = int.parse(p[1]);
        final adjacent =
            neighbors(fx, fy, f.w, f.h).any((n) => reachSet.contains(n.key));
        final viaPortal =
            f.portals.containsKey(k) && reachSet.contains(f.portals[k]!);
        if ((adjacent || viaPortal) && e.value.level < minLv) {
          minLv = e.value.level;
          target = k;
        }
      }
      if (target == null) return MazeSolveResult(false, level);
      level += f.foes[target]!.level;
      consumed.add(target);
    }
    return MazeSolveResult(false, level);
  }
}
