/// 专注引擎状态机（docs/03 §8 设计真源）。
///
/// Idle ▶ Focusing ▶ (screenLocked) ScreenLocked ──unlock──▶ Glancing/Focusing
///                    └─ (appBackgrounded) Glancing ▶ resume ▶ Focusing
/// Focusing / ScreenLocked ─ doneMin≥plan ─▶ Completed（结算）▶ Idle
/// 任意活动状态 ─ userCancel ▶ Voided（零惩罚）
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
    if (sess.phase == 'focusing' || sess.phase == 'screenLocked') {
      sess.accumSeconds += now.difference(sess.lastTickAt).inSeconds;
      sess.lastTickAt = now;
      if (sess.doneMin >= sess.planMin) return _complete(s, now);
    }
    return <GameEvent>[];
  }

  /// 手机进入锁屏/息屏：专注继续计时，不要求设备保持常亮。
  ///
  /// Lifecycle 回调可能先于锁屏通知，因此允许短暂后台阶段升级为锁屏阶段。
  static List<GameEvent> onScreenLocked(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null) return <GameEvent>[];

    if (sess.phase == 'glancing') {
      final pausedAt = sess.pausedAt;
      if (pausedAt == null) return <GameEvent>[];
      final transitionDelay = now.difference(pausedAt);
      if (transitionDelay.isNegative ||
          transitionDelay > const Duration(seconds: 2)) {
        return <GameEvent>[];
      }
    } else if (sess.phase != 'focusing') {
      return <GameEvent>[];
    }

    sess.phase = 'screenLocked';
    sess.pausedAt = null;
    return tick(s, now);
  }

  /// 切到其他应用：累计离开前的专注时长后暂停，回来时可继续。
  static List<GameEvent> onBackgrounded(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null || sess.phase != 'focusing') return <GameEvent>[];
    final events = tick(s, now);
    if (s.session == null) return events;
    sess.phase = 'glancing';
    sess.pausedAt = now;
    return [...events, FocusInterrupted(pet: sess.pet)];
  }

  /// 用户解锁后仍停留在其他应用：停止锁屏计时并转为可恢复暂停。
  static List<GameEvent> onScreenUnlocked(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null || sess.phase != 'screenLocked') return <GameEvent>[];

    final events = tick(s, now);
    final unlocked = s.session;
    if (unlocked == null) return events;
    unlocked.phase = 'glancing';
    unlocked.pausedAt = now;
    return [...events, FocusInterrupted(pet: unlocked.pet)];
  }

  /// 回到前台：锁屏期间补算经过时长；应用切换造成的暂停不自动过期。
  static List<GameEvent> onResumed(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null) return <GameEvent>[];

    if (sess.phase == 'screenLocked') {
      final events = tick(s, now);
      final resumed = s.session;
      if (resumed == null) return events;
      resumed.phase = 'focusing';
      resumed.pausedAt = null;
      return [...events, const GameNotice('欢迎回来，继续专注')];
    }

    if (sess.phase == 'glancing') {
      s.focusMeta.glancesToday++;
      sess.phase = 'focusing';
      sess.lastTickAt = now;
      sess.pausedAt = null;
      return [const GameNotice('欢迎回来，继续专注')];
    }
    return <GameEvent>[];
  }

  /// 用户主动放弃（零惩罚，不计张望）。
  static List<GameEvent> cancel(GameState s, DateTime now) {
    final sess = s.session;
    if (sess == null) return <GameEvent>[];
    final events = (sess.phase == 'focusing' || sess.phase == 'screenLocked')
        ? tick(s, now)
        : <GameEvent>[];
    if (s.session == null) return events;
    final pet = sess.pet;
    s.session = null;
    return [...events, FocusVoided(pet: pet)];
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
