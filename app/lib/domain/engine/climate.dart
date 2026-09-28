/// 情绪气候引擎 —— 纯函数部分（docs/03 §7 设计真源）。
library;
import '../entities/emotion.dart';

/// 气候档位（心雾浓度分档；虹光/极光/星雨/暮雪为叠加显示位，独立判定）。
enum ClimateTier { sunny, mist, denseFog }

/// 心雾浓度 0–100。
/// fog = clamp((stress − relief) / (stress + relief + 4), 0, 1) × 100
double computeFog({required double stress, required double relief}) {
  final denom = stress + relief + 4;
  final raw = (stress - relief) / denom;
  final clamped = raw < 0 ? 0.0 : (raw > 1 ? 1.0 : raw);
  return clamped * 100;
}

ClimateTier tierForFog(double fog) =>
    fog < 30 ? ClimateTier.sunny : fog < 60 ? ClimateTier.mist : ClimateTier.denseFog;

/// 未完成待办的压力分量：difficulty × 情绪权重。
double taskStress(int difficulty, Emotion emotion) =>
    difficulty * emotion.stressWeight;

/// 近 7 天舒缓分量：2×完成数 + 专注分钟/15。
double reliefFrom({required int doneCount7d, required int focusMinutes7d}) =>
    doneCount7d * 2 + focusMinutes7d / 15;

/// 每日雾露投放：浓雾 4、薄雾 2、晴 0；暮雪日 +1；上限 5。
int dailyMistDew(ClimateTier tier, {bool twilightSnow = false}) {
  final base = switch (tier) {
    ClimateTier.denseFog => 4,
    ClimateTier.mist => 2,
    ClimateTier.sunny => 0,
  };
  final v = base + (twilightSnow ? 1 : 0);
  return v < 0 ? 0 : (v > 5 ? 5 : v);
}

/// 气候档位防抖（docs/03 §7）：
/// 切换条件 = 连续 [holdDaysNeeded] 次日重算仍指向新档位，
/// 或单日雾值变化量 |newFog − previousFog| 超过 [jumpThreshold]（剧变立即响应）。
ClimateTier resolveTierWithHysteresis({
  required ClimateTier current,
  required double newFog,
  required double previousFog,
  required int tierHoldDays,
  int holdDaysNeeded = 2,
  double jumpThreshold = 25,
}) {
  final candidate = tierForFog(newFog);
  if (candidate == current) return current;
  if ((newFog - previousFog).abs() > jumpThreshold) return candidate;
  if (tierHoldDays + 1 >= holdDaysNeeded) return candidate;
  return current;
}
