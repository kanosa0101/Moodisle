/// 游戏内核门面（GameCore）：编排各引擎，是 UI/存储的唯一入口。
///
/// 约定（docs/03 §1）：
///  · 所有方法显式接收 now（可注入时钟）；
///  · 随机经注入 [rng]（灵感时刻/开箱等）；
///  · 写操作入口先 ensureDaily（跨天滚动幂等）；
///  · 返回事件流，UI 只消费事件做演出。
library;

import 'dart:math' as math;
import 'dart:math' show Random;

import 'config/game_config.dart';
import 'config/keeper.dart';
import 'config/roam_config.dart';
import 'engine/climate.dart';
import 'engine/climate_engine.dart';
import 'engine/achievement_engine.dart';
import 'engine/daily_engine.dart';
import 'engine/social_engine.dart';
import 'engine/weekly_engine.dart';
import 'engine/focus_engine.dart';
import 'engine/maze/maze_generator.dart';
import 'engine/maze/maze_runtime.dart';
import 'engine/maze/zone_tuning.dart';
import 'engine/resonance_engine.dart';
import 'entities/emotion.dart';
import 'entities/game_state.dart';
import 'entities/pet.dart';
import 'entities/task.dart';
import 'events/game_events.dart';
import 'rng/seed_registry.dart';
import 'time/local_date.dart';

/// 完成复盘四选一（docs/02 §1.2；可空 = 跳过，无奖励但不打断）。
enum FeedbackKind { relieved, calm, proud, easier }

class GameCore {
  final GameState state;
  final Random rng;

  GameCore(this.state, {Random? rng}) : rng = rng ?? Random(1);

  // ————————————————— 待办 —————————————————

  /// 录入待办：召唤对应情绪精灵（阴态，由渲染层灰化呈现）。
  List<GameEvent> addTask(
      String text, Emotion emotion, int difficulty, DateTime now) {
    if (text.trim().isEmpty) {
      return [const GameNotice('先写下一件要做的事吧～')];
    }
    final t = Task(
      id: state.nextTaskId++,
      text: text,
      emotion: emotion,
      difficulty: difficulty,
      createdOn: LocalDate.today(now),
    );
    state.tasks.insert(0, t);
    return [GameNotice('一只「${emotion.petCn}」登上心屿')];
  }

  /// 完成待办 → 收服管线（docs/03 §5，步骤号见注释）。
  List<GameEvent> completeTask(int id,
      {FeedbackKind? feedback, required DateTime now}) {
    final events = DailyEngine.ensureDaily(state, now);
    final idx = state.tasks
        .indexWhere((t) => t.id == id && t.status == TaskStatus.pending);
    if (idx < 0) {
      events.add(const GameNotice('没有找到这条待办'));
      return events;
    }
    final task = state.tasks[idx];
    // ① 标记完成
    state.tasks[idx] = task.markDone();
    state.stats.totalDone++;

    // ② 精灵计数与形态（两段进化：晴 <5 ≤ 虹 <10 ≤ 觉醒）
    final pet = state.pets[task.emotion] ??
        PetRecord(
            emotion: task.emotion,
            count: 0,
            stage: PetStage.clear,
            bond: Bond(minutes: 0));
    final wasStage = pet.stage;
    var cur = pet.incremented();
    state.pets[task.emotion] = cur;
    final evolved = cur.stage != wasStage;

    // ③⑤ 觉醒时刻判定分支（平局判星宿线）
    if (cur.stage == PetStage.awakened && cur.branch == null) {
      final turmoil = (state.pets[Emotion.anxious]?.count ?? 0) +
          (state.pets[Emotion.chaos]?.count ?? 0);
      final persistence = state.streak.sunnyDays + state.resonance.best;
      cur = cur.copyWith(
          branch: decideBranch(turmoil: turmoil, persistence: persistence));
      state.pets[task.emotion] = cur;
    }
    if (evolved) {
      events.add(EvolutionRevealed(
          emotion: task.emotion, stage: cur.stage, branch: cur.branch));
    }

    // ⑥ 天气共鸣
    final res = ResonanceEngine.advance(state, task.emotion, now);
    final expBonus = res.expBonus;
    final litBonus = res.litBonus;
    if (res.linked && res.len >= 2) {
      state.items[ItemId.prismCrystal] =
          (state.items[ItemId.prismCrystal] ?? 0) + 1; // 共演掉落
      events.add(ResonanceFired(
          prev: res.prev!, current: task.emotion, chainLen: res.len));
    }
    if (res.len == 3) {
      state.items[ItemId.prismCrystal] =
          (state.items[ItemId.prismCrystal] ?? 0) + 1; // 链 3 里程碑
      events.add(const GameNotice('共鸣链 ×3 里程碑：虹晶×1'));
    }
    if (res.len == 5) {
      state.items[ItemId.warmFront] =
          (state.items[ItemId.warmFront] ?? 0) + 1; // 链 5 里程碑
      events.add(const GameNotice('共鸣链 ×5 里程碑：暖锋×1'));
    }

    // ⑦ 连晴（零惩罚：断签只重置计数）
    final today = LocalDate.today(now);
    if (state.streak.lastSunny != today) {
      state.streak.sunnyDays = (state.streak.lastSunny == today.yesterday)
          ? state.streak.sunnyDays + 1
          : 1;
      state.streak.lastSunny = today;
    }

    // ⑧⑨ 放晴度：雾天效率 ×1.2；看岛人点亮加成
    final fogBonus = (state.climate.tier == ClimateTier.mist ||
            state.climate.tier == ClimateTier.denseFog)
        ? GameConfig.fogLitMultiplier
        : 1.0;
    final lightBonus = keeperPerks(state.keeper.level).lightBonus;
    final litGain =
        ((GameConfig.clearingPerCapture + lightBonus) * fogBonus).round() +
            litBonus;
    state.clearing = math.min(100.0, state.clearing + litGain);

    // ⑩ 行动力
    state.energy++;

    // ⑪ 经验（灵感时刻 18%）
    var expGain = GameConfig.expPerTask +
        expBonus +
        (feedback != null ? GameConfig.feedbackExp : 0);
    if (rng.nextDouble() < GameConfig.inspirationChance) {
      expGain += GameConfig.inspirationExp;
      events.add(const GameNotice('灵感时刻：额外 +20 经验'));
    }
    events.addAll(grantKeeperExp(expGain));

    // ⑫⑬ 气候重算 + 每日任务推进
    ClimateEngine.bucketFor(state, today).done += 1;
    events.addAll(ClimateEngine.recompute(state, now));
    DailyEngine.bumpQuest(state, 'task', 1);
    DailyEngine.bumpQuest(state, 'chain', res.len);

    // ⑭ 成就扫描 + 汇总事件（UI 主演出）
    for (final a in AchievementEngine.check(state)) {
      events.add(GameNotice('解锁成就「${a.title}」'));
    }
    events.add(TaskCaptured(
      taskId: id,
      emotion: task.emotion,
      newStage: cur.stage,
      evolved: evolved,
      chainLinked: res.linked,
      chainLen: res.len,
      keeperLevelUp: events.any((e) => e is KeeperLevelUp),
    ));
    return events;
  }

  /// 培育：晨露 +1 进度；可选虹晶加速（+1 进度）。跨段派发进化事件。
  List<GameEvent> cultivate(Emotion emotion,
      {bool usePrism = false, required DateTime now}) {
    final events = DailyEngine.ensureDaily(state, now);
    final pet = state.pets[emotion];
    if (pet == null) {
      events.add(const GameNotice('这只精灵还未收服，先完成对应待办吧'));
      return events;
    }
    if (pet.stage == PetStage.awakened) {
      events.add(const GameNotice('它已经培育圆满啦'));
      return events;
    }
    if ((state.items[ItemId.morningDew] ?? 0) < 1) {
      events.add(const GameNotice('晨露不足，去心绪回廊收集吧'));
      return events;
    }
    var inc = 1;
    if (usePrism && (state.items[ItemId.prismCrystal] ?? 0) >= 1) {
      state.items[ItemId.prismCrystal] = state.items[ItemId.prismCrystal]! - 1;
      inc = 2;
    }
    state.items[ItemId.morningDew] = state.items[ItemId.morningDew]! - 1;
    for (var i = 0; i < inc; i++) {
      final was = state.pets[emotion]!;
      if (was.stage == PetStage.awakened) break;
      var cur = was.incremented();
      if (cur.stage == PetStage.awakened && cur.branch == null) {
        final turmoil = (state.pets[Emotion.anxious]?.count ?? 0) +
            (state.pets[Emotion.chaos]?.count ?? 0);
        final persistence = state.streak.sunnyDays + state.resonance.best;
        cur = cur.copyWith(
            branch: decideBranch(turmoil: turmoil, persistence: persistence));
      }
      state.pets[emotion] = cur;
      if (cur.stage != was.stage) {
        events.add(EvolutionRevealed(
            emotion: emotion, stage: cur.stage, branch: cur.branch));
      }
    }
    return events;
  }

  // ————————————————— 看岛人经验 —————————————————

  /// 唯一经验入账点（docs/03 §1 原则 3）。
  List<GameEvent> grantKeeperExp(int n) {
    final events = <GameEvent>[];
    if (n > 0) state.keeper.exp += n;
    while (state.keeper.exp >= GameConfig.expPerLevel) {
      state.keeper.exp -= GameConfig.expPerLevel;
      final from = state.keeper.level;
      state.keeper.level++;
      events.add(KeeperLevelUp(
        from: from,
        to: state.keeper.level,
        unlocks: keeperUnlockTexts(from, state.keeper.level),
      ));
    }
    return events;
  }

  // ————————————————— 道具使用 —————————————————

  List<GameEvent> useItem(ItemId id, DateTime now) {
    final events = DailyEngine.ensureDaily(state, now);
    bool consume(int n) {
      if ((state.items[id] ?? 0) < n) {
        events.add(GameNotice('${id.cn}数量不足'));
        return false;
      }
      state.items[id] = state.items[id]! - n;
      return true;
    }

    switch (id) {
      case ItemId.warmFront:
        if (!consume(1)) return events;
        state.warmFrontTurns += 3;
        events.add(const GameNotice('暖锋！接下来 3 次回廊收获翻倍'));
      case ItemId.tailwind:
        if (!consume(1)) return events;
        state.tailwindTurns += 3;
        events.add(const GameNotice('顺风！接下来 3 次回廊好事不断'));
      case ItemId.knotShard:
        if (!consume(GameConfig.knotShardsPerMica)) return events;
        state.items[ItemId.cloudMica] =
            (state.items[ItemId.cloudMica] ?? 0) + 1;
        events.add(const GameNotice('心结碎片 ×3 合成了云母'));
      case ItemId.cloudMica:
        if (!consume(1)) return events;
        final r = rng.nextDouble();
        if (r < 0.34) {
          events.addAll(grantKeeperExp(GameConfig.cloudMicaExp));
          events.add(const GameNotice('云母化作看岛人 +60 经验'));
        } else if (r < 0.67) {
          state.clearing =
              math.min(100.0, state.clearing + GameConfig.cloudMicaClearing);
          events.add(const GameNotice('云母放晴 +8%'));
        } else {
          state.items[ItemId.morningDew] =
              (state.items[ItemId.morningDew] ?? 0) + 3;
          events.add(const GameNotice('云母化作晨露 ×3'));
        }
      case ItemId.mistDew:
        if (!consume(1)) return events;
        state.clearing =
            math.min(100.0, state.clearing + GameConfig.mistDewClearing);
        final r = rng.nextDouble();
        if (r < 0.34) {
          events.addAll(grantKeeperExp(GameConfig.mistDewExp));
          events.add(const GameNotice('拥抱心情：放晴 +5%，看岛人 +15 经验'));
        } else if (r < 0.67) {
          state.items[ItemId.morningDew] =
              (state.items[ItemId.morningDew] ?? 0) + 1;
          events.add(const GameNotice('拥抱心情：放晴 +5%，晨露 ×1'));
        } else {
          state.items[ItemId.sunnyCrystal] =
              (state.items[ItemId.sunnyCrystal] ?? 0) + 3;
          events.add(const GameNotice('拥抱心情：放晴 +5%，晴晶 ×3'));
        }
      case ItemId.morningDew:
        events.add(const GameNotice('晨露在「图鉴」中喂给伙伴培育进化'));
      case ItemId.prismCrystal:
        events.add(const GameNotice('虹晶用于编队解锁、技能充能与培育加速'));
      case ItemId.stardust:
        events.add(const GameNotice('星屑用于兑换挂件与陪伴外观'));
      case ItemId.lantern:
        events.add(const GameNotice('提灯在心绪回廊中自动生效'));
      case ItemId.sunnyCrystal:
        events.add(const GameNotice('晴晶在装扮商店中使用'));
    }
    return events;
  }

  // ————————————————— 专注（转调 FocusEngine） —————————————————

  List<GameEvent> startFocus(Emotion pet, int planMin, DateTime now) =>
      FocusEngine.start(state, pet, planMin, now);

  List<GameEvent> focusTick(DateTime now) => FocusEngine.tick(state, now);

  List<GameEvent> focusOnBackgrounded(DateTime now) =>
      FocusEngine.onBackgrounded(state, now);

  List<GameEvent> focusOnResumed(DateTime now) =>
      FocusEngine.onResumed(state, now);

  List<GameEvent> cancelFocus(DateTime now) => FocusEngine.cancel(state, now);

  // ————————————————— 心绪回廊 —————————————————

  MazeRun? activeMazeRun;

  /// 今日剩余回廊次数（基础 + 看岛人加成）。
  int dailyMazeLeft([DateTime? now]) {
    now ??= DateTime.now();
    final perks = keeperPerks(state.keeper.level);
    final used =
        state.daily.date == LocalDate.today(now) ? state.daily.mazeToday : 0;
    return math.max(0, GameConfig.baseDailyMaze + perks.extraDailyMaze - used);
  }

  /// 进入回廊：校验解锁/行动力/每日次数 → 扣减 → 种子生成 → 运行时。
  List<GameEvent> startMaze(int zoneIndex, {required DateTime now}) {
    final events = DailyEngine.ensureDaily(state, now);
    final zi = zoneIndex < 0
        ? 0
        : (zoneIndex > kZoneTuning.length - 1
            ? kZoneTuning.length - 1
            : zoneIndex);
    if (state.stats.mazeRuns < kZoneUnlockExp[zi]) {
      events.add(
          GameNotice('累计探索 ${kZoneUnlockExp[zi]} 次后解锁「${kZoneNames[zi]}」'));
      return events;
    }
    if (state.companion == null || state.pets[state.companion] == null) {
      events.add(const GameNotice('先选择一位出战伙伴'));
      return events;
    }
    if (dailyMazeLeft(now) <= 0) {
      events.add(const GameNotice('今日探索次数已用完，明天再来吧～'));
      return events;
    }
    if (state.energy <= 0) {
      events.add(const GameNotice('行动力不足，去完成一个待办吧～'));
      return events;
    }
    state.energy--;
    state.daily.mazeToday++;
    final stage = state.pets[state.companion!]!.stage;
    final startLv = startLevelFor(state.keeper.level, stage);
    final seed = mazeSeed(LocalDate.today(now), zi);
    activeMazeRun = MazeRun(
      MazeGenerator.generate(zoneIndex: zi, startLevel: startLv, seed: seed),
      startLevel: startLv,
      seed: seed,
    );
    events.add(GameNotice('进入「${kZoneNames[zi]}」'));
    return events;
  }

  /// 通关结算：产出/经验/放晴入账，累计探索次数。
  List<GameEvent> finishMaze() {
    final events = <GameEvent>[];
    final run = activeMazeRun;
    if (run == null || run.active) return events;
    final s = run.settlement;
    s!.loot.forEach((id, n) {
      state.items[id] = (state.items[id] ?? 0) + n;
    });
    events.addAll(grantKeeperExp(s.exp));
    state.clearing = math.min(100.0, state.clearing + s.clearingGain);
    state.stats.mazeRuns++;
    // 暖锋/顺风 buff 消耗（每次回廊各扣 1 次）
    if (state.warmFrontTurns > 0) state.warmFrontTurns--;
    if (state.tailwindTurns > 0) state.tailwindTurns--;
    activeMazeRun = null;
    events.add(const GameNotice('安然归来，战利品已入背包'));
    return events;
  }

  /// 放弃本局（行动力已消耗，进度作废）。
  void abandonMaze() {
    activeMazeRun = null;
  }

  // ————————————————— 云游（Idle 派遣） —————————————————

  List<GameEvent> dispatchRoam(Emotion pet, String routeId) =>
      RoamEngine.dispatch(state, pet, routeId, DateTime.now());

  List<GameEvent> claimRoam(int slotIndex) {
    final ev = RoamEngine.claim(state, slotIndex, DateTime.now());
    for (final a in AchievementEngine.check(state)) {
      ev.add(GameNotice('解锁成就「${a.title}」'));
    }
    return ev;
  }

  // ————————————————— 装扮商店（只卖外观） —————————————————

  /// 购买装饰：扣晴晶/星屑 → 纪念品 +1（自动摆上心岛锚点）。已拥有则提示。
  List<GameEvent> buyDecor(String souvenirId) {
    final def = kSouvenirs[souvenirId];
    final item =
        kDecorShop.where((d) => d.souvenirId == souvenirId).firstOrNull;
    final events = <GameEvent>[];
    if (def == null || item == null) {
      events.add(const GameNotice('没有这件装饰'));
      return events;
    }
    if ((state.items[ItemId.sunnyCrystal] ?? 0) < item.costSunny ||
        (state.items[ItemId.stardust] ?? 0) < item.costStardust) {
      events.add(GameNotice(
          '需要晴晶 ×${item.costSunny}${item.costStardust > 0 ? ' + 星屑 ×${item.costStardust}' : ''}，去回廊和专注赚一点吧～'));
      return events;
    }
    state.items[ItemId.sunnyCrystal] =
        (state.items[ItemId.sunnyCrystal] ?? 0) - item.costSunny;
    if (item.costStardust > 0) {
      state.items[ItemId.stardust] =
          (state.items[ItemId.stardust] ?? 0) - item.costStardust;
    }
    state.roam.souvenirs[souvenirId] =
        (state.roam.souvenirs[souvenirId] ?? 0) + 1;
    events.add(GameNotice('已购入「${def.cn}」并摆上心屿！'));
    return events;
  }

  // ————————————————— 群岛社交 —————————————————

  String myPostcardCode() => SocialEngine.encode(
      islandName: state.social.myName,
      pet: state.companion ?? state.pets.keys.firstOrNull ?? Emotion.sloth);

  List<GameEvent> importPostcard(String code) {
    final ev = SocialEngine.importPostcard(state, code, DateTime.now());
    for (final a in AchievementEngine.check(state)) {
      ev.add(GameNotice('解锁成就「${a.title}」'));
    }
    return ev;
  }

  /// 心晴周报（每周最多生成一次；可重复查看 lastReport）。
  WeeklyReport buildWeeklyReport(DateTime now) {
    final report = WeeklyEngine.build(state, now);
    return report;
  }

  void markWeeklyReport(DateTime now) {
    state.lastReportWeek = LocalDate.today(now).mondayOfWeek;
  }

  // ————————————————— 每日 —————————————————

  List<GameEvent> ensureDaily(DateTime now) =>
      DailyEngine.ensureDaily(state, now);

  List<GameEvent> checkin(DateTime now) => DailyEngine.checkin(state, now);

  List<GameEvent> claimQuest(String questId) =>
      DailyEngine.claimQuest(state, questId);

  /// 今日心晴问候（每日一次）。
  List<GameEvent> greet(DateTime now) {
    final today = LocalDate.today(now);
    if (state.daily.lastGreet == today) return <GameEvent>[];
    state.daily.lastGreet = today;
    return [const GameNotice('今日心晴')];
  }
}
