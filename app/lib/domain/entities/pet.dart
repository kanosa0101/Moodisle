/// 精灵成长实体与公式（docs/02 §5、docs/03 §2 设计真源）。
library;
import 'emotion.dart';

/// 形态：晴态(<5) → 虹态(5–9) → 觉醒态(≥10)。阴态为未收服，无记录。
enum PetStage { clear, rainbow, awakened }

/// 觉醒分支：星宿线（稳定坚持）/ 深流线（与雷雨缠斗）。原创命名，禁用原型线名。
enum Branch { constellation, deepcurrent }

/// 羁绊等级累计专注分钟阈值（Lv1..Lv10，docs/02 §2.3）。
const List<int> kBondThresholds = [
  25, 75, 150, 300, 600, 1000, 1600, 2400, 3600, 5200,
];

/// 累计专注分钟 → 羁绊等级（不足 25 为 0：未结缘）。
int bondLevelFor(int minutes) {
  var lv = 0;
  for (final t in kBondThresholds) {
    if (minutes >= t) {
      lv++;
    } else {
      break;
    }
  }
  return lv;
}

/// 同情绪累计完成数 → 形态。
PetStage stageForCount(int count) => count >= 10
    ? PetStage.awakened
    : count >= 5
        ? PetStage.rainbow
        : PetStage.clear;

/// 觉醒分支判定（docs/03 §5 步骤 5；平局判星宿线）。
/// [turmoil] 风雨值 = anxious + chaos 累计完成数；
/// [persistence] 晴耕值 = 连晴天数 + 历史最长共鸣链。
Branch decideBranch({required int turmoil, required int persistence}) =>
    turmoil > persistence ? Branch.deepcurrent : Branch.constellation;

class Bond {
  final int minutes;
  final int level;

  Bond({required this.minutes}) : level = bondLevelFor(minutes);

  Bond addMinutes(int n) => Bond(minutes: minutes + n);

  /// 下一等级还需的分钟数；已满级返回 null。
  int? minutesToNext() {
    final idx = level; // 第 level 级对应 thresholds[level-1]，下一级为 thresholds[level]
    if (idx >= kBondThresholds.length) return null;
    return kBondThresholds[idx] - minutes;
  }
}

class PetRecord {
  final Emotion emotion;
  final int count;
  final PetStage stage;
  final Branch? branch;
  final Bond bond;

  const PetRecord({
    required this.emotion,
    required this.count,
    required this.stage,
    required this.bond,
    this.branch,
  });

  /// 完成一次对应情绪待办：计数 +1，形态随之推导。
  PetRecord incremented() {
    final newCount = count + 1;
    return PetRecord(
      emotion: emotion,
      count: newCount,
      stage: stageForCount(newCount),
      branch: branch,
      bond: bond,
    );
  }

  PetRecord copyWith({
    int? count,
    PetStage? stage,
    Branch? branch,
    Bond? bond,
  }) =>
      PetRecord(
        emotion: emotion,
        count: count ?? this.count,
        stage: stage ?? this.stage,
        branch: branch ?? this.branch,
        bond: bond ?? this.bond,
      );
}
