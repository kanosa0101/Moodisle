/// 专注引擎状态机（docs/03 §8 设计真源）。
///
/// Idle ▶ Focusing ▶ (appPaused) Glancing ▶ resume≤120s ▶ Focusing
///                    └─ >120s ─▶ Voided（零惩罚）
/// Focusing ─ doneMin≥plan ─▶ Completed（结算）▶ Idle
/// 所有方法显式接收 now（可注入时钟，测试确定）。
library;

import '../entities/emotion.dart';
import '../entities/game_state.dart';
import '../config/game_config.dart';
import '../events/game_events.dart';
import '../time/local_date.dart';
import 'climate_engine.dart';
import 'daily_engine.dart';

class FocusEngine {
  FocusEngine._();

  static double tierMulFor(int planMin) =>
      planMin == GameConfig.focusDeepDiveMinutes
          ? GameConfig.focusDeepDiveMul
          : 1.0;

  static List<GameEvent> start(
      GameState s, Emotion pet, int planMin, DateTime now) {
    if (s.session != null) return [const GameNotice('已有专注进行中')];
    if (s.pets[pet] == null) return [const GameNotice('这只精灵还未收服')];
    s.session = FocusSessionState(
      pet: pet,
      planMin: planMin,
      tierMul: tierMulFor(planMin),
      startedAt: now,
    );
    return [GameNotice('${pet.petCn} 陪你开始专注')];
  }

  /// 心跳：累计聚焦时长；达标即结算。App 侧由定时器驱动。
  static List<GameEvent> tick(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null) return <GameEvent>[];
    if (sess.phase == 'focusing') {
      sess.accumSeconds += now.difference(sess.lastTickAt).inSeconds;
      sess.lastTickAt = now;
      if (sess.doneMin >= sess.planMin) return _complete(s, now);
    }
    return <GameEvent>[];
  }

  /// 进入后台：精灵开始张望（宽限 [GameConfig.focusGraceSeconds] 秒）。
  static List<GameEvent> onBackgrounded(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null || sess.phase != 'focusing') return <GameEvent>[];
    sess.accumSeconds += now.difference(sess.lastTickAt).inSeconds;
    sess.phase = 'glancing';
    sess.pausedAt = now;
    return [
      FocusInterrupted(
          pet: sess.pet, graceSecondsLeft: GameConfig.focusGraceSeconds),
    ];
  }

  /// 回到前台：宽限期内无缝继续；超时作废（零惩罚，记一次张望）。
  static List<GameEvent> onResumed(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null || sess.phase != 'glancing' || sess.pausedAt == null) {
      return <GameEvent>[];
    }
    final away = now.difference(sess.pausedAt!).inSeconds;
    if (away <= GameConfig.focusGraceSeconds) {
      sess.phase = 'focusing';
      sess.lastTickAt = now;
      sess.pausedAt = null;
      return [const GameNotice('欢迎回来，继续专注')];
    }
    s.focusMeta.glancesToday++;
    final pet = sess.pet;
    s.session = null;
    return [
      FocusVoided(pet: pet),
      const GameNotice('它等你太久，先回去岛上了（零惩罚）'),
    ];
  }

  /// 用户主动放弃（零惩罚，不计张望）。
  static List<GameEvent> cancel(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null) return <GameEvent>[];
    if (sess.phase == 'focusing') {
      sess.accumSeconds += now.difference(sess.lastTickAt).inSeconds;
    }
    final pet = sess.pet;
    s.session = null;
    return [FocusVoided(pet: pet)];
  }

  /// 完成结算（docs/03 §8.1）：星屑按结算前羁绊等级计算。
  static List<GameEvent> _complete(GameState s, DateTime now) {
    final sess = s.session!;
    final doneMin = sess.doneMin > sess.planMin ? sess.planMin : sess.doneMin;
    final rec = s.pets[sess.pet]!;
    final preLevel = rec.bond.level;
    final newBond = rec.bond.addMinutes(doneMin);
    s.pets[sess.pet] = rec.copyWith(bond: newBond);

    final stardust = (doneMin /
            GameConfig.stardustPerMinutes *
            sess.tierMul *
            (1 + preLevel * 0.05))
        .floor();
    s.items[ItemId.stardust] = (s.items[ItemId.stardust] ?? 0) + stardust;

    s.focusMeta.todayMin += doneMin;
    s.focusMeta.weekMin += doneMin;
    s.stats.totalFocusSessions++;
    s.stats.totalFocusMinutes += doneMin;
    if (sess.planMin >= 50) s.stats.deepDives++;
    final day = sess.startedAt;
    final todayBucket =
        ClimateEngine.bucketFor(s, LocalDate(day.year, day.month, day.day));
    todayBucket.focusMin += doneMin;

    final pet = sess.pet;
    s.session = null;

    final events = <GameEvent>[
      FocusCompleted(
        pet: pet,
        minutes: doneMin,
        stardust: stardust,
        bondGain: doneMin,
        bondLevelUpTo: newBond.level > preLevel ? newBond.level : null,
      ),
      GameNotice('专注完成，羁绊 +$doneMin 分钟'),
    ];
    DailyEngine.bumpQuest(s, 'focus', 1);
    events.addAll(ClimateEngine.recompute(s, now));
    return events;
  }
}
