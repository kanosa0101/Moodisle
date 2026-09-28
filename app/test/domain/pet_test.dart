import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/entities/pet.dart';

void main() {
  group('stageForCount（晴<5 ≤ 虹<10 ≤ 觉醒）', () {
    test('边界：4/5/9/10', () {
      expect(stageForCount(1), PetStage.clear);
      expect(stageForCount(4), PetStage.clear);
      expect(stageForCount(5), PetStage.rainbow);
      expect(stageForCount(9), PetStage.rainbow);
      expect(stageForCount(10), PetStage.awakened);
      expect(stageForCount(99), PetStage.awakened);
    });
  });

  group('bondLevelFor（阈值表真源）', () {
    test('未结缘与各级边界', () {
      expect(bondLevelFor(0), 0);
      expect(bondLevelFor(24), 0);
      expect(bondLevelFor(25), 1);
      expect(bondLevelFor(74), 1);
      expect(bondLevelFor(75), 2);
      expect(bondLevelFor(150), 3);
      expect(bondLevelFor(5199), 9);
      expect(bondLevelFor(5200), 10);
      expect(bondLevelFor(99999), 10);
    });

    test('addMinutes 与下一级差值（docs/03 算例 TC-FOC-001）', () {
      final b = Bond(minutes: 50);
      expect(b.level, 1);
      final after = b.addMinutes(25); // 50 + 25 = 75
      expect(after.minutes, 75);
      expect(after.level, 2); // 升入 Lv2 相熟
      expect(after.minutesToNext(), 150 - 75); // 距 Lv3 还需 75 分钟
    });
  });

  group('decideBranch（风雨值 vs 晴耕值，平局判星宿线）', () {
    test('缠斗多 → 深流线', () {
      expect(
          decideBranch(turmoil: 7, persistence: 5), Branch.deepcurrent);
    });

    test('坚持多 → 星宿线', () {
      expect(
          decideBranch(turmoil: 4, persistence: 9), Branch.constellation);
    });

    test('平局 → 星宿线', () {
      expect(
          decideBranch(turmoil: 6, persistence: 6), Branch.constellation);
    });
  });
}
