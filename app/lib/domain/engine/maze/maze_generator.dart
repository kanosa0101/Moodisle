/// 心绪回廊程序化生成器（docs/04 §3 设计真源）。
///
/// 管线：布墙 → 连通兜底 → 锁门(口袋) → 层内传送对 → 怪 → 神龛 → 钥匙
///       → 战力道具 → 提灯 → 陷阱 → Boss → 求解器校验（40 次重试 + 降级兜底）。
/// 生成器必须满足 §3.1 不变式 I1–I7（属性测试逐条断言）。
library;

import 'dart:math' as math;

import 'maze_models.dart';
import 'maze_rng.dart';
import 'maze_solver.dart';
import 'zone_tuning.dart';

class MazeGenerator {
  MazeGenerator._();

  /// 生成一座完整多层回廊。
  static MazeData generate(
      {required int zoneIndex, required int startLevel, required int seed}) {
    final tuning = tuningFor(zoneIndex);
    final rng = MazeRng(seed);
    final floors = <FloorData>[];
    final startLevels = <int>[];
    var cursor = startLevel;

    for (var d = 0; d < tuning.floorCount; d++) {
      final isLast = d == tuning.floorCount - 1;
      final floor = _generateFloorWithGuarantee(rng, tuning, d, cursor, isLast);
      floors.add(floor);
      startLevels.add(cursor);
      cursor = MazeSolver.solve(floor, cursor).finalLevel;
    }

    if (tuning.warps > 0 && floors.length >= 3) {
      _placeWarps(floors, tuning.warps, rng);
    }
    return MazeData(
      zoneIndex: zoneIndex,
      tuning: tuning,
      floors: floors,
      floorStartLevels: startLevels,
      startLevel: startLevel,
      endLevel: cursor,
    );
  }

  // ————————————————— 单层 —————————————————

  /// 生成单层并保证可解（I5）：40 次重试 + 逐步压怪降级兜底，绝不产出死局。
  static FloorData _generateFloorWithGuarantee(
      MazeRng rng, ZoneTuning tuning, int depth, int startLevel, bool isLast) {
    for (var attempt = 0; attempt < 40; attempt++) {
      final cand = _genFloor(rng, tuning, depth, startLevel, isLast);
      if (MazeSolver.solve(cand, startLevel).ok) return cand;
    }
    var floor = _genFloor(rng, tuning, depth, startLevel, isLast);
    var k = 0.9;
    while (k >= 0.3 - 1e-9 && !MazeSolver.solve(floor, startLevel).ok) {
      final scaled = <String, MazeFoe>{};
      floor.foes.forEach((key, foe) {
        scaled[key] = MazeFoe(math.max(1, (foe.level * k).round()), foe.kind);
      });
      floor = floor.copyWithFoes(scaled);
      k -= 0.1;
    }
    return floor;
  }

  static FloorData _genFloor(
      MazeRng rng, ZoneTuning tuning, int depth, int startLevel, bool isLast) {
    final w = tuning.size;
    final h = tuning.size;
    final grid = List.generate(h, (_) => List.filled(w, MazeTile.floor));
    final start = MazePos(0, rng.nextInt(h));
    final exit = MazePos(w - 1, rng.nextInt(h));
    bool isAnchor(int x, int y) =>
        (x == start.x && y == start.y) || (x == exit.x && y == exit.y);

    // ① 随机布墙（锚点保持通路）
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        if (!isAnchor(x, y) && rng.next() < tuning.wallPct) {
          grid[y][x] = MazeTile.wall;
        }
      }
    }
    _ensurePath(grid, start, exit, w, h);

    // ② 空地收集（洗牌）
    final open = <MazePos>[];
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        if (grid[y][x] == MazeTile.floor && !isAnchor(x, y)) {
          open.add(MazePos(x, y));
        }
      }
    }
    rng.shuffle(open);
    final used = <String>{};
    final portals = <String, String>{};
    final warps = <String, WarpTarget>{};
    final pockets = <String>[];

    // ③ 距离场（仅墙阻挡；用于怪等级随深度放大与远角排序）
    final dist = _distField(grid, start, w, h);

    // ④ 锁门（I1：阻断后出口仍可达；口袋藏增益）
    if (tuning.keyDoors > 0) {
      _placeDoors(grid, start, exit, open, used, tuning.keyDoors, rng, pockets);
    }

    // ⑤ 层内传送对（两端都落在「不穿门可达区」内，保证不跨门桥接区域）
    final portals_ = portals;
    if (open.length >= 6 && rng.chance(0.5)) {
      final region = reachIgnoring(grid, start, w, h);
      final free = open
          .where((c) =>
              !used.contains(c.key) && region.contains(c.key))
          .toList();
      if (free.length >= 2) {
        final a = free[0];
        final b = free[1];
        portals_[a.key] = b.key;
        portals_[b.key] = a.key;
        used.add(a.key);
        used.add(b.key);
      }
    }

    // ⑥ 怪：数量随难度/深度；等级随距离场放大（先吃近处小怪攒级）
    final foes = <String, MazeFoe>{};
    final items = <String, MazeItem>{};
    final freeCells = open.where((c) => !used.contains(c.key)).length;
    final foeCount = math.min(
        math.max(0, freeCells - 1),
        ((3 + depth) * tuning.foeMul).round() + rng.nextInt(2));
    var placed = 0;
    var biggest = 0;
    for (final c in open) {
      if (placed >= foeCount) break;
      if (used.contains(c.key)) continue;
      final d = dist[c.key] ?? 1;
      final far = math.min(1.5, 0.4 + d * 0.10);
      var lvl = math.max(
          1,
          (startLevel * (0.35 + rng.next() * 0.45) * far * (1 + depth * 0.22))
              .round());
      var kind = FoeKind.normal;
      if (rng.next() < tuning.eliteChance) {
        kind = FoeKind.elite;
        lvl = math.max(1, (lvl * 1.5).round());
      }
      foes[c.key] = MazeFoe(lvl, kind);
      if (lvl > biggest) biggest = lvl;
      used.add(c.key);
      placed++;
    }

    // ⑦ 神龛：优先藏进门后口袋（I4），其余落远角
    var shrineLeft = tuning.shrines;
    int shrineVal() =>
        math.max(2, (startLevel * (0.4 + rng.next() * 0.4)).round());
    for (final pk in pockets) {
      if (shrineLeft <= 0) break;
      final p = pk.split(',');
      final px = int.parse(p[0]);
      final py = int.parse(p[1]);
      if (grid[py][px] != MazeTile.floor) continue; // 口袋键可能撞上已变门格
      if (items.containsKey(pk) || foes.containsKey(pk)) continue;
      items[pk] = MazeItem(MazeItemKind.shrine, shrineVal());
      shrineLeft--;
    }
    if (shrineLeft > 0) {
      final far = open.where((c) => !used.contains(c.key)).toList()
        ..sort((a, b) => (dist[b.key] ?? 0).compareTo(dist[a.key] ?? 0));
      for (final c in far) {
        if (shrineLeft <= 0) break;
        items[c.key] = MazeItem(MazeItemKind.shrine, shrineVal());
        used.add(c.key);
        shrineLeft--;
      }
    }

    // ⑧ 钥匙：全部放在「不穿门即可达」区（I3）
    var doorCount = 0;
    for (final row in grid) {
      for (final t in row) {
        if (t == MazeTile.door) doorCount++;
      }
    }
    if (doorCount > 0) {
      final keyRegion = reachIgnoring(grid, start, w, h);
      final keyCells = open
          .where((c) =>
              !used.contains(c.key) &&
              keyRegion.contains(c.key) &&
              !foes.containsKey(c.key))
          .toList();
      rng.shuffle(keyCells);
      var keysPlaced = 0;
      for (final c in keyCells) {
        if (keysPlaced >= doorCount) break;
        items[c.key] = const MazeItem(MazeItemKind.key, 1);
        used.add(c.key);
        keysPlaced++;
      }
      // 钥匙格不足时降级多余门为地板（维持 I3：钥匙数 ≥ 门数）
      if (keysPlaced < doorCount) {
        var toRevert = doorCount - keysPlaced;
        for (var y = 0; y < h && toRevert > 0; y++) {
          for (var x = 0; x < w && toRevert > 0; x++) {
            if (grid[y][x] == MazeTile.door) {
              grid[y][x] = MazeTile.floor;
              toRevert--;
            }
          }
        }
      }
    }

    // ⑨ 战力道具（垫脚石）
    final powerCount = 1 + rng.nextInt(2);
    var pc = 0;
    for (final c in open) {
      if (pc >= powerCount) break;
      if (used.contains(c.key)) continue;
      items[c.key] = MazeItem(MazeItemKind.power,
          math.max(1, (startLevel * (0.2 + rng.next() * 0.3)).round()));
      used.add(c.key);
      pc++;
    }

    // ⑩ 迷雾提灯（zi>=4 的迷雾模式）
    var lc = tuning.lanterns;
    for (final c in open) {
      if (lc <= 0) break;
      if (used.contains(c.key)) continue;
      items[c.key] = const MazeItem(MazeItemKind.lantern, 1);
      used.add(c.key);
      lc--;
    }

    // ⑪ 陷阱：只落在「视为墙后出口仍可达」的格（I2，求解器永远绕行）
    var trapsLeft = tuning.traps;
    for (final c in open) {
      if (trapsLeft <= 0) break;
      if (used.contains(c.key)) continue;
      if (!reachIgnoring(grid, start, w, h, extraBlocked: c.key)
          .contains(exit.key)) {
        continue;
      }
      items[c.key] = MazeItem(MazeItemKind.trap,
          math.max(1, (startLevel * (0.15 + rng.next() * 0.25)).round()));
      used.add(c.key);
      trapsLeft--;
    }

    // ⑫ Boss：最后一层镇守出口邻格（I6）
    MazePos? bossPos;
    if (isLast) {
      final cands = neighbors(exit.x, exit.y, w, h)
          .where((n) =>
              grid[n.y][n.x] == MazeTile.floor &&
              !foes.containsKey(n.key) &&
              !items.containsKey(n.key) &&
              !portals.containsKey(n.key) &&
              !(n.x == start.x && n.y == start.y))
          .toList();
      if (cands.isNotEmpty) {
        final c = cands[rng.nextInt(cands.length)];
        final bossLvl = math.max(startLevel + 2,
            (startLevel * 1.3 + biggest * 1.1 + depth * 2).round());
        foes[c.key] = MazeFoe(bossLvl, FoeKind.boss);
        bossPos = c;
      }
    }

    return FloorData(
      w: w,
      h: h,
      grid: grid,
      start: start,
      exit: exit,
      foes: foes,
      items: items,
      portals: portals,
      warps: warps,
      bossPos: bossPos,
    );
  }

  // ————————————————— 放置与工具 —————————————————

  /// 「门视为墙」的可达区（忽略怪/道具；[extraBlocked] 额外当墙）。
  static Set<String> reachIgnoring(List<List<MazeTile>> grid, MazePos start,
      int w, int h,
      {String? extraBlocked}) {
    final seen = <String>{start.key};
    final q = <MazePos>[start];
    while (q.isNotEmpty) {
      final c = q.removeAt(0);
      for (final n in neighbors(c.x, c.y, w, h)) {
        final nk = n.key;
        if (seen.contains(nk)) continue;
        final t = grid[n.y][n.x];
        if (t == MazeTile.wall || t == MazeTile.door) continue;
        if (extraBlocked != null && nk == extraBlocked) continue;
        seen.add(nk);
        q.add(n);
      }
    }
    return seen;
  }

  /// BFS 距离场（仅墙阻挡）。
  static Map<String, int> _distField(
      List<List<MazeTile>> grid, MazePos start, int w, int h) {
    final dist = <String, int>{start.key: 0};
    final q = <MazePos>[start];
    while (q.isNotEmpty) {
      final c = q.removeAt(0);
      final d = dist[c.key]!;
      for (final n in neighbors(c.x, c.y, w, h)) {
        if (grid[n.y][n.x] == MazeTile.wall) continue;
        if (dist.containsKey(n.key)) continue;
        dist[n.key] = d + 1;
        q.add(n);
      }
    }
    return dist;
  }

  /// 连通兜底：出口不可达则凿 L 形通路。
  static void _ensurePath(List<List<MazeTile>> grid, MazePos start,
      MazePos exit, int w, int h) {
    if (reachIgnoring(grid, start, w, h).contains(exit.key)) return;
    var x = start.x;
    var y = start.y;
    while (x != exit.x) {
      x += exit.x > x ? 1 : -1;
      grid[y][x] = MazeTile.floor;
    }
    while (y != exit.y) {
      y += exit.y > y ? 1 : -1;
      grid[y][x] = MazeTile.floor;
    }
  }

  /// 锁门放置：门只落在「把该门视为墙后出口仍可达」的连接格（I1），
  /// 门后隔出的口袋挑一格登记（藏神龛）；口袋格预留给奖励。
  static void _placeDoors(
      List<List<MazeTile>> grid,
      MazePos start,
      MazePos exit,
      List<MazePos> open,
      Set<String> used,
      int count,
      MazeRng rng,
      List<String> pockets) {
    final w = grid[0].length;
    final h = grid.length;
    final cands =
        open.where((c) => !used.contains(c.key)).toList();
    rng.shuffle(cands);
    var placed = 0;
    for (final c in cands) {
      if (placed >= count) break;
      final ck = c.key;
      final before = reachIgnoring(grid, start, w, h);
      if (!before.contains(ck)) continue;
      final after = reachIgnoring(grid, start, w, h, extraBlocked: ck);
      if (!after.contains(exit.key)) continue;
      final pocket =
          before.where((k) => k != ck && !after.contains(k)).toList();
      if (pocket.isEmpty || pocket.contains(exit.key)) continue;
      grid[c.y][c.x] = MazeTile.door;
      used.add(ck);
      pockets.add(pocket[rng.nextInt(pocket.length)]);
      for (final o in open) {
        if (pocket.contains(o.key)) used.add(o.key);
      }
      placed++;
    }
  }

  /// 跨层传送门：早层空闲格 → 跳过 ≥1 层直达目标层入口（放弃中间层奖励）。
  static void _placeWarps(List<FloorData> floors, int count, MazeRng rng) {
    var made = 0;
    for (var attempt = 0; attempt < count * 4 && made < count; attempt++) {
      final i = rng.nextInt(floors.length - 2);
      final j = i + 2 + rng.nextInt(floors.length - 2 - i);
      if (j >= floors.length) continue;
      final f = floors[i];
      final cells = <MazePos>[];
      for (var y = 0; y < f.h; y++) {
        for (var x = 0; x < f.w; x++) {
          if (f.grid[y][x] != MazeTile.floor) continue;
          final k = cellKey(x, y);
          if ((x == f.start.x && y == f.start.y) ||
              (x == f.exit.x && y == f.exit.y)) {
            continue;
          }
          if (f.foes.containsKey(k) ||
              f.items.containsKey(k) ||
              f.portals.containsKey(k) ||
              f.warps.containsKey(k)) {
            continue;
          }
          cells.add(MazePos(x, y));
        }
      }
      if (cells.isEmpty) continue;
      final c = cells[rng.nextInt(cells.length)];
      f.warps[c.key] = WarpTarget(j, floors[j].start.key);
      made++;
    }
  }
}
