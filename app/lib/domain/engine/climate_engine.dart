/// 气候引擎 · 有状态部分（docs/03 §7）。
/// 压力直接由 pending 待办现算（幂等无漂移），舒缓取 7 日滚动桶。
library;
import '../entities/game_state.dart';
import '../entities/task.dart';
import '../events/game_events.dart';
import '../time/local_date.dart';
import 'climate.dart';

class ClimateEngine {
  ClimateEngine._();

  /// 取（或建）某日的气候桶，保持 days 按日期升序。
  static ClimateBucket bucketFor(GameState s, LocalDate d) {
    for (final b in s.climate.days) {
      if (b.date == d) return b;
    }
    final b = ClimateBucket(d);
    s.climate.days.add(b);
    s.climate.days.sort((a, b2) => a.date.compareTo(b2.date));
    return b;
  }

  static ClimateTierName _name(ClimateTier t) => switch (t) {
        ClimateTier.sunny => ClimateTierName.sunny,
        ClimateTier.mist => ClimateTierName.mist,
        ClimateTier.denseFog => ClimateTierName.denseFog,
      };

  /// 重算心雾与档位（含防抖），必要时派发 ClimateShifted。
  static List<GameEvent> recompute(GameState s, DateTime now) {
    final today = LocalDate.today(now);
    final cutoff = today.addDays(-6);

    double stress = 0;
    for (final t in s.tasks) {
      if (t.status == TaskStatus.pending && t.createdOn >= cutoff) {
        stress += taskStress(t.difficulty, t.emotion);
      }
    }
    var done7 = 0;
    var focusMin7 = 0;
    for (final b in s.climate.days) {
      if (b.date >= cutoff) {
        done7 += b.done;
        focusMin7 += b.focusMin;
      }
    }
    final relief = reliefFrom(doneCount7d: done7, focusMinutes7d: focusMin7);
    final fog = computeFog(stress: stress, relief: relief);
    final previousFog = s.climate.fog;
    s.climate.fog = fog;

    final events = <GameEvent>[];
    final candidate = tierForFog(fog);
    if (candidate == s.climate.tier) {
      s.climate.tierHoldDays = 0;
    } else {
      // 防抖语义：tierHoldDays = 本次之前连续分歧的重算次数。
      // 第 1 次分歧保持原档，第 2 次分歧切换；单日剧变（>25）立即切换。
      final newTier = resolveTierWithHysteresis(
        current: s.climate.tier,
        newFog: fog,
        previousFog: previousFog,
        tierHoldDays: s.climate.tierHoldDays,
      );
      if (newTier != s.climate.tier) {
        events.add(ClimateShifted(
            from: _name(s.climate.tier), to: _name(newTier)));
        s.climate.tier = newTier;
        s.climate.tierHoldDays = 0;
      } else {
        s.climate.tierHoldDays++;
      }
    }
    return events;
  }
}
