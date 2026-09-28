/// 游戏状态聚合（docs/03 §2 存档 v2 内存形态）。
///
/// 设计约定：状态为可变聚合，引擎方法形如 `(state, input) → events[]`；
/// 持久化经 data/save_codec 序列化为 moodisle_save_v2 JSON。
library;
import 'emotion.dart';
import 'pet.dart';
import 'task.dart';
import 'social.dart';
import '../config/game_config.dart';
import '../engine/climate.dart';
import '../time/local_date.dart';

class StreakState {
  int sunnyDays;
  LocalDate? lastSunny;
  StreakState({this.sunnyDays = 0, this.lastSunny});
}

class KeeperState {
  int level;
  int exp;
  KeeperState({this.level = 1, this.exp = 0});
}

class ResonanceState {
  Emotion? last;
  int len;
  int best;
  DateTime? lastAt;
  ResonanceState({this.last, this.len = 0, this.best = 0, this.lastAt});
}

/// 单日气候桶：当日完成数与专注分钟（7 日滚动窗口）。
class ClimateBucket {
  final LocalDate date;
  int done;
  int focusMin;
  ClimateBucket(this.date, {this.done = 0, this.focusMin = 0});
}

class ClimateRuntime {
  double fog;
  ClimateTier tier;
  int tierHoldDays;
  int zeroDoneStreak; // 连续零完成天数（暮雪判定）
  final List<ClimateBucket> days; // 按日期升序，保留 7 天
  ClimateRuntime({
    this.fog = 0,
    this.tier = ClimateTier.sunny,
    this.tierHoldDays = 0,
    this.zeroDoneStreak = 0,
    List<ClimateBucket>? days,
  }) : days = days ?? [];
}

class FocusSessionState {
  final Emotion pet;
  final int planMin;
  final double tierMul; // 档位星屑系数（开始时按档位确定）
  String phase; // focusing / glancing
  int accumSeconds;
  final DateTime startedAt;
  DateTime lastTickAt;
  DateTime? pausedAt;

  FocusSessionState({
    required this.pet,
    required this.planMin,
    required this.tierMul,
    required this.startedAt,
    this.phase = 'focusing',
    this.accumSeconds = 0,
    DateTime? lastTickAt,
    this.pausedAt,
  }) : lastTickAt = lastTickAt ?? startedAt;

  int get doneMin => accumSeconds ~/ 60;
}

class FocusMetaState {
  int todayMin;
  int weekMin;
  LocalDate? weekStart;
  int glancesToday;
  FocusMetaState(
      {this.todayMin = 0, this.weekMin = 0, this.weekStart, this.glancesToday = 0});
}

class DailyQuestSlot {
  int prog;
  bool claimed;
  DailyQuestSlot({this.prog = 0, this.claimed = false});
}

class DailyState {
  LocalDate? date;
  int checkinDays;
  int checkinBest;
  bool checkedToday;
  LocalDate? lastCheckin;
  final Map<String, DailyQuestSlot> quests;
  LocalDate? lastGreet;
  int mazeToday; // 今日回廊已用次数

  DailyState({
    this.date,
    this.checkinDays = 0,
    this.checkinBest = 0,
    this.checkedToday = false,
    this.lastCheckin,
    Map<String, DailyQuestSlot>? quests,
    this.lastGreet,
    this.mazeToday = 0,
  }) : quests = quests ?? {};
}

class GameStats {
  int totalDone;
  int totalFocusSessions;
  int totalFocusMinutes;
  int mazeRuns; // 累计回廊探索次数（区域解锁进度）
  int mistDewCollected; // 累计拾取雾露
  int deepDives; // 完成深潜次数
  GameStats({
    this.totalDone = 0,
    this.totalFocusSessions = 0,
    this.totalFocusMinutes = 0,
    this.mazeRuns = 0,
    this.mistDewCollected = 0,
    this.deepDives = 0,
  });
}

class GameState {
  int version;
  int nextTaskId;
  final List<Task> tasks;
  final Map<Emotion, PetRecord> pets;
  double clearing; // 放晴度 0-100
  final StreakState streak;
  final KeeperState keeper;
  int energy;
  final Map<ItemId, int> items;
  int warmFrontTurns; // 暖锋剩余回廊次数
  int tailwindTurns; // 顺风剩余回廊次数
  final ResonanceState resonance;
  final ClimateRuntime climate;
  FocusSessionState? session;
  Emotion? companion; // 当前出战/陪伴的精灵
  final FocusMetaState focusMeta;
  final DailyState daily;
  final GameStats stats;
  final List<String> achievements;
  final RoamState roam;
  final SocialState social;
  bool onboarded = false; // 是否完成首次引导
  LocalDate? lastReportWeek; // 周报生成标记（周一起始周）

  GameState._({
    required this.version,
    required this.nextTaskId,
    required this.tasks,
    required this.pets,
    required this.clearing,
    required this.streak,
    required this.keeper,
    required this.energy,
    required this.items,
    required this.warmFrontTurns,
    required this.tailwindTurns,
    required this.resonance,
    required this.climate,
    required this.session,
    required this.focusMeta,
    required this.daily,
    required this.stats,
    required this.achievements,
    required this.roam,
    required this.social,
  });

  /// 新档（v2 初始态）。
  factory GameState.fresh() => GameState._(
        version: 2,
        nextTaskId: 1,
        tasks: [],
        pets: {},
        clearing: 0,
        streak: StreakState(),
        keeper: KeeperState(),
        energy: 0,
        items: {},
        warmFrontTurns: 0,
        tailwindTurns: 0,
        resonance: ResonanceState(),
        climate: ClimateRuntime(),
        session: null,
        // companion 默认 null（首次进入回廊/专注页时选择）
        focusMeta: FocusMetaState(),
        daily: DailyState(),
        stats: GameStats(),
        achievements: [],
        roam: RoamState(),
        social: SocialState(),
      );
}
