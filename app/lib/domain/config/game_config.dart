/// 全局数值真源（docs/02 §8、docs/03 §10）。
/// 改数值只改这里与对应文档，测试算例同步更新。
library;

/// 十类道具（docs/02 §8）。
enum ItemId {
  sunnyCrystal, // 晴晶，通用货币
  stardust, // 星屑，专注独占货币
  morningDew, // 晨露，培育进化素材
  prismCrystal, // 虹晶，共鸣结晶
  mistDew, // 雾露，气候资源
  warmFront, // 暖锋，回廊收获翻倍 buff
  tailwind, // 顺风，回廊好事件 buff
  knotShard, // 心结碎片，×3 合成云母
  cloudMica, // 云母，开箱道具
  lantern, // 提灯，迷宫视野道具
}

extension ItemMeta on ItemId {
  String get cn => switch (this) {
        ItemId.sunnyCrystal => '晴晶',
        ItemId.stardust => '星屑',
        ItemId.morningDew => '晨露',
        ItemId.prismCrystal => '虹晶',
        ItemId.mistDew => '雾露',
        ItemId.warmFront => '暖锋',
        ItemId.tailwind => '顺风',
        ItemId.knotShard => '心结碎片',
        ItemId.cloudMica => '云母',
        ItemId.lantern => '提灯',
      };

  /// 图标资源标识；presentation 层据此选择项目内的贴纸 PNG。
  String get icon => name;
}

class GameConfig {
  GameConfig._();

  // —— 收服管线（docs/03 §5）——
  static const int expPerTask = 25;
  static const int expPerLevel = 100;
  static const int clearingPerCapture = 7; // 基础放晴度
  static const int resonanceExpStep = 10; // 每多一环经验
  static const int resonanceLitStep = 1; // 每多一环放晴
  static const int inspirationExp = 20; // 灵感时刻
  static const double inspirationChance = 0.18;
  static const int feedbackExp = 2; // 完成复盘
  static const double fogLitMultiplier = 1.2; // 雾天完成效率

  // —— 共鸣（docs/03 §6）——
  static const int resonanceWindowMs = 24 * 3600 * 1000;

  // —— 专注（docs/03 §8）——
  static const int focusGraceSeconds = 120; // 张望宽限
  static const List<int> focusPlans = [15, 25, 50];
  static const int focusDeepDiveMinutes = 50;
  static const double focusDeepDiveMul = 1.5;
  static const int stardustPerMinutes = 5; // 每 N 分钟 1 星屑基准

  // —— 回廊（docs/02 §6）——
  static const int baseDailyMaze = 5;

  // —— 经济 ——
  static const int knotShardsPerMica = 3;
  static const int cloudMicaExp = 60;
  static const int cloudMicaClearing = 8;
  static const int mistDewClearing = 5;
  static const int mistDewExp = 15;
}

/// 7 日循环签到奖励（docs/02 §9；第 7 天大奖云母）。
class CheckinReward {
  final ItemId id;
  final int n;
  final bool big;
  const CheckinReward(this.id, this.n, {this.big = false});
}

const List<CheckinReward> kCheckinRewards = [
  CheckinReward(ItemId.sunnyCrystal, 1),
  CheckinReward(ItemId.morningDew, 1),
  CheckinReward(ItemId.sunnyCrystal, 2),
  CheckinReward(ItemId.warmFront, 1),
  CheckinReward(ItemId.tailwind, 1),
  CheckinReward(ItemId.sunnyCrystal, 2),
  CheckinReward(ItemId.cloudMica, 1, big: true),
];

/// 每日任务（docs/02 §9）。modeMax = 取峰值（共鸣链）。
class QuestDef {
  final String id;
  final String title;
  final int goal;
  final String track; // task / focus / chain
  final bool modeMax;
  final ItemId reward;
  final int rewardN;
  const QuestDef(this.id, this.title, this.goal, this.track, this.modeMax,
      this.reward, this.rewardN);
}

const List<QuestDef> kDailyQuests = [
  QuestDef('do3', '完成 3 个待办', 3, 'task', false, ItemId.morningDew, 1),
  QuestDef('focus1', '专注 1 次', 1, 'focus', false, ItemId.sunnyCrystal, 1),
  QuestDef('chain3', '共鸣链达成 ×3', 3, 'chain', true, ItemId.warmFront, 1),
];
