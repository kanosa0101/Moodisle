/// 内核事件目录（docs/03 §11 设计真源）。
/// 内核以事件流通知 UI；UI 只消费事件做演出，绝不反向计算规则。
library;
import '../entities/emotion.dart';
import '../entities/pet.dart';
import '../time/local_date.dart';

sealed class GameEvent {
  const GameEvent();
}

/// 完成待办的收服结果。
class TaskCaptured extends GameEvent {
  final int taskId;
  final Emotion emotion;
  final PetStage newStage;
  final bool evolved; // 本次恰好跨段
  final bool chainLinked;
  final int chainLen;
  final bool keeperLevelUp;

  const TaskCaptured({
    required this.taskId,
    required this.emotion,
    required this.newStage,
    required this.evolved,
    required this.chainLinked,
    required this.chainLen,
    required this.keeperLevelUp,
  });
}

/// 进化揭示（跨段时派发）。
class EvolutionRevealed extends GameEvent {
  final Emotion emotion;
  final PetStage stage;
  final Branch? branch; // 仅觉醒态携带

  const EvolutionRevealed({
    required this.emotion,
    required this.stage,
    this.branch,
  });
}

/// 天气共鸣共演时刻（续链 len≥2 时派发）。
class ResonanceFired extends GameEvent {
  final Emotion prev;
  final Emotion current;
  final int chainLen;

  const ResonanceFired({
    required this.prev,
    required this.current,
    required this.chainLen,
  });
}

/// 专注完成结算。
class FocusCompleted extends GameEvent {
  final Emotion pet;
  final int minutes;
  final int stardust;
  final int bondGain;
  final int? bondLevelUpTo;

  const FocusCompleted({
    required this.pet,
    required this.minutes,
    required this.stardust,
    required this.bondGain,
    this.bondLevelUpTo,
  });
}

/// 专注中断：进入张望宽限（120s）。
class FocusInterrupted extends GameEvent {
  final Emotion pet;
  final int graceSecondsLeft;

  const FocusInterrupted({required this.pet, required this.graceSecondsLeft});
}

/// 专注作废（宽限超时/放弃；零惩罚）。
class FocusVoided extends GameEvent {
  final Emotion pet;

  const FocusVoided({required this.pet});
}

/// 气候档位切换。
class ClimateShifted extends GameEvent {
  final ClimateTierName from;
  final ClimateTierName to;

  const ClimateShifted({required this.from, required this.to});
}

/// 气候档位名（事件层用字符串枚举，避免与 engine 耦合）。
enum ClimateTierName { sunny, mist, denseFog }

/// 看岛人升级（含本跨级解锁文本）。
class KeeperLevelUp extends GameEvent {
  final int from;
  final int to;
  final List<String> unlocks;

  const KeeperLevelUp({
    required this.from,
    required this.to,
    required this.unlocks,
  });
}

/// 跨天滚动完成（签到标记/每日任务/雾露投放均已刷新）。
class DailyRerolled extends GameEvent {
  final LocalDate date;

  const DailyRerolled(this.date);
}

/// 当日雾露已按气候档位投放。
class MistDewGranted extends GameEvent {
  final int count;

  const MistDewGranted(this.count);
}

/// 轻量提示（UI toast 用；不承载规则）。
class GameNotice extends GameEvent {
  final String text;

  const GameNotice(this.text);
}
