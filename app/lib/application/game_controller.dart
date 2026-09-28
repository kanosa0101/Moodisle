/// 应用控制器：GameCore 的 ChangeNotifier 门面（M2 采用轻量观察者，
/// 不引入 Riverpod —— 保持零额外依赖，后续可平滑替换，见 docs/05 §2 微调）。
///
/// 职责：持有状态与内核；驱动 1s 心跳（专注计时）；
/// 收集演出事件供 UI 弹层消费；存档 JSON 的导出/导入（剪贴板/文件）。
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/save_codec.dart';
import '../data/save_store.dart';
import '../domain/config/roam_config.dart';
import '../domain/engine/weekly_engine.dart';
import '../domain/config/game_config.dart';
import '../domain/engine/eco_sim.dart';
import '../domain/engine/maze/maze_runtime.dart';
import '../domain/entities/emotion.dart';
import '../domain/entities/game_state.dart';
import '../domain/entities/task.dart';
import '../domain/events/game_events.dart';
import '../domain/game_core.dart';

class GameController extends ChangeNotifier {
  final GameState state;
  late final GameCore core;
  final EcoSim eco;
  final SaveStore store;
  late final Future<void> ready;
  Timer? _ticker;
  Timer? _saveDebounce;
  String? restoreNotice;

  /// 待展示的收服演出（UI 弹层消费后置空）。
  TaskCaptured? pendingCapture;
  FocusCompleted? pendingFocusDone;

  GameController({GameState? state, Random? rng, SaveStore? store})
      : state = state ?? GameState.fresh(),
        store = store ?? SaveStore(),
        eco = EcoSim() {
    core = GameCore(this.state, rng: rng);
    core.ensureDaily(DateTime.now());
    eco.rebuild(this.state);
    _startTicker();
    ready = restoreFromDisk();
  }

  /// 启动时从磁盘恢复（异步、幂等；Web/不支持平台自动跳过）。
  Future<void> restoreFromDisk() async {
    final raw = await store.load();
    if (store.recoveredFromBackup) {
      restoreNotice = '主存档损坏，已从备份恢复。最近一次自动保存可能缺少最后几秒的进度。';
    } else if (raw == null && store.hadCorruptSave) {
      restoreNotice = '存档无法读取，已启动新存档。若有导出的 JSON，可在「成长 → 存档 → 导入」恢复。';
    }
    if (raw == null) return;
    if (importSaveJson(raw)) {
      core.ensureDaily(DateTime.now());
      eco.rebuild(state);
    } else {
      restoreNotice = '存档内容无法读取，已启动新存档。若有导出的 JSON，可在「成长 → 存档 → 导入」恢复。';
    }
  }

  void _scheduleSave() {
    if (_saveDebounce?.isActive ?? false) return;
    _saveDebounce = Timer(const Duration(seconds: 2), () {
      _saveDebounce = null;
      unawaited(store.save(exportSaveJson()));
    });
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (state.session != null) {
        core.focusTick(now);
        _scheduleSave();
        final done = state.session == null;
        if (done) {
          // 结算事件提取（FocusCompleted 在事件流里）
          pendingFocusDone ??= _lastFocusCompleted;
        }
      }
      super.notifyListeners();
    });
  }

  FocusCompleted? _lastFocusCompleted;

  // ——— 演出抽取 ———
  void _consume(List<GameEvent> events) {
    for (final e in events) {
      if (e is TaskCaptured) pendingCapture = e;
      if (e is FocusCompleted) _lastFocusCompleted = e;
    }
  }

  void clearCapture() {
    pendingCapture = null;
    notifyListeners();
  }

  void clearFocusDone() {
    pendingFocusDone = null;
    _lastFocusCompleted = null;
    notifyListeners();
  }

  // ——— 待办 ———
  void addTask(String text, Emotion emotion, int difficulty) {
    if (text.trim().isEmpty) return;
    _consume(core.addTask(text.trim(), emotion, difficulty, DateTime.now()));
    eco.rebuild(state);
    notifyListeners();
  }

  void togglePin(int id) {
    final matches = state.tasks.where((x) => x.id == id);
    if (matches.isEmpty) return;
    final t = matches.first;
    if (t.status == TaskStatus.done) return;
    t.pinned = !t.pinned;
    notifyListeners();
  }

  void deleteTask(int id) {
    state.tasks.removeWhere((t) => t.id == id);
    eco.rebuild(state);
    notifyListeners();
  }

  void completeTask(int id, FeedbackKind? feedback) {
    _consume(core.completeTask(id, feedback: feedback, now: DateTime.now()));
    eco.rebuild(state);
    notifyListeners();
  }

  // ——— 图鉴培育 ———
  List<GameEvent> cultivate(Emotion emotion, {bool usePrism = false}) {
    final ev = core.cultivate(emotion, usePrism: usePrism, now: DateTime.now());
    eco.rebuild(state);
    notifyListeners();
    return ev;
  }

  void setCompanion(Emotion? e) {
    state.companion = e;
    notifyListeners();
  }

  // ——— 专注 ———
  void startFocus(Emotion pet, int planMin) {
    _consume(core.startFocus(pet, planMin, DateTime.now()));
    notifyListeners();
  }

  void focusBackgrounded() {
    core.focusOnBackgrounded(DateTime.now());
    notifyListeners();
  }

  void focusResumed() {
    _consume(core.focusOnResumed(DateTime.now()));
    notifyListeners();
  }

  void cancelFocus() {
    core.cancelFocus(DateTime.now());
    notifyListeners();
  }

  // ——— 回廊 ———
  MazeRun? get mazeRun => core.activeMazeRun;

  int dailyMazeLeft([DateTime? now]) => core.dailyMazeLeft(now);

  List<GameEvent> startMaze(int zoneIndex) {
    final ev = core.startMaze(zoneIndex, now: DateTime.now());
    notifyListeners();
    return ev;
  }

  List<MazeRunEvent> mazeClick(int cx, int cy) {
    final run = core.activeMazeRun;
    if (run == null || !run.active) return const [];
    final ev = run.clickCell(cx, cy);
    notifyListeners();
    return ev;
  }

  List<MazeRunEvent> mazeStep(int dx, int dy) {
    final run = core.activeMazeRun;
    if (run == null || !run.active) return const [];
    final ev = run.step(dx, dy);
    notifyListeners();
    return ev;
  }

  void mazeUndo() {
    core.activeMazeRun?.undo();
    notifyListeners();
  }

  void mazeRestart() {
    core.activeMazeRun?.restartFloor();
    notifyListeners();
  }

  void abandonMaze() {
    core.abandonMaze();
    notifyListeners();
  }

  /// 通关结算入账。
  List<GameEvent> finishMaze() {
    final ev = core.finishMaze();
    notifyListeners();
    return ev;
  }

  // ——— 云游 ———
  void dispatchRoam(Emotion pet, String routeId) {
    _consume(core.dispatchRoam(pet, routeId));
    notifyListeners();
  }

  void claimRoam(int slotIndex) {
    _consume(core.claimRoam(slotIndex));
    eco.rebuild(state);
    notifyListeners();
  }

  List<RoamRoute> get roamRoutes => kRoamRoutes;

  // ——— 群岛 ———
  String myPostcardCode() => core.myPostcardCode();

  String importPostcard(String code) {
    final ev = core.importPostcard(code);
    _consume(ev);
    eco.rebuild(state);
    notifyListeners();
    return ev
        .map((e) => e is GameNotice ? e.text : '')
        .where((t) => t.isNotEmpty)
        .join('；');
  }

  WeeklyReport buildWeeklyReport() => core.buildWeeklyReport(DateTime.now());

  // ——— 装扮商店 ———
  List<GameEvent> buyDecor(String souvenirId) {
    final before = state.roam.souvenirs[souvenirId] ?? 0;
    final events = core.buyDecor(souvenirId);
    if ((state.roam.souvenirs[souvenirId] ?? 0) != before) notifyListeners();
    return events;
  }

  // ——— 每日/道具 ———
  void checkin() {
    _consume(core.checkin(DateTime.now()));
    notifyListeners();
  }

  void claimQuest(String id) {
    _consume(core.claimQuest(id));
    notifyListeners();
  }

  List<GameEvent> useItem(ItemId id) {
    final ev = core.useItem(id, DateTime.now());
    notifyListeners();
    return ev;
  }

  void greet() {
    core.greet(DateTime.now());
    notifyListeners();
  }

  // ——— 心屿点击 ———
  IslandActor? tapIsland(double wx, double wy) {
    final hit = eco.tap(wx, wy);
    if (hit != null) notifyListeners();
    return hit;
  }

  void finishOnboarding() {
    state.onboarded = true;
    notifyListeners();
  }

  // ——— 存档 ———
  String exportSaveJson() => const JsonEncoder.withIndent('  ').convert(
        saveToJson(state, activeMazeRun: core.activeMazeRun),
      );

  bool importSaveJson(String raw) {
    try {
      final decoded = decodeSaveDocument(raw);
      final restored = decoded.state;
      state.version = restored.version;
      // 原地恢复（控制器持有同一状态对象）
      state.nextTaskId = restored.nextTaskId;
      state.clearing = restored.clearing;
      state.energy = restored.energy;
      state.warmFrontTurns = restored.warmFrontTurns;
      state.tailwindTurns = restored.tailwindTurns;
      state.companion = restored.companion;
      state.stats.totalDone = restored.stats.totalDone;
      state.stats.totalFocusSessions = restored.stats.totalFocusSessions;
      state.stats.totalFocusMinutes = restored.stats.totalFocusMinutes;
      state.stats.mazeRuns = restored.stats.mazeRuns;
      state.stats.mistDewCollected = restored.stats.mistDewCollected;
      state.stats.deepDives = restored.stats.deepDives;
      state.streak.sunnyDays = restored.streak.sunnyDays;
      state.streak.lastSunny = restored.streak.lastSunny;
      state.keeper.level = restored.keeper.level;
      state.keeper.exp = restored.keeper.exp;
      state.resonance.last = restored.resonance.last;
      state.resonance.len = restored.resonance.len;
      state.resonance.best = restored.resonance.best;
      state.resonance.lastAt = restored.resonance.lastAt;
      state.climate.fog = restored.climate.fog;
      state.climate.tier = restored.climate.tier;
      state.climate.tierHoldDays = restored.climate.tierHoldDays;
      state.climate.zeroDoneStreak = restored.climate.zeroDoneStreak;
      state.climate.days
        ..clear()
        ..addAll(restored.climate.days);
      state.session = restored.session;
      state.focusMeta.todayMin = restored.focusMeta.todayMin;
      state.focusMeta.weekMin = restored.focusMeta.weekMin;
      state.focusMeta.weekStart = restored.focusMeta.weekStart;
      state.focusMeta.glancesToday = restored.focusMeta.glancesToday;
      state.tasks
        ..clear()
        ..addAll(restored.tasks);
      state.pets
        ..clear()
        ..addAll(restored.pets);
      state.items
        ..clear()
        ..addAll(restored.items);
      state.daily.date = restored.daily.date;
      state.daily.checkinDays = restored.daily.checkinDays;
      state.daily.checkinBest = restored.daily.checkinBest;
      state.daily.checkedToday = restored.daily.checkedToday;
      state.daily.lastCheckin = restored.daily.lastCheckin;
      state.daily.lastGreet = restored.daily.lastGreet;
      state.daily.mazeToday = restored.daily.mazeToday;
      state.daily.quests
        ..clear()
        ..addAll(restored.daily.quests);
      state.achievements
        ..clear()
        ..addAll(restored.achievements);
      state.roam.slots
        ..clear()
        ..addAll(restored.roam.slots);
      state.roam.souvenirs
        ..clear()
        ..addAll(restored.roam.souvenirs);
      state.roam.pendant = restored.roam.pendant;
      state.social.myName = restored.social.myName;
      state.social.visitingPet = restored.social.visitingPet;
      state.social.visitingExpire = restored.social.visitingExpire;
      state.social.postcards
        ..clear()
        ..addAll(restored.social.postcards);
      state.lastReportWeek = restored.lastReportWeek;
      state.onboarded = restored.onboarded;
      core.activeMazeRun = decoded.activeMazeRun;
      eco.rebuild(state);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> flushSave() async {
    final pending = _saveDebounce;
    if (pending == null || !pending.isActive) return;
    pending.cancel();
    _saveDebounce = null;
    await store.save(exportSaveJson());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    unawaited(flushSave());
    super.dispose();
  }

  @override
  void notifyListeners() {
    _scheduleSave();
    super.notifyListeners();
  }
}
