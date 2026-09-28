import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/engine/maze/maze_settlement.dart';

void main() {
  test('结算公式（docs/04 §6）：中级回廊带 Boss 完美通关 + 迷雾 + 时令', () {
    final r = settleMaze(
      kills: 6,
      eliteKills: 2,
      bossBeaten: true,
      perfect: true,
      lootMul: 1.4,
      floorCount: 3,
      fogMode: true,
      seasonHit: true,
      seasonItem: ItemId.morningDew,
    );
    // 晨露 = ⌊(1+6/3)⌋=3 → round(3×1.4)=4；完美 +2；时令 +1 → 7
    expect(r.loot[ItemId.morningDew], 4 + 2 + 1);
    // 晴晶 = round((1+3)×1.4) = 6
    expect(r.loot[ItemId.sunnyCrystal], 6);
    expect(r.loot[ItemId.tailwind], 2);
    expect(r.loot[ItemId.knotShard], 2); // Boss 1 + 完美 1
    expect(r.loot[ItemId.mistDew], 1);
    expect(r.exp, 20 + 6 * 4 + 30);
    expect(r.clearingGain, 5);
    expect(r.perfect, isTrue);
  });

  test('结算公式：最简单通关（0 击杀、单层、非完美）', () {
    final r = settleMaze(
      kills: 0,
      eliteKills: 0,
      bossBeaten: false,
      perfect: false,
      lootMul: 1.0,
      floorCount: 1,
      fogMode: false,
    );
    expect(r.loot[ItemId.morningDew], 1);
    expect(r.loot[ItemId.sunnyCrystal], 2);
    expect(r.loot.containsKey(ItemId.tailwind), isFalse);
    expect(r.loot.containsKey(ItemId.knotShard), isFalse);
    expect(r.exp, 20);
    expect(r.clearingGain, 3);
  });
}
