/// 看岛人等级加成（docs/03 §5 引用；数值真源）。
///
/// 三项加成均设上限，防长线数值膨胀：
/// 每日回廊次数 +4 上限、寻宝率 +20% 上限、点亮效率 +3 上限。
library;

import 'dart:math' as math;

class KeeperPerks {
  final int extraDailyMaze;
  final double lootChance;
  final int lightBonus;
  const KeeperPerks(this.extraDailyMaze, this.lootChance, this.lightBonus);
}

KeeperPerks keeperPerks(int level) {
  final lv = level < 1 ? 1 : level;
  return KeeperPerks(
    math.min(4, (lv - 1) ~/ 3),
    math.min(0.20, ((lv - 1) ~/ 2) * 0.03),
    math.min(3, (lv - 1) ~/ 4),
  );
}

/// 相邻级差文本（升级里程碑弹窗用；跨多级逐级累积）。
List<String> keeperUnlockTexts(int fromLevel, int toLevel) {
  final out = <String>[];
  for (var lv = (fromLevel < 1 ? 1 : fromLevel) + 1; lv <= toLevel; lv++) {
    final prev = keeperPerks(lv - 1);
    final cur = keeperPerks(lv);
    if (cur.extraDailyMaze > prev.extraDailyMaze) out.add('每日回廊次数 +1');
    if (cur.lootChance > prev.lootChance) out.add('寻宝率 +3%');
    if (cur.lightBonus > prev.lightBonus) out.add('点亮效率 +1');
  }
  return out;
}
