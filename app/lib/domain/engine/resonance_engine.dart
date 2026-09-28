/// 天气共鸣引擎（docs/03 §6 设计真源）。
library;
import '../entities/emotion.dart';
import '../entities/game_state.dart';
import '../config/game_config.dart';
import '../config/weather_cycle.dart';

class ResonanceOutcome {
  final bool linked;
  final int len;
  final int expBonus;
  final int litBonus;
  final Emotion? prev;

  const ResonanceOutcome({
    required this.linked,
    required this.len,
    required this.expBonus,
    required this.litBonus,
    this.prev,
  });
}

class ResonanceEngine {
  ResonanceEngine._();

  /// 推进共鸣链：24h 窗口内完成上一环的相生后继则续链，否则从 1 重计（零惩罚）。
  /// 里程碑赠礼由调用方按返回的 len 发放（len==3 → 虹晶，len==5 → 暖锋，仅跨阈值一次）。
  static ResonanceOutcome advance(
      GameState s, Emotion emotion, DateTime now) {
    final r = s.resonance;
    final prev = r.last;
    final linked = prev != null &&
        nextInCycle(prev) == emotion &&
        (r.lastAt == null ||
            now.difference(r.lastAt!).inMilliseconds <=
                GameConfig.resonanceWindowMs);
    final len = linked ? r.len + 1 : 1;
    r.last = emotion;
    r.len = len;
    r.lastAt = now;
    if (len > r.best) r.best = len;
    final extra = len - 1;
    return ResonanceOutcome(
      linked: linked,
      len: len,
      expBonus: extra > 0 ? extra * GameConfig.resonanceExpStep : 0,
      litBonus: extra > 0 ? extra * GameConfig.resonanceLitStep : 0,
      prev: linked ? prev : null,
    );
  }
}
