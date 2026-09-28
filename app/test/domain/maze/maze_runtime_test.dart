import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/engine/maze/maze_models.dart';
import 'package:moodisle_app/domain/engine/maze/maze_runtime.dart';
import 'package:moodisle_app/domain/engine/maze/zone_tuning.dart';

/// 手工构造的小回廊，验证运行时语义（docs/04 §5）。
FloorData simpleFloor({
  Map<String, MazeFoe>? foes,
  Map<String, MazeItem>? items,
  Map<String, String>? portals,
  MazePos? bossPos,
}) {
  final grid = List.generate(3, (_) => List.filled(5, MazeTile.floor));
  return FloorData(
    w: 5,
    h: 3,
    grid: grid,
    start: const MazePos(0, 1),
    exit: const MazePos(4, 1),
    foes: foes ?? {},
    items: items ?? {},
    portals: portals ?? {},
    warps: {},
    bossPos: bossPos,
  );
}

MazeRun runOf(FloorData f, {int startLevel = 5}) => MazeRun(
      MazeData(
        zoneIndex: 0,
        tuning: stubTuning,
        floors: [f],
        floorStartLevels: [startLevel],
        startLevel: startLevel,
        endLevel: startLevel,
      ),
      startLevel: startLevel,
    );

/// 与 zone 0 等参的测试桩参数。
const ZoneTuning stubTuning = ZoneTuning(
  zoneIndex: 0,
  size: 5,
  floorCount: 1,
  wallPct: 0,
  foeMul: 1,
  eliteChance: 0,
  traps: 0,
  shrines: 0,
  keyDoors: 0,
  warps: 0,
  lanterns: 0,
  lootMul: 1,
  tier: 1,
);

void main() {
  test('吞噬：打得过则吞并等级并前进；打不过则整段回退', () {
    final f = simpleFloor(foes: {'2,1': const MazeFoe(4, FoeKind.normal)});
    final r = runOf(f);
    final ev1 = r.clickCell(2, 1);
    expect(r.level, 9); // 5 + 4
    expect(r.kills, 1);
    expect(r.pos.key, '2,1');
    expect(ev1.where((e) => e.text.startsWith('战力')), isNotEmpty);

    final f2 = simpleFloor(foes: {'2,1': const MazeFoe(99, FoeKind.normal)});
    final r2 = runOf(f2);
    final ev2 = r2.clickCell(2, 1);
    expect(r2.level, 5); // 未吞并
    expect(r2.pos.key, '0,1'); // 回退到起点
    expect(ev2.first.isError, isTrue);
  });

  test('钥匙与门：无钥匙止步，有钥匙开门通行', () {
    final grid = List.generate(3, (_) => List.filled(5, MazeTile.floor));
    grid[1][2] = MazeTile.door;
    grid[0][2] = MazeTile.wall; // 堵住上下绕行 → 门是唯一通路
    grid[2][2] = MazeTile.wall;
    final f = FloorData(
      w: 5,
      h: 3,
      grid: grid,
      start: const MazePos(0, 1),
      exit: const MazePos(4, 1),
      foes: {},
      items: {'1,1': const MazeItem(MazeItemKind.key, 1)},
      portals: {},
      warps: {},
    );
    final r = runOf(f);
    // 无钥匙：到门口为止（3,1 可达，4,1 不可达）
    final ev1 = r.clickCell(4, 1);
    expect(r.opened, isEmpty);
    expect(ev1.any((e) => e.isError), isTrue);
    // 拾钥匙 → 踏门自动开门 → 出口
    r.clickCell(1, 1);
    expect(r.keys, 1);
    final ev2 = r.clickCell(4, 1);
    expect(r.opened, isNotEmpty);
    expect(r.settlement, isNotNull); // 单层无 Boss → 通关
    expect(ev2.any((e) => e.text.contains('通关')), isTrue);
  });

  test('陷阱：寻路优先绕行，被迫踩上时扣战力至下限 1', () {
    final f = simpleFloor(items: {
      '2,1': const MazeItem(MazeItemKind.trap, 3),
      '1,0': const MazeItem(MazeItemKind.power, 2),
    });
    final r = runOf(f);
    r.clickCell(4, 1); // 两段式：第一遍绕开陷阱（经 1,0 → 2,0…）
    expect(r.picked.contains('0:2,1'), isFalse, reason: '寻路应绕开陷阱');
    expect(r.level, greaterThanOrEqualTo(5));
    // 强制踩陷阱：先走到 1,1 再点 2,1（不经 power 1,0）
    final r2 = runOf(f);
    r2.clickCell(1, 1);
    r2.clickCell(2, 1);
    expect(r2.level, 2); // 5 − 3(陷阱)
    expect(r2.picked.contains('0:2,1'), isTrue);
  });

  test('撤销：快照完整回滚且标记 usedUndo', () {
    final f = simpleFloor(foes: {'1,1': const MazeFoe(2, FoeKind.normal)});
    final r = runOf(f);
    r.clickCell(1, 1);
    expect(r.level, 7);
    expect(r.undo(), isTrue);
    expect(r.level, 5);
    expect(r.kills, 0);
    expect(r.consumed, isEmpty);
    expect(r.usedUndo, isTrue);
    expect(r.undo(), isFalse);
  });

  test('重开本层：清空本层作用域状态', () {
    final f = simpleFloor(foes: {'1,1': const MazeFoe(2, FoeKind.normal)});
    final r = runOf(f);
    r.clickCell(1, 1);
    r.restartFloor();
    expect(r.consumed, isEmpty);
    expect(r.pos.key, '0,1');
    expect(r.usedUndo, isTrue);
  });

  test('Boss 镇守：击败 Boss 才结算；结算含完美判定', () {
    final f = simpleFloor(
      foes: {'3,1': const MazeFoe(6, FoeKind.boss)},
      bossPos: const MazePos(3, 1),
    );
    final r = runOf(f, startLevel: 10);
    r.clickCell(4, 1); // 抵达出口但 Boss 未击败 → 不放行
    expect(r.settlement, isNull);
    expect(r.active, isTrue);
    r.clickCell(3, 1); // 击败 Boss → 通关结算
    expect(r.bossBeaten, isTrue);
    expect(r.settlement, isNotNull);
    expect(r.active, isFalse);
    expect(r.settlement!.exp, 20 + 1 * 4 + 30);
  });

  test('神龛/战力道具拾取', () {
    final f = simpleFloor(items: {
      '1,1': const MazeItem(MazeItemKind.shrine, 3),
      '2,1': const MazeItem(MazeItemKind.power, 2),
    });
    final r = runOf(f);
    r.clickCell(4, 1);
    expect(r.level, 10); // 5+3+2
    expect(r.picked.length, 2);
  });
}

