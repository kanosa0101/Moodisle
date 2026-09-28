/// 十回廊难度参数真源（docs/04 §2 表格的代码形态）。
///
/// 本表即数值真源：docs/04 §2 与此表一致；调参先改表再改文档。
library;

import '../../entities/emotion.dart';
import '../../entities/pet.dart';

class ZoneTuning {
  final int zoneIndex;
  final int size; // 边长
  final int floorCount; // 层数
  final double wallPct; // 墙密度
  final double foeMul; // 怪量系数
  final double eliteChance; // 精英率
  final int traps; // 每层陷阱
  final int shrines; // 每层神龛
  final int keyDoors; // 每层钥匙/锁门对
  final int warps; // 跨层传送门
  final int lanterns; // 迷雾模式提灯（zi>=4）
  final double lootMul; // 奖励倍率
  final int tier; // 星级展示 1-3

  const ZoneTuning({
    required this.zoneIndex,
    required this.size,
    required this.floorCount,
    required this.wallPct,
    required this.foeMul,
    required this.eliteChance,
    required this.traps,
    required this.shrines,
    required this.keyDoors,
    required this.warps,
    required this.lanterns,
    required this.lootMul,
    required this.tier,
  });
}

/// 区域解锁所需累计探索次数（docs/02 §6）。
const List<int> kZoneUnlockExp = [0, 3, 6, 10, 15, 21, 28, 36, 45, 55];

/// 十回廊名（docs/02 §6）。
const List<String> kZoneNames = [
  '雷鸣丘', '雨檐巷', '雾径', '霭原', '云顶回廊',
  '涡眼遗迹', '风哨崖', '霜晶洞', '星陨原', '霞光阶',
];

/// 区域对应心结情绪（顺序 = 情绪表顺序）。
const List<Emotion> kZoneEmotions = [
  Emotion.anxious, Emotion.emo, Emotion.sloth, Emotion.burnout, Emotion.neikao,
  Emotion.chaos, Emotion.distract, Emotion.perfect, Emotion.fomo, Emotion.shy,
];

/// zi: size/floorN/wall/foeMul/elite/traps/shrines/doors/warps/lanterns/lootMul/tier
const List<ZoneTuning> kZoneTuning = [
  ZoneTuning(zoneIndex: 0, size: 7, floorCount: 1, wallPct: 0.22, foeMul: 1.00, eliteChance: 0.10, traps: 0, shrines: 0, keyDoors: 0, warps: 0, lanterns: 0, lootMul: 1.00, tier: 1),
  ZoneTuning(zoneIndex: 1, size: 7, floorCount: 1, wallPct: 0.23, foeMul: 1.06, eliteChance: 0.12, traps: 0, shrines: 0, keyDoors: 0, warps: 0, lanterns: 0, lootMul: 1.08, tier: 1),
  ZoneTuning(zoneIndex: 2, size: 7, floorCount: 2, wallPct: 0.24, foeMul: 1.12, eliteChance: 0.14, traps: 1, shrines: 0, keyDoors: 0, warps: 0, lanterns: 0, lootMul: 1.16, tier: 1),
  ZoneTuning(zoneIndex: 3, size: 8, floorCount: 2, wallPct: 0.25, foeMul: 1.18, eliteChance: 0.16, traps: 1, shrines: 1, keyDoors: 0, warps: 0, lanterns: 0, lootMul: 1.24, tier: 1),
  ZoneTuning(zoneIndex: 4, size: 8, floorCount: 2, wallPct: 0.26, foeMul: 1.24, eliteChance: 0.18, traps: 1, shrines: 1, keyDoors: 1, warps: 0, lanterns: 2, lootMul: 1.32, tier: 2),
  ZoneTuning(zoneIndex: 5, size: 8, floorCount: 3, wallPct: 0.27, foeMul: 1.30, eliteChance: 0.20, traps: 2, shrines: 1, keyDoors: 1, warps: 0, lanterns: 2, lootMul: 1.40, tier: 2),
  ZoneTuning(zoneIndex: 6, size: 8, floorCount: 3, wallPct: 0.28, foeMul: 1.36, eliteChance: 0.22, traps: 2, shrines: 1, keyDoors: 1, warps: 0, lanterns: 2, lootMul: 1.48, tier: 2),
  ZoneTuning(zoneIndex: 7, size: 9, floorCount: 3, wallPct: 0.29, foeMul: 1.42, eliteChance: 0.24, traps: 2, shrines: 2, keyDoors: 1, warps: 1, lanterns: 3, lootMul: 1.56, tier: 3),
  ZoneTuning(zoneIndex: 8, size: 9, floorCount: 4, wallPct: 0.30, foeMul: 1.48, eliteChance: 0.26, traps: 3, shrines: 2, keyDoors: 2, warps: 1, lanterns: 3, lootMul: 1.64, tier: 3),
  ZoneTuning(zoneIndex: 9, size: 9, floorCount: 4, wallPct: 0.32, foeMul: 1.54, eliteChance: 0.28, traps: 3, shrines: 2, keyDoors: 2, warps: 1, lanterns: 3, lootMul: 1.72, tier: 3),
];

ZoneTuning tuningFor(int zoneIndex) {
  final zi = zoneIndex < 0
      ? 0
      : (zoneIndex > kZoneTuning.length - 1 ? kZoneTuning.length - 1 : zoneIndex);
  return kZoneTuning[zi];
}

/// 起手战力（docs/04 §2）：base = 2 + ⌊看岛人等级/2⌋，按形态加成。
int startLevelFor(int keeperLevel, PetStage stage) {
  final base = 2 + (keeperLevel < 0 ? 0 : keeperLevel) ~/ 2;
  final bonus = switch (stage) {
    PetStage.clear => 1,
    PetStage.rainbow => 2,
    PetStage.awakened => 3,
  };
  return base + bonus;
}
