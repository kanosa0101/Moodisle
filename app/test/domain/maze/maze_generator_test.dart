import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/engine/maze/maze_generator.dart';
import 'package:moodisle_app/domain/engine/maze/maze_models.dart';
import 'package:moodisle_app/domain/engine/maze/maze_solver.dart';
import 'package:moodisle_app/domain/engine/maze/zone_tuning.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/rng/seed_registry.dart';
import 'package:moodisle_app/domain/time/local_date.dart';

/// docs/04 §7 测试矩阵：属性测试（1000 种子全可解）+ 不变式 I1–I7
/// + 确定性 + 参数扫描 + 求解器语义。
void main() {

  MazeData gen(int zi, int seed) => MazeGenerator.generate(
      zoneIndex: zi, startLevel: startLevelFor(3, PetStage.clear), seed: seed);

  void checkInvariants(MazeData m, String tag) {
    for (var i = 0; i < m.floors.length; i++) {
      final f = m.floors[i];
      final reason = '$tag floor$i';

      // I1（强形式）：全部门视为墙时出口仍可达 ⇒ 出口永不依赖门
      if (f.grid.any((row) => row.contains(MazeTile.door))) {
        expect(
          MazeGenerator.reachIgnoring(f.grid, f.start, f.w, f.h)
              .contains(f.exit.key),
          isTrue,
          reason: '$reason: I1 出口依赖门',
        );
      }

      // I2：陷阱格视为墙后出口仍可达
      f.items.forEach((k, item) {
        if (item.kind != MazeItemKind.trap) return;
        expect(
          MazeGenerator.reachIgnoring(f.grid, f.start, f.w, f.h,
                  extraBlocked: k)
              .contains(f.exit.key),
          isTrue,
          reason: '$reason: I2 陷阱破坏可解 $k',
        );
      });

      // I3：钥匙数 ≥ 门数；钥匙全部在不穿门可达区
      var doors = 0;
      var keys = 0;
      final doorless = MazeGenerator.reachIgnoring(f.grid, f.start, f.w, f.h);
      f.items.forEach((k, item) {
        if (item.kind == MazeItemKind.key) {
          keys++;
          expect(doorless.contains(k), isTrue, reason: '$reason: I3 钥匙在门外 $k');
        }
      });
      for (final row in f.grid) {
        for (final t in row) {
          if (t == MazeTile.door) doors++;
        }
      }
      expect(keys >= doors, isTrue, reason: '$reason: I3 钥匙 $keys < 门 $doors');

      // I5：该层以当层起手等级必可解
      final r = MazeSolver.solve(f, m.floorStartLevels[i]);
      expect(r.ok, isTrue, reason: '$reason: I5 不可解');

      // I6：Boss 邻接出口且为地板格
      if (f.bossPos != null) {
        final adj = neighbors(f.exit.x, f.exit.y, f.w, f.h)
            .map((n) => n.key)
            .contains(f.bossPos!.key);
        expect(adj, isTrue, reason: '$reason: I6 Boss 不邻接出口');
        expect(f.tileAt(f.bossPos!.x, f.bossPos!.y), MazeTile.floor,
            reason: '$reason: I6 Boss 格非地板');
      }

      // I7：怪等级 ≥ 1
      f.foes.forEach((k, foe) {
        expect(foe.level >= 1, isTrue, reason: '$reason: I7 $k 等级 ${foe.level}');
      });

      // 传送对两端都在不穿门可达区（不跨门桥接区域）
      f.portals.forEach((k, target) {
        expect(doorless.contains(k), isTrue, reason: '$reason: 传送端 $k 在门外');
        expect(doorless.contains(target), isTrue, reason: '$reason: 传送端 $target 在门外');
      });
    }

    // 层间衔接：floorStartLevels 长度一致；终局等级 = 最后一层求解终值
    expect(m.floorStartLevels.length, m.floors.length);
    final lastSolve =
        MazeSolver.solve(m.floors.last, m.floorStartLevels.last);
    expect(m.endLevel, lastSolve.finalLevel);
  }

  test('属性测试：10 区 × 100 种子全部生成成功、可解、满足不变式', () {
    var count = 0;
    for (var zi = 0; zi < 10; zi++) {
      for (var seed = 0; seed < 100; seed++) {
        final m = gen(zi, seed);
        expect(m.floors.length, tuningFor(zi).floorCount,
            reason: 'zi=$zi seed=$seed 层数不符');
        checkInvariants(m, 'zi=$zi seed=$seed');
        count++;
      }
    }
    expect(count, 1000);
  });

  test('确定性：同种子两次生成指纹一致；不同种子大概率不同', () {
    final a = gen(8, 42);
    final b = gen(8, 42);
    final c = gen(8, 43);
    final fa = a.floors.map((f) => f.fingerprint()).join('#');
    final fb = b.floors.map((f) => f.fingerprint()).join('#');
    final fc = c.floors.map((f) => f.fingerprint()).join('#');
    expect(fa, fb);
    expect(fa == fc, isFalse);
  });

  test('参数扫描：起手等级 2–30 全部可解（降级兜底路径）', () {
    for (var zi = 0; zi < 10; zi++) {
      for (final lv in [2, 5, 10, 20, 30]) {
        final m = MazeGenerator.generate(
            zoneIndex: zi, startLevel: lv, seed: 7);
        checkInvariants(m, 'zi=$zi lv=$lv');
      }
    }
  });

  test('求解器语义：空图直达出口 → 立即可解且等级不变', () {
    final grid = List.generate(
        3, (_) => List.filled(3, MazeTile.floor));
    final f = FloorData(
      w: 3,
      h: 3,
      grid: grid,
      start: const MazePos(0, 1),
      exit: const MazePos(2, 1),
      foes: {},
      items: {},
      portals: {},
      warps: {},
    );
    final r = MazeSolver.solve(f, 7);
    expect(r.ok, isTrue);
    expect(r.finalLevel, 7);
  });

  test('求解器语义：Boss 镇守出口时必须吞并 Boss 才算可解', () {
    final grid = List.generate(
        3, (_) => List.filled(3, MazeTile.floor));
    final foes = <String, MazeFoe>{
      // Boss 邻接出口且等级远超起手 → 贪心无解
      '2,1': const MazeFoe(99, FoeKind.boss),
    };
    final f = FloorData(
      w: 3,
      h: 3,
      grid: grid,
      start: const MazePos(0, 1),
      exit: const MazePos(2, 1),
      foes: foes,
      items: {},
      portals: {},
      warps: {},
      bossPos: const MazePos(2, 1),
    );
    final r = MazeSolver.solve(f, 5);
    expect(r.ok, isFalse, reason: 'Boss Lv99 镇守且打不过 → 必须判死局');
  });

  test('mazeSeed：同日同区一致；跨日/跨区不同', () {
    const d1 = LocalDate(2026, 9, 26);
    const d2 = LocalDate(2026, 9, 27);
    final s1 = mazeSeed(d1, 3);
    expect(s1, mazeSeed(d1, 3));
    expect(s1 == mazeSeed(d2, 3), isFalse);
    expect(s1 == mazeSeed(d1, 4), isFalse);
  });
}
