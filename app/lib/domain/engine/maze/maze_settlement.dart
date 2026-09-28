/// 心绪回廊结算公式（docs/04 §6 设计真源）。
library;

import '../../config/game_config.dart';

class MazeSettlement {
  final Map<ItemId, int> loot;
  final int exp;
  final int clearingGain;
  final bool perfect;

  const MazeSettlement({
    required this.loot,
    required this.exp,
    required this.clearingGain,
    required this.perfect,
  });
}

/// 纯函数结算：通关产出（时令掉落由调用方以 [seasonHit]/[seasonItem] 注入，
/// 暖锋/顺风 buff 的消耗由运行时在调用前处理）。
MazeSettlement settleMaze({
  required int kills,
  required int eliteKills,
  required bool bossBeaten,
  required bool perfect,
  required double lootMul,
  required int floorCount,
  required bool fogMode,
  bool seasonHit = false,
  ItemId? seasonItem,
}) {
  final loot = <ItemId, int>{};
  void add(ItemId id, int n) => loot[id] = (loot[id] ?? 0) + n;

  add(ItemId.morningDew, ((1 + kills ~/ 3) * lootMul).round());
  add(ItemId.sunnyCrystal, ((1 + floorCount) * lootMul).round());
  if (eliteKills > 0) add(ItemId.tailwind, eliteKills);
  if (bossBeaten) add(ItemId.knotShard, 1);
  if (perfect) {
    add(ItemId.morningDew, 2);
    add(ItemId.knotShard, 1);
  }
  if (fogMode) add(ItemId.mistDew, 1);
  if (seasonHit && seasonItem != null) add(seasonItem, 1);

  final exp = 20 + kills * 4 + (bossBeaten ? 30 : 0);
  final clearing = 2 + floorCount;
  return MazeSettlement(
      loot: loot, exp: exp, clearingGain: clearing, perfect: perfect);
}
