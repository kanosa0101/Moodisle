/// 心绪回廊运行时（docs/04 §5 运行时规则的自研实现）。
///
/// 纯 Dart：移动/吞噬判定/开门/拾取/跨层/撤销重开/通关结算。
/// UI（MazePainter）只消费快照。
library;

import 'maze_models.dart';
import 'maze_generator.dart';
import 'maze_settlement.dart';
import '../../config/game_config.dart';

class MazeRunEvent {
  final String text; // UI toast 文案
  final bool isError;
  const MazeRunEvent(this.text, {this.isError = false});
}

class _Snapshot {
  final MazePos pos;
  final int level;
  final int keys;
  final int steps;
  final int kills;
  final int eliteKills;
  final bool bossBeaten;
  final Set<String> consumed;
  final Set<String> picked;
  final Set<String> opened;

  _Snapshot(MazeRun r)
      : pos = MazePos(r.pos.x, r.pos.y),
        level = r.level,
        keys = r.keys,
        steps = r.steps,
        kills = r.kills,
        eliteKills = r.eliteKills,
        bossBeaten = r.bossBeaten,
        consumed = Set.of(r.consumed),
        picked = Set.of(r.picked),
        opened = Set.of(r.opened);

  _Snapshot.fromJson(Map<String, dynamic> json)
      : pos = _readPos(json['pos']),
        level = (json['level'] as num).toInt(),
        keys = (json['keys'] as num).toInt(),
        steps = (json['steps'] as num).toInt(),
        kills = (json['kills'] as num).toInt(),
        eliteKills = (json['eliteKills'] as num).toInt(),
        bossBeaten = json['bossBeaten'] as bool? ?? false,
        consumed = _readSet(json['consumed']),
        picked = _readSet(json['picked']),
        opened = _readSet(json['opened']);

  Map<String, dynamic> toJson() => {
        'pos': {'x': pos.x, 'y': pos.y},
        'level': level,
        'keys': keys,
        'steps': steps,
        'kills': kills,
        'eliteKills': eliteKills,
        'bossBeaten': bossBeaten,
        'consumed': consumed.toList()..sort(),
        'picked': picked.toList()..sort(),
        'opened': opened.toList()..sort(),
      };
}

MazePos _readPos(Object? raw) {
  final pos = raw as Map<String, dynamic>;
  return MazePos((pos['x'] as num).toInt(), (pos['y'] as num).toInt());
}

Set<String> _readSet(Object? raw) =>
    ((raw as List?) ?? []).map((value) => value as String).toSet();

class MazeRun {
  final MazeData maze;
  final int? seed;
  int fi;
  MazePos pos;
  int level;
  int keys;
  int lanterns; // 迷雾视野加成
  final Set<String> consumed; // "fi:x,y"
  final Set<String> picked;
  final Set<String> opened;
  final List<_Snapshot> _history = [];
  int steps = 0;
  int kills = 0;
  int eliteKills = 0;
  bool bossBeaten = false;
  bool usedUndo = false;
  bool active = true;

  MazeRun(this.maze, {int? startLevel, this.seed})
      : fi = 0,
        pos = MazePos(maze.floors.first.start.x, maze.floors.first.start.y),
        level = startLevel ?? maze.startLevel,
        keys = 0,
        lanterns = 0,
        consumed = {},
        picked = {},
        opened = {};

  Map<String, dynamic> toJson() {
    if (seed == null) {
      throw StateError('MazeRun is missing its generation seed');
    }
    return {
      'zoneIndex': maze.zoneIndex,
      'seed': seed,
      'startLevel': maze.startLevel,
      'fi': fi,
      'pos': {'x': pos.x, 'y': pos.y},
      'level': level,
      'keys': keys,
      'lanterns': lanterns,
      'consumed': consumed.toList()..sort(),
      'picked': picked.toList()..sort(),
      'opened': opened.toList()..sort(),
      'history': _history.map((snapshot) => snapshot.toJson()).toList(),
      'steps': steps,
      'kills': kills,
      'eliteKills': eliteKills,
      'bossBeaten': bossBeaten,
      'usedUndo': usedUndo,
      'active': active,
      'settlement': settlement == null
          ? null
          : {
              'loot': {
                for (final entry in settlement!.loot.entries)
                  entry.key.name: entry.value,
              },
              'exp': settlement!.exp,
              'clearingGain': settlement!.clearingGain,
              'perfect': settlement!.perfect,
            },
    };
  }

  factory MazeRun.fromJson(Map<String, dynamic> json) {
    final zoneIndex = (json['zoneIndex'] as num).toInt();
    final seed = (json['seed'] as num).toInt();
    final startLevel = (json['startLevel'] as num).toInt();
    final maze = MazeGenerator.generate(
        zoneIndex: zoneIndex, startLevel: startLevel, seed: seed);
    final run = MazeRun(maze, startLevel: startLevel, seed: seed)
      ..fi = (json['fi'] as num).toInt();
    final pos = _readPos(json['pos']);
    if (run.fi < 0 || run.fi >= maze.floors.length) {
      throw const FormatException('Invalid active maze floor');
    }
    final floor = maze.floors[run.fi];
    if (pos.x < 0 || pos.y < 0 || pos.x >= floor.w || pos.y >= floor.h) {
      throw const FormatException('Invalid active maze position');
    }
    run
      ..pos = pos
      ..level = (json['level'] as num).toInt()
      ..keys = (json['keys'] as num).toInt()
      ..lanterns = (json['lanterns'] as num?)?.toInt() ?? 0
      ..consumed.addAll(_readSet(json['consumed']))
      ..picked.addAll(_readSet(json['picked']))
      ..opened.addAll(_readSet(json['opened']))
      ..steps = (json['steps'] as num?)?.toInt() ?? 0
      ..kills = (json['kills'] as num?)?.toInt() ?? 0
      ..eliteKills = (json['eliteKills'] as num?)?.toInt() ?? 0
      ..bossBeaten = json['bossBeaten'] as bool? ?? false
      ..usedUndo = json['usedUndo'] as bool? ?? false
      ..active = json['active'] as bool? ?? true;
    if (run.level < 1 || run.keys < 0 || run.lanterns < 0) {
      throw const FormatException('Invalid active maze status');
    }
    for (final rawSnapshot in (json['history'] as List? ?? [])) {
      run._history.add(_Snapshot.fromJson(rawSnapshot as Map<String, dynamic>));
    }
    final rawSettlement = json['settlement'] as Map<String, dynamic>?;
    if (rawSettlement != null) {
      final loot = <ItemId, int>{};
      for (final entry in ((rawSettlement['loot'] as Map?) ?? {}).entries) {
        loot[ItemId.values.byName(entry.key as String)] =
            (entry.value as num).toInt();
      }
      run.settlement = MazeSettlement(
        loot: loot,
        exp: (rawSettlement['exp'] as num).toInt(),
        clearingGain: (rawSettlement['clearingGain'] as num).toInt(),
        perfect: rawSettlement['perfect'] as bool,
      );
    }
    return run;
  }

  FloorData get floor => maze.floors[fi];
  String _k(String cellKey) => '$fi:$cellKey';
  bool _consumed(String k) => consumed.contains(_k(k));
  bool _picked(String k) => picked.contains(_k(k));
  bool _opened(String k) => opened.contains(_k(k));

  /// 某格当前是否可走（[avoidTrap] 供自动寻路绕坑）。
  bool walkable(int x, int y, {bool avoidTrap = false}) {
    final f = floor;
    if (x < 0 || y < 0 || x >= f.w || y >= f.h) return false;
    final t = f.tileAt(x, y);
    if (t == MazeTile.wall) return false;
    final k = cellKey(x, y);
    if (t == MazeTile.door && !_opened(k) && keys <= 0) return false;
    final foe = f.foes[k];
    if (foe != null && !_consumed(k)) return false;
    final item = f.items[k];
    if (avoidTrap &&
        item != null &&
        item.kind == MazeItemKind.trap &&
        !_picked(k)) {
      return false;
    }
    return true;
  }

  /// 两段式寻路：先绕陷阱，不可达再允许踩。
  List<MazePos>? pathTo(int tx, int ty) =>
      _path(tx, ty, true) ?? _path(tx, ty, false);

  List<MazePos>? _path(int tx, int ty, bool avoidTrap) {
    final f = floor;
    if (pos.x == tx && pos.y == ty) return [];
    final prev = <String, (int, int, String)>{};
    final seen = <String>{pos.key};
    final q = <MazePos>[pos];
    while (q.isNotEmpty) {
      final c = q.removeAt(0);
      final ck = c.key;
      void expand(int nx, int ny, String via) {
        final nk = cellKey(nx, ny);
        if (seen.contains(nk)) return;
        final isTarget = nx == tx && ny == ty;
        if (!isTarget && !walkable(nx, ny, avoidTrap: avoidTrap)) return;
        seen.add(nk);
        prev[nk] = (c.x, c.y, via);
        q.add(MazePos(nx, ny));
      }

      final portalTo = f.portals[ck];
      if (portalTo != null) {
        final p = portalTo.split(',');
        expand(int.parse(p[0]), int.parse(p[1]), 'portal');
      }
      for (final n in neighbors(c.x, c.y, f.w, f.h)) {
        expand(n.x, n.y, 'step');
      }
    }
    final tk = cellKey(tx, ty);
    if (!prev.containsKey(tk)) return null;
    final path = <MazePos>[];
    var cur = (tx, ty);
    while (!(cur.$1 == pos.x && cur.$2 == pos.y)) {
      final record = prev[cellKey(cur.$1, cur.$2)]!;
      path.insert(0, MazePos(cur.$1, cur.$2));
      cur = (record.$1, record.$2);
    }
    return path;
  }

  void _pushHistory() {
    _history.add(_Snapshot(this));
    if (_history.length > 200) _history.removeAt(0);
  }

  /// 执行一段路径：逐格处理开门/拾取/吞噬/跨层/楼梯。
  /// 返回 UI 提示；吞 Boss 或抵达通关时 [active] 置 false 并产出 [settlement]。
  MazeSettlement? settlement;

  List<MazeRunEvent> runPath(List<MazePos> path) {
    final events = <MazeRunEvent>[];
    _pushHistory();
    var advanced = false;
    for (final stepPos in path) {
      final f = floor;
      final k = cellKey(stepPos.x, stepPos.y);
      final foe = f.foes[k];
      final liveFoe = foe != null && !_consumed(k);
      if (liveFoe) {
        if (level < foe.level) {
          _restoreLastSnapshot(); // 整段回退（docs/04 §5；不惩罚、不计撤销）
          events.add(MazeRunEvent('等级不足：需 Lv.${foe.level}（当前 Lv.$level）',
              isError: true));
          return events;
        }
        level += foe.level;
        consumed.add(_k(k));
        kills++;
        if (foe.kind == FoeKind.elite) eliteKills++;
        if (foe.kind == FoeKind.boss) bossBeaten = true;
        pos = MazePos(stepPos.x, stepPos.y);
        steps++;
        events.add(MazeRunEvent('战力 +${foe.level}'));
        if (foe.kind == FoeKind.boss) {
          events.add(const MazeRunEvent('心结巨灵被安抚了！'));
          _finishIfLast();
          return events;
        }
        break; // 吃完怪停在原地等待决策
      }
      if (f.tileAt(stepPos.x, stepPos.y) == MazeTile.door && !_opened(k)) {
        if (keys <= 0) {
          _restoreLastSnapshot(); // 整段回退（不惩罚、不计撤销）
          events.add(const MazeRunEvent('需要钥匙才能开门', isError: true));
          return events;
        }
        keys--;
        opened.add(_k(k));
        events.add(const MazeRunEvent('用钥匙开了门'));
      }
      pos = MazePos(stepPos.x, stepPos.y);
      steps++;
      final warp = f.warps[k];
      if (warp != null) {
        fi = warp.toFloor;
        pos = MazePos(maze.floors[fi].start.x, maze.floors[fi].start.y);
        _history.clear();
        events.add(MazeRunEvent('跨层传送 → 第 ${fi + 1} 层'));
        return events;
      }
      final item = f.items[k];
      if (item != null && !_picked(k)) {
        switch (item.kind) {
          case MazeItemKind.power:
            level += item.val;
            events.add(MazeRunEvent('战力 +${item.val}'));
          case MazeItemKind.shrine:
            level += item.val;
            events.add(MazeRunEvent('神龛庇佑 · 战力 +${item.val}'));
          case MazeItemKind.key:
            keys++;
            events.add(const MazeRunEvent('拾得钥匙 ×1'));
          case MazeItemKind.trap:
            level = level - item.val < 1 ? 1 : level - item.val;
            events.add(MazeRunEvent('踩中陷阱 · 战力 −${item.val}', isError: true));
          case MazeItemKind.lantern:
            lanterns++;
            events.add(const MazeRunEvent('提灯 +1，迷雾视野扩大'));
        }
        picked.add(_k(k));
      }
      if (stepPos.x == f.exit.x && stepPos.y == f.exit.y) {
        advanced = true;
        break;
      }
    }
    if (advanced) {
      final reached = _advanceFloor();
      events.add(MazeRunEvent(reached ? '通关！' : '进入第 ${fi + 1} 层'));
    }
    return events;
  }

  bool _finishIfLast() {
    if (fi >= maze.floors.length - 1) {
      active = false;
      settlement = _settle();
      return true;
    }
    return false;
  }

  /// 抵达出口：下层继续或通关（Boss 未击败时出口被镇守，不放行）。
  bool _advanceFloor() {
    if (fi >= maze.floors.length - 1) {
      if (floor.bossPos != null && !bossBeaten) return false;
      active = false;
      settlement = _settle();
      return true;
    }
    fi++;
    pos = MazePos(floor.start.x, floor.start.y);
    _history.clear();
    return false;
  }

  /// 单步移动（方向键/方向垫）。
  List<MazeRunEvent> step(int dx, int dy) {
    final nx = pos.x + dx;
    final ny = pos.y + dy;
    final f = floor;
    if (nx < 0 || ny < 0 || nx >= f.w || ny >= f.h) return const [];
    final k = cellKey(nx, ny);
    final foe = f.foes[k];
    if ((foe != null && !_consumed(k)) || f.warps.containsKey(k)) {
      return runPath([MazePos(nx, ny)]);
    }
    if (!walkable(nx, ny)) {
      return [const MazeRunEvent('过不去', isError: true)];
    }
    return runPath([MazePos(nx, ny)]);
  }

  /// 点击移动：目标格寻路并执行；不可达返回提示。
  List<MazeRunEvent> clickCell(int cx, int cy) {
    final p = pathTo(cx, cy);
    if (p == null) {
      return [const MazeRunEvent('过不去，先清理挡路的怪或绕路', isError: true)];
    }
    if (p.isEmpty) return const [];
    return runPath(p);
  }

  /// 撤销（零惩罚；使用后不计完美通关）。
  bool undo() {
    if (_history.isEmpty) return false;
    _restoreLastSnapshot();
    usedUndo = true;
    return true;
  }

  /// 弹出并应用最近快照（失败回退用：不标记 usedUndo）。
  void _restoreLastSnapshot() {
    final s = _history.removeLast();
    pos = s.pos;
    level = s.level;
    keys = s.keys;
    steps = s.steps;
    kills = s.kills;
    eliteKills = s.eliteKills;
    bossBeaten = s.bossBeaten;
    consumed
      ..clear()
      ..addAll(s.consumed);
    picked
      ..clear()
      ..addAll(s.picked);
    opened
      ..clear()
      ..addAll(s.opened);
  }

  /// 重开本层：清本层作用域状态，回到进层时（零惩罚）。
  void restartFloor() {
    final prefix = '$fi:';
    consumed.removeWhere((k) => k.startsWith(prefix));
    picked.removeWhere((k) => k.startsWith(prefix));
    opened.removeWhere((k) => k.startsWith(prefix));
    pos = MazePos(floor.start.x, floor.start.y);
    _history.clear();
    usedUndo = true;
  }

  /// 当前可达格集合（UI 高亮 + 迷雾裁剪）。
  Set<String> reachable({required int visionRadius, required bool fogMode}) {
    final f = floor;
    final seen = <String>{pos.key};
    final q = <MazePos>[pos];
    while (q.isNotEmpty) {
      final c = q.removeAt(0);
      final portalTo = f.portals[c.key];
      if (portalTo != null && !seen.contains(portalTo)) {
        final p = portalTo.split(',');
        seen.add(portalTo);
        q.add(MazePos(int.parse(p[0]), int.parse(p[1])));
      }
      for (final n in neighbors(c.x, c.y, f.w, f.h)) {
        final nk = n.key;
        if (seen.contains(nk) || !walkable(n.x, n.y)) continue;
        seen.add(nk);
        q.add(n);
      }
    }
    if (fogMode) {
      return seen.where((k) {
        final p = k.split(',');
        final dx = (int.parse(p[0]) - pos.x).abs();
        final dy = (int.parse(p[1]) - pos.y).abs();
        final r = dx > dy ? dx : dy;
        return r <= visionRadius;
      }).toSet();
    }
    return seen;
  }

  MazeSettlement _settle() {
    var pickedAll = true;
    for (var i = 0; i < maze.floors.length; i++) {
      final f = maze.floors[i];
      f.items.forEach((k, item) {
        if (item.kind == MazeItemKind.trap) return; // 陷阱不计入收集
        if (!picked.contains('$i:$k')) pickedAll = false;
      });
    }
    var killedAll = true;
    for (var i = 0; i < maze.floors.length; i++) {
      for (final k in maze.floors[i].foes.keys) {
        if (!consumed.contains('$i:$k')) killedAll = false;
      }
    }
    final perfect = pickedAll && killedAll && !usedUndo;
    return settleMaze(
      kills: kills,
      eliteKills: eliteKills,
      bossBeaten: bossBeaten,
      perfect: perfect,
      lootMul: maze.tuning.lootMul,
      floorCount: maze.floors.length,
      fogMode: maze.tuning.lanterns > 0,
    );
  }
}
