/// 每日引擎：跨天滚动 / 签到 / 每日任务（docs/03 §4、docs/02 §9）。
library;

import '../entities/game_state.dart';
import '../config/game_config.dart';
import '../events/game_events.dart';
import '../time/local_date.dart';
import 'climate.dart';
import 'climate_engine.dart';

class DailyEngine {
  DailyEngine._();

  /// 跨天滚动（幂等）：换日则刷新签到标记、每日任务、雾露投放、
  /// 专注日/周计数与 7 日气候窗口。任何写操作入口前调用。
  static List<GameEvent> ensureDaily(GameState s, DateTime now) {
    final today = LocalDate.today(now);
    if (s.daily.date == today) return <GameEvent>[];

    final events = <GameEvent>[];
    final yesterday = today.yesterday;

    // 暮雪判定：昨日完成数 = 0 则连续零完成天数 +1
    final yb = _findBucket(s, yesterday);
    if (yb != null && yb.done == 0) {
      s.climate.zeroDoneStreak++;
    } else {
      s.climate.zeroDoneStreak = 0;
    }

    // 雾露投放（按当前档位 + 暮雪加成，上限 5）
    final dew = dailyMistDew(s.climate.tier,
        twilightSnow: s.climate.zeroDoneStreak >= 3);
    if (dew > 0) {
      s.items[ItemId.mistDew] = (s.items[ItemId.mistDew] ?? 0) + dew;
      s.stats.mistDewCollected += dew;
      events.add(MistDewGranted(dew));
    }

    // 7 日窗口裁剪
    final cutoff = today.addDays(-6);
    s.climate.days.removeWhere((b) => b.date < cutoff);

    // 每日面刷新（签到天数由 lastCheckin 续算，不在此清零）
    s.daily.date = today;
    s.daily.checkedToday = false;
    s.daily.quests.clear();
    for (final q in kDailyQuests) {
      s.daily.quests[q.id] = DailyQuestSlot();
    }

    // 专注日/周计数
    s.focusMeta.todayMin = 0;
    s.daily.mazeToday = 0;
    s.focusMeta.glancesToday = 0;
    final monday = today.mondayOfWeek;
    if (s.focusMeta.weekStart != monday) {
      s.focusMeta.weekStart = monday;
      s.focusMeta.weekMin = 0;
    }

    events.add(DailyRerolled(today));
    events.addAll(ClimateEngine.recompute(s, now));
    return events;
  }

  static ClimateBucket? _findBucket(GameState s, LocalDate d) {
    for (final b in s.climate.days) {
      if (b.date == d) return b;
    }
    return null;
  }

  /// 签到：连续天数靠 lastCheckin 续算，断签零惩罚重置为 1；7 日循环发奖。
  static List<GameEvent> checkin(GameState s, DateTime now) {
    final today = LocalDate.today(now);
    if (s.daily.checkedToday) {
      return [const GameNotice('今天已经签到过啦，明天再来～')];
    }
    s.daily.checkinDays =
        (s.daily.lastCheckin == today.yesterday) ? s.daily.checkinDays + 1 : 1;
    if (s.daily.checkinDays > s.daily.checkinBest) {
      s.daily.checkinBest = s.daily.checkinDays;
    }
    s.daily.checkedToday = true;
    s.daily.lastCheckin = today;
    final rw =
        kCheckinRewards[(s.daily.checkinDays - 1) % kCheckinRewards.length];
    s.items[rw.id] = (s.items[rw.id] ?? 0) + rw.n;
    return [
      GameNotice('签到第 ${s.daily.checkinDays} 天 · 获得${rw.id.cn} ×${rw.n}'),
    ];
  }

  /// 推进每日任务进度（track: task / focus / chain；modeMax 取峰值）。
  static void bumpQuest(GameState s, String track, int value) {
    for (final q in kDailyQuests) {
      if (q.track != track) continue;
      final slot = s.daily.quests[q.id];
      if (slot == null) continue;
      final next = q.modeMax
          ? (value > slot.prog ? value : slot.prog)
          : slot.prog + value;
      slot.prog = next > q.goal ? q.goal : next;
    }
  }

  /// 领取每日任务奖励（达标且未领取）。
  static List<GameEvent> claimQuest(GameState s, String questId) {
    final q = kDailyQuests.where((x) => x.id == questId).firstOrNull;
    final slot = s.daily.quests[questId];
    if (q == null || slot == null) return [const GameNotice('没有这个任务')];
    if (slot.claimed) return [const GameNotice('已经领取过啦')];
    if (slot.prog < q.goal) return [const GameNotice('任务还没完成哦，继续加油～')];
    slot.claimed = true;
    s.items[q.reward] = (s.items[q.reward] ?? 0) + q.rewardN;
    return [GameNotice('领取奖励：${q.reward.cn} ×${q.rewardN}')];
  }
}
