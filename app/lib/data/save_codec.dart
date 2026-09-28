/// 存档 v2 编解码（moodisle_save_v2）。
///
/// · JSON 字段显式命名，roundtrip 等价由测试保证（docs/03 §12）；
/// · LocalDate 存 `yyyy-MM-dd`（本地日历），时刻存毫秒时间戳；
/// · 读取失败由上层 repository 降级处理（docs/03 §9 存档损坏策略）。
library;

import 'dart:convert';

import '../domain/config/game_config.dart';
import '../domain/engine/climate.dart';
import '../domain/engine/maze/maze_runtime.dart';
import '../domain/entities/emotion.dart';
import '../domain/entities/game_state.dart';
import '../domain/entities/pet.dart';
import '../domain/entities/social.dart';
import '../domain/entities/task.dart';
import '../domain/time/local_date.dart';

String _d(LocalDate d) => d.toString();

LocalDate _pd(String v) {
  final p = v.split('-');
  return LocalDate(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
}

Map<String, dynamic> saveToJson(GameState s, {MazeRun? activeMazeRun}) {
  return {
    'version': s.version,
    'nextTaskId': s.nextTaskId,
    'clearing': s.clearing,
    'energy': s.energy,
    'warmFrontTurns': s.warmFrontTurns,
    'tailwindTurns': s.tailwindTurns,
    'stats': {
      'totalDone': s.stats.totalDone,
      'totalFocusSessions': s.stats.totalFocusSessions,
      'totalFocusMinutes': s.stats.totalFocusMinutes,
      'mazeRuns': s.stats.mazeRuns,
      'mistDewCollected': s.stats.mistDewCollected,
      'deepDives': s.stats.deepDives,
    },
    'achievements': s.achievements,
    'roam': {
      'slots': [
        for (final slot in s.roam.slots)
          {
            'pet': slot.pet.name,
            'routeId': slot.routeId,
            'startMs': slot.startedAt.millisecondsSinceEpoch,
            'durationMs': slot.durationMs,
          },
      ],
      'souvenirs': {
        for (final e in s.roam.souvenirs.entries) e.key: e.value,
      },
      'pendant': s.roam.pendant,
    },
    'social': {
      'myName': s.social.myName,
      'visitingPet': s.social.visitingPet?.name,
      'visitingExpireMs': s.social.visitingExpire?.millisecondsSinceEpoch,
      'postcards': [
        for (final pc in s.social.postcards)
          {
            'code': pc.code,
            'friendName': pc.friendName,
            'friendPet': pc.friendPet.name,
            'receivedAtMs': pc.receivedAt.millisecondsSinceEpoch,
          },
      ],
    },
    'lastReportWeek': s.lastReportWeek == null ? null : _d(s.lastReportWeek!),
    'onboarded': s.onboarded,
    'streak': {
      'sunnyDays': s.streak.sunnyDays,
      'lastSunny': s.streak.lastSunny == null ? null : _d(s.streak.lastSunny!),
    },
    'keeper': {'level': s.keeper.level, 'exp': s.keeper.exp},
    'resonance': {
      'last': s.resonance.last?.name,
      'len': s.resonance.len,
      'best': s.resonance.best,
      'lastAtMs': s.resonance.lastAt?.millisecondsSinceEpoch,
    },
    'climate': {
      'fog': s.climate.fog,
      'tier': s.climate.tier.name,
      'tierHoldDays': s.climate.tierHoldDays,
      'zeroDoneStreak': s.climate.zeroDoneStreak,
      'buckets': [
        for (final b in s.climate.days)
          {'date': _d(b.date), 'done': b.done, 'focusMin': b.focusMin},
      ],
    },
    'focus': {
      'todayMin': s.focusMeta.todayMin,
      'weekMin': s.focusMeta.weekMin,
      'weekStart':
          s.focusMeta.weekStart == null ? null : _d(s.focusMeta.weekStart!),
      'glancesToday': s.focusMeta.glancesToday,
    },
    'session': s.session == null
        ? null
        : {
            'pet': s.session!.pet.name,
            'planMin': s.session!.planMin,
            'tierMul': s.session!.tierMul,
            'phase': s.session!.phase,
            'accumSeconds': s.session!.accumSeconds,
            'startedAtMs': s.session!.startedAt.millisecondsSinceEpoch,
            'lastTickAtMs': s.session!.lastTickAt.millisecondsSinceEpoch,
            'pausedAtMs': s.session!.pausedAt?.millisecondsSinceEpoch,
          },
    'daily': {
      'date': s.daily.date == null ? null : _d(s.daily.date!),
      'checkinDays': s.daily.checkinDays,
      'checkinBest': s.daily.checkinBest,
      'checkedToday': s.daily.checkedToday,
      'lastCheckin':
          s.daily.lastCheckin == null ? null : _d(s.daily.lastCheckin!),
      'lastGreet': s.daily.lastGreet == null ? null : _d(s.daily.lastGreet!),
      'mazeToday': s.daily.mazeToday,
      'companion': s.companion?.name,
      'quests': {
        for (final e in s.daily.quests.entries)
          e.key: {'prog': e.value.prog, 'claimed': e.value.claimed},
      },
    },
    'tasks': [
      for (final t in s.tasks)
        {
          'id': t.id,
          'text': t.text,
          'emotion': t.emotion.name,
          'difficulty': t.difficulty,
          'status': t.status.name,
          'createdOn': _d(t.createdOn),
          'pinned': t.pinned,
        },
    ],
    'pets': {
      for (final e in s.pets.entries)
        e.key.name: {
          'count': e.value.count,
          'stage': e.value.stage.name,
          'branch': e.value.branch?.name,
          'bondMinutes': e.value.bond.minutes,
        },
    },
    'items': {
      for (final e in s.items.entries) e.key.name: e.value,
    },
    'activeMazeRun': activeMazeRun?.toJson(),
  };
}

GameState saveFromJson(Map<String, dynamic> j) {
  final s = GameState.fresh();
  s.version = (j['version'] as num?)?.toInt() ?? 2;
  s.nextTaskId = (j['nextTaskId'] as num?)?.toInt() ?? 1;
  s.clearing = (j['clearing'] as num?)?.toDouble() ?? 0;
  s.energy = (j['energy'] as num?)?.toInt() ?? 0;
  s.warmFrontTurns = (j['warmFrontTurns'] as num?)?.toInt() ?? 0;
  s.tailwindTurns = (j['tailwindTurns'] as num?)?.toInt() ?? 0;

  final stats = j['stats'] as Map<String, dynamic>?;
  if (stats != null) {
    s.stats.totalDone = (stats['totalDone'] as num?)?.toInt() ?? 0;
    s.stats.totalFocusSessions =
        (stats['totalFocusSessions'] as num?)?.toInt() ?? 0;
    s.stats.totalFocusMinutes =
        (stats['totalFocusMinutes'] as num?)?.toInt() ?? 0;
    s.stats.mazeRuns = (stats['mazeRuns'] as num?)?.toInt() ?? 0;
    s.stats.mistDewCollected =
        (stats['mistDewCollected'] as num?)?.toInt() ?? 0;
    s.stats.deepDives = (stats['deepDives'] as num?)?.toInt() ?? 0;
  }

  final streak = j['streak'] as Map<String, dynamic>?;
  if (streak != null) {
    s.streak.sunnyDays = (streak['sunnyDays'] as num?)?.toInt() ?? 0;
    s.streak.lastSunny =
        streak['lastSunny'] == null ? null : _pd(streak['lastSunny'] as String);
  }

  final keeper = j['keeper'] as Map<String, dynamic>?;
  if (keeper != null) {
    s.keeper.level = (keeper['level'] as num?)?.toInt() ?? 1;
    s.keeper.exp = (keeper['exp'] as num?)?.toInt() ?? 0;
  }

  final res = j['resonance'] as Map<String, dynamic>?;
  if (res != null) {
    s.resonance.last = res['last'] == null
        ? null
        : Emotion.values.byName(res['last'] as String);
    s.resonance.len = (res['len'] as num?)?.toInt() ?? 0;
    s.resonance.best = (res['best'] as num?)?.toInt() ?? 0;
    s.resonance.lastAt = res['lastAtMs'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch((res['lastAtMs'] as num).toInt());
  }

  final climate = j['climate'] as Map<String, dynamic>?;
  if (climate != null) {
    s.climate.fog = (climate['fog'] as num?)?.toDouble() ?? 0;
    s.climate.tier = climate['tier'] == null
        ? ClimateTier.sunny
        : ClimateTier.values.byName(climate['tier'] as String);
    s.climate.tierHoldDays = (climate['tierHoldDays'] as num?)?.toInt() ?? 0;
    s.climate.zeroDoneStreak =
        (climate['zeroDoneStreak'] as num?)?.toInt() ?? 0;
    s.climate.days.clear();
    for (final b in (climate['buckets'] as List? ?? [])) {
      final m = b as Map<String, dynamic>;
      s.climate.days.add(ClimateBucket(
        _pd(m['date'] as String),
        done: (m['done'] as num?)?.toInt() ?? 0,
        focusMin: (m['focusMin'] as num?)?.toInt() ?? 0,
      ));
    }
  }

  final focus = j['focus'] as Map<String, dynamic>?;
  if (focus != null) {
    s.focusMeta.todayMin = (focus['todayMin'] as num?)?.toInt() ?? 0;
    s.focusMeta.weekMin = (focus['weekMin'] as num?)?.toInt() ?? 0;
    s.focusMeta.weekStart =
        focus['weekStart'] == null ? null : _pd(focus['weekStart'] as String);
    s.focusMeta.glancesToday = (focus['glancesToday'] as num?)?.toInt() ?? 0;
  }

  final session = j['session'] as Map<String, dynamic>?;
  if (session != null) {
    s.session = FocusSessionState(
      pet: Emotion.values.byName(session['pet'] as String),
      planMin: (session['planMin'] as num).toInt(),
      tierMul: (session['tierMul'] as num?)?.toDouble() ?? 1.0,
      startedAt: DateTime.fromMillisecondsSinceEpoch(
          (session['startedAtMs'] as num).toInt()),
      phase: session['phase'] as String? ?? 'focusing',
      accumSeconds: (session['accumSeconds'] as num?)?.toInt() ?? 0,
      lastTickAt: DateTime.fromMillisecondsSinceEpoch(
          (session['lastTickAtMs'] as num).toInt()),
      pausedAt: session['pausedAtMs'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              (session['pausedAtMs'] as num).toInt()),
    );
  }

  final daily = j['daily'] as Map<String, dynamic>?;
  if (daily != null) {
    s.daily.date = daily['date'] == null ? null : _pd(daily['date'] as String);
    s.daily.checkinDays = (daily['checkinDays'] as num?)?.toInt() ?? 0;
    s.daily.checkinBest = (daily['checkinBest'] as num?)?.toInt() ?? 0;
    s.daily.checkedToday = daily['checkedToday'] as bool? ?? false;
    s.daily.lastCheckin = daily['lastCheckin'] == null
        ? null
        : _pd(daily['lastCheckin'] as String);
    s.daily.lastGreet =
        daily['lastGreet'] == null ? null : _pd(daily['lastGreet'] as String);
    s.daily.mazeToday = (daily['mazeToday'] as num?)?.toInt() ?? 0;
    s.companion = daily['companion'] == null
        ? null
        : Emotion.values.byName(daily['companion'] as String);
    s.daily.quests.clear();
    for (final q in kDailyQuests) {
      s.daily.quests[q.id] = DailyQuestSlot();
    }
    for (final e in ((daily['quests'] as Map?) ?? {}).entries) {
      final m = e.value as Map<String, dynamic>;
      s.daily.quests[e.key as String] = DailyQuestSlot(
        prog: (m['prog'] as num?)?.toInt() ?? 0,
        claimed: m['claimed'] as bool? ?? false,
      );
    }
  }

  for (final t in (j['tasks'] as List? ?? [])) {
    final m = t as Map<String, dynamic>;
    s.tasks.add(Task(
      id: (m['id'] as num).toInt(),
      text: m['text'] as String,
      emotion: Emotion.values.byName(m['emotion'] as String),
      difficulty: (m['difficulty'] as num?)?.toInt() ?? 2,
      createdOn: _pd(m['createdOn'] as String),
      status: m['status'] == null
          ? TaskStatus.pending
          : TaskStatus.values.byName(m['status'] as String),
      pinned: m['pinned'] as bool? ?? false,
    ));
  }

  for (final e in ((j['pets'] as Map?) ?? {}).entries) {
    final m = e.value as Map<String, dynamic>;
    s.pets[Emotion.values.byName(e.key as String)] = PetRecord(
      emotion: Emotion.values.byName(e.key as String),
      count: (m['count'] as num?)?.toInt() ?? 0,
      stage: m['stage'] == null
          ? PetStage.clear
          : PetStage.values.byName(m['stage'] as String),
      branch: m['branch'] == null
          ? null
          : Branch.values.byName(m['branch'] as String),
      bond: Bond(minutes: (m['bondMinutes'] as num?)?.toInt() ?? 0),
    );
  }

  for (final e in ((j['items'] as Map?) ?? {}).entries) {
    s.items[ItemId.values.byName(e.key as String)] =
        (e.value as num?)?.toInt() ?? 0;
  }

  for (final a in (j['achievements'] as List? ?? [])) {
    s.achievements.add(a as String);
  }
  final roam = j['roam'] as Map<String, dynamic>?;
  if (roam != null) {
    for (final slot in (roam['slots'] as List? ?? [])) {
      final m = slot as Map<String, dynamic>;
      s.roam.slots.add(RoamSlot(
        pet: Emotion.values.byName(m['pet'] as String),
        routeId: m['routeId'] as String,
        startedAt:
            DateTime.fromMillisecondsSinceEpoch((m['startMs'] as num).toInt()),
        durationMs: (m['durationMs'] as num?)?.toInt() ?? 0,
      ));
    }
    for (final e in ((roam['souvenirs'] as Map?) ?? {}).entries) {
      s.roam.souvenirs[e.key as String] = (e.value as num?)?.toInt() ?? 0;
    }
    s.roam.pendant = roam['pendant'] as String?;
  }
  final socialJ = j['social'] as Map<String, dynamic>?;
  if (socialJ != null) {
    s.social.myName = socialJ['myName'] as String? ?? '无名小屿';
    s.social.visitingPet = socialJ['visitingPet'] == null
        ? null
        : Emotion.values.byName(socialJ['visitingPet'] as String);
    s.social.visitingExpire = socialJ['visitingExpireMs'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            (socialJ['visitingExpireMs'] as num).toInt());
    for (final pc in (socialJ['postcards'] as List? ?? [])) {
      final m = pc as Map<String, dynamic>;
      s.social.postcards.add(Postcard(
        code: m['code'] as String,
        friendName: m['friendName'] as String,
        friendPet: Emotion.values.byName(m['friendPet'] as String),
        receivedAt: DateTime.fromMillisecondsSinceEpoch(
            (m['receivedAtMs'] as num).toInt()),
      ));
    }
  }
  s.lastReportWeek =
      j['lastReportWeek'] == null ? null : _pd(j['lastReportWeek'] as String);
  s.onboarded = j['onboarded'] as bool? ?? false;
  return s;
}

String encodeSave(GameState s, {MazeRun? activeMazeRun}) =>
    jsonEncode(saveToJson(s, activeMazeRun: activeMazeRun));

class DecodedSave {
  final GameState state;
  final MazeRun? activeMazeRun;

  const DecodedSave({required this.state, required this.activeMazeRun});
}

DecodedSave decodeSaveDocument(String raw) {
  final json = jsonDecode(raw) as Map<String, dynamic>;
  final activeMaze = json['activeMazeRun'] as Map<String, dynamic>?;
  return DecodedSave(
    state: saveFromJson(json),
    activeMazeRun: activeMaze == null ? null : MazeRun.fromJson(activeMaze),
  );
}

GameState decodeSave(String raw) => decodeSaveDocument(raw).state;
