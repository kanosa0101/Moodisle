import 'package:drift/drift.dart';

import '../domain/config/game_config.dart';
import '../domain/config/roam_config.dart';
import '../domain/engine/climate.dart';
import '../domain/engine/maze/maze_runtime.dart';
import '../domain/entities/emotion.dart';
import '../domain/entities/game_state.dart';
import '../domain/entities/pet.dart';
import '../domain/entities/social.dart' as social;
import '../domain/entities/task.dart';
import '../domain/time/local_date.dart';
import 'database.dart';
import 'save_codec.dart';

abstract interface class GameRepository {
  Future<DecodedSave?> load();

  Future<void> save(GameState state, {MazeRun? activeMazeRun});
}

/// 通过关系表映射完整游戏状态；业务规则仍由 GameCore 负责。
class SqliteGameRepository implements GameRepository {
  final MoodisleDatabase database;

  SqliteGameRepository({MoodisleDatabase? database})
      : database = database ?? MoodisleDatabase.defaults();

  @override
  Future<DecodedSave?> load() async {
    final profile =
        await database.select(database.playerProfiles).getSingleOrNull();
    if (profile == null) return null;

    final state = GameState.fresh()..version = profile.saveFormatVersion;
    state
      ..nextTaskId = profile.nextTaskId
      ..clearing = profile.clearing
      ..energy = profile.energy
      ..warmFrontTurns = profile.warmFrontTurns
      ..tailwindTurns = profile.tailwindTurns
      ..companion = profile.companion == null
          ? null
          : Emotion.values.byName(profile.companion!)
      ..onboarded = profile.onboarded
      ..lastReportWeek = profile.lastReportWeek == null
          ? null
          : _parseDate(profile.lastReportWeek!);

    final stats =
        await database.select(database.gameStatistics).getSingleOrNull();
    if (stats != null) {
      state.stats
        ..totalDone = stats.totalDone
        ..totalFocusSessions = stats.totalFocusSessions
        ..totalFocusMinutes = stats.totalFocusMinutes
        ..mazeRuns = stats.mazeRuns
        ..mistDewCollected = stats.mistDewCollected
        ..deepDives = stats.deepDives;
    }

    final streak =
        await database.select(database.streakStates).getSingleOrNull();
    if (streak != null) {
      state.streak
        ..sunnyDays = streak.sunnyDays
        ..lastSunny =
            streak.lastSunny == null ? null : _parseDate(streak.lastSunny!);
    }

    final keeper =
        await database.select(database.keeperStates).getSingleOrNull();
    if (keeper != null) {
      state.keeper
        ..level = keeper.level
        ..exp = keeper.exp;
    }

    final resonance =
        await database.select(database.resonanceStates).getSingleOrNull();
    if (resonance != null) {
      state.resonance
        ..last = resonance.lastEmotion == null
            ? null
            : Emotion.values.byName(resonance.lastEmotion!)
        ..len = resonance.length
        ..best = resonance.best
        ..lastAt = _dateTime(resonance.lastAtMs);
    }

    final climate =
        await database.select(database.climateStates).getSingleOrNull();
    if (climate != null) {
      state.climate
        ..fog = climate.fog
        ..tier = ClimateTier.values.byName(climate.tier)
        ..tierHoldDays = climate.tierHoldDays
        ..zeroDoneStreak = climate.zeroDoneStreak;
      final days = await (database.select(database.climateDays)
            ..orderBy([(day) => OrderingTerm.asc(day.date)]))
          .get();
      state.climate.days
        ..clear()
        ..addAll(days.map((day) => ClimateBucket(
              _parseDate(day.date),
              done: day.done,
              focusMin: day.focusMinutes,
            )));
    }

    final focus =
        await database.select(database.focusMetadata).getSingleOrNull();
    if (focus != null) {
      state.focusMeta
        ..todayMin = focus.todayMinutes
        ..weekMin = focus.weekMinutes
        ..weekStart =
            focus.weekStart == null ? null : _parseDate(focus.weekStart!)
        ..glancesToday = focus.glancesToday;
    }
    final activeFocus =
        await database.select(database.activeFocusSessions).getSingleOrNull();
    if (activeFocus != null) {
      state.session = FocusSessionState(
        pet: Emotion.values.byName(activeFocus.pet),
        planMin: activeFocus.planMinutes,
        tierMul: activeFocus.tierMultiplier,
        phase: activeFocus.phase,
        accumSeconds: activeFocus.accumulatedSeconds,
        startedAt: _requiredDateTime(activeFocus.startedAtMs),
        lastTickAt: _requiredDateTime(activeFocus.lastTickAtMs),
        pausedAt: _dateTime(activeFocus.pausedAtMs),
      );
    }

    final daily = await database.select(database.dailyStates).getSingleOrNull();
    if (daily != null) {
      state.daily
        ..date = daily.date == null ? null : _parseDate(daily.date!)
        ..checkinDays = daily.checkinDays
        ..checkinBest = daily.checkinBest
        ..checkedToday = daily.checkedToday
        ..lastCheckin =
            daily.lastCheckin == null ? null : _parseDate(daily.lastCheckin!)
        ..lastGreet =
            daily.lastGreet == null ? null : _parseDate(daily.lastGreet!)
        ..mazeToday = daily.mazeToday;
      final quests =
          await database.select(database.dailyQuestProgressRows).get();
      state.daily.quests
        ..clear()
        ..addEntries(quests.map((quest) => MapEntry(
              quest.questCode,
              DailyQuestSlot(prog: quest.progress, claimed: quest.claimed),
            )));
    }

    final tasks = await (database.select(database.taskRows)
          ..orderBy([(task) => OrderingTerm.asc(task.position)]))
        .get();
    state.tasks
      ..clear()
      ..addAll(tasks.map((task) => Task(
            id: task.id,
            text: task.taskText,
            emotion: Emotion.values.byName(task.emotion),
            difficulty: task.difficulty,
            status: TaskStatus.values.byName(task.status),
            createdOn: _parseDate(task.createdOn),
            pinned: task.pinned,
          )));

    final pets = await database.select(database.petRecords).get();
    state.pets
      ..clear()
      ..addEntries(pets.map((pet) {
        final emotion = Emotion.values.byName(pet.emotion);
        return MapEntry(
          emotion,
          PetRecord(
            emotion: emotion,
            count: pet.count,
            stage: stageForCount(pet.count),
            branch:
                pet.branch == null ? null : Branch.values.byName(pet.branch!),
            bond: Bond(minutes: pet.bondMinutes),
          ),
        );
      }));

    final inventory = await database.select(database.inventoryRows).get();
    state.items
      ..clear()
      ..addEntries(inventory.map((item) => MapEntry(
            ItemId.values.byName(item.itemCode),
            item.quantity,
          )));

    final achievements = await (database.select(database.achievementUnlocks)
          ..orderBy([(achievement) => OrderingTerm.asc(achievement.position)]))
        .get();
    state.achievements
      ..clear()
      ..addAll(achievements.map((achievement) => achievement.code));

    final roamSlots = await (database.select(database.roamSlots)
          ..orderBy([(slot) => OrderingTerm.asc(slot.slotIndex)]))
        .get();
    state.roam.slots
      ..clear()
      ..addAll(roamSlots.map((slot) => social.RoamSlot(
            pet: Emotion.values.byName(slot.pet),
            routeId: slot.routeId,
            startedAt: _requiredDateTime(slot.startedAtMs),
            durationMs: slot.durationMs,
          )));
    final souvenirs =
        await database.select(database.souvenirInventoryRows).get();
    state.roam.souvenirs
      ..clear()
      ..addEntries(
          souvenirs.map((item) => MapEntry(item.souvenirCode, item.quantity)));

    final socialProfile =
        await database.select(database.socialProfiles).getSingleOrNull();
    if (socialProfile != null) {
      state.social
        ..myName = socialProfile.myName
        ..visitingPet = socialProfile.visitingPet == null
            ? null
            : Emotion.values.byName(socialProfile.visitingPet!)
        ..visitingExpire = _dateTime(socialProfile.visitingExpireMs);
      state.roam.pendant = socialProfile.pendant;
      final postcards = await (database.select(database.postcards)
            ..orderBy([(postcard) => OrderingTerm.asc(postcard.id)]))
          .get();
      state.social.postcards
        ..clear()
        ..addAll(postcards.map((postcard) => social.Postcard(
              code: postcard.code,
              friendName: postcard.friendName,
              friendPet: Emotion.values.byName(postcard.friendPet),
              receivedAt: _requiredDateTime(postcard.receivedAtMs),
            )));
    }

    return DecodedSave(
      state: state,
      activeMazeRun: await _loadMazeRun(),
    );
  }

  @override
  Future<void> save(GameState state, {MazeRun? activeMazeRun}) async {
    final mazeJson = activeMazeRun?.toJson();
    await database.transaction(() async {
      await _ensureCatalogEntries(state, mazeJson);
      await _clearStateRows();
      await database
          .into(database.playerProfiles)
          .insert(PlayerProfilesCompanion(
            id: const Value(1),
            saveFormatVersion: Value(state.version),
            nextTaskId: Value(state.nextTaskId),
            clearing: Value(state.clearing),
            energy: Value(state.energy),
            warmFrontTurns: Value(state.warmFrontTurns),
            tailwindTurns: Value(state.tailwindTurns),
            companion: Value(state.companion?.name),
            onboarded: Value(state.onboarded),
            lastReportWeek: Value(_dateString(state.lastReportWeek)),
          ));
      await database
          .into(database.gameStatistics)
          .insert(GameStatisticsCompanion(
            id: const Value(1),
            totalDone: Value(state.stats.totalDone),
            totalFocusSessions: Value(state.stats.totalFocusSessions),
            totalFocusMinutes: Value(state.stats.totalFocusMinutes),
            mazeRuns: Value(state.stats.mazeRuns),
            mistDewCollected: Value(state.stats.mistDewCollected),
            deepDives: Value(state.stats.deepDives),
          ));
      await database.into(database.streakStates).insert(StreakStatesCompanion(
            id: const Value(1),
            sunnyDays: Value(state.streak.sunnyDays),
            lastSunny: Value(_dateString(state.streak.lastSunny)),
          ));
      await database.into(database.keeperStates).insert(KeeperStatesCompanion(
            id: const Value(1),
            level: Value(state.keeper.level),
            exp: Value(state.keeper.exp),
          ));
      await database
          .into(database.resonanceStates)
          .insert(ResonanceStatesCompanion(
            id: const Value(1),
            lastEmotion: Value(state.resonance.last?.name),
            length: Value(state.resonance.len),
            best: Value(state.resonance.best),
            lastAtMs: Value(state.resonance.lastAt?.millisecondsSinceEpoch),
          ));
      await database.into(database.climateStates).insert(ClimateStatesCompanion(
            id: const Value(1),
            fog: Value(state.climate.fog),
            tier: Value(state.climate.tier.name),
            tierHoldDays: Value(state.climate.tierHoldDays),
            zeroDoneStreak: Value(state.climate.zeroDoneStreak),
          ));
      if (state.climate.days.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.climateDays,
            state.climate.days
                .map((day) => ClimateDaysCompanion.insert(
                      date: day.date.toString(),
                      done: day.done,
                      focusMinutes: day.focusMin,
                    ))
                .toList(),
          );
        });
      }
      await database.into(database.focusMetadata).insert(FocusMetadataCompanion(
            id: const Value(1),
            todayMinutes: Value(state.focusMeta.todayMin),
            weekMinutes: Value(state.focusMeta.weekMin),
            weekStart: Value(_dateString(state.focusMeta.weekStart)),
            glancesToday: Value(state.focusMeta.glancesToday),
          ));
      final session = state.session;
      if (session != null) {
        await database.into(database.activeFocusSessions).insert(
              ActiveFocusSessionsCompanion(
                id: const Value(1),
                pet: Value(session.pet.name),
                planMinutes: Value(session.planMin),
                tierMultiplier: Value(session.tierMul),
                phase: Value(session.phase),
                accumulatedSeconds: Value(session.accumSeconds),
                startedAtMs: Value(session.startedAt.millisecondsSinceEpoch),
                lastTickAtMs: Value(session.lastTickAt.millisecondsSinceEpoch),
                pausedAtMs: Value(session.pausedAt?.millisecondsSinceEpoch),
              ),
            );
      }
      await database.into(database.dailyStates).insert(DailyStatesCompanion(
            id: const Value(1),
            date: Value(_dateString(state.daily.date)),
            checkinDays: Value(state.daily.checkinDays),
            checkinBest: Value(state.daily.checkinBest),
            checkedToday: Value(state.daily.checkedToday),
            lastCheckin: Value(_dateString(state.daily.lastCheckin)),
            lastGreet: Value(_dateString(state.daily.lastGreet)),
            mazeToday: Value(state.daily.mazeToday),
          ));
      if (state.daily.quests.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.dailyQuestProgressRows,
            state.daily.quests.entries
                .map((entry) => DailyQuestProgressRowsCompanion.insert(
                      questCode: entry.key,
                      progress: entry.value.prog,
                      claimed: entry.value.claimed,
                    ))
                .toList(),
          );
        });
      }
      if (state.tasks.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.taskRows,
            state.tasks.indexed
                .map((entry) => TaskRowsCompanion.insert(
                      id: Value(entry.$2.id),
                      position: entry.$1,
                      taskText: entry.$2.text,
                      emotion: entry.$2.emotion.name,
                      difficulty: entry.$2.difficulty,
                      status: entry.$2.status.name,
                      createdOn: entry.$2.createdOn.toString(),
                      pinned: entry.$2.pinned,
                    ))
                .toList(),
          );
        });
      }
      if (state.pets.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.petRecords,
            state.pets.values
                .map((pet) => PetRecordsCompanion.insert(
                      emotion: pet.emotion.name,
                      count: pet.count,
                      branch: Value(pet.branch?.name),
                      bondMinutes: pet.bond.minutes,
                    ))
                .toList(),
          );
        });
      }
      if (state.items.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.inventoryRows,
            state.items.entries
                .map((entry) => InventoryRowsCompanion.insert(
                      itemCode: entry.key.name,
                      quantity: entry.value,
                    ))
                .toList(),
          );
        });
      }
      if (state.achievements.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.achievementUnlocks,
            state.achievements.indexed
                .map((entry) => AchievementUnlocksCompanion.insert(
                      code: entry.$2,
                      position: entry.$1,
                    ))
                .toList(),
          );
        });
      }
      if (state.roam.slots.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.roamSlots,
            state.roam.slots.indexed
                .map((entry) => RoamSlotsCompanion.insert(
                      slotIndex: Value(entry.$1),
                      pet: entry.$2.pet.name,
                      routeId: entry.$2.routeId,
                      startedAtMs: entry.$2.startedAt.millisecondsSinceEpoch,
                      durationMs: entry.$2.durationMs,
                    ))
                .toList(),
          );
        });
      }
      if (state.roam.souvenirs.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.souvenirInventoryRows,
            state.roam.souvenirs.entries
                .map((entry) => SouvenirInventoryRowsCompanion.insert(
                      souvenirCode: entry.key,
                      quantity: entry.value,
                    ))
                .toList(),
          );
        });
      }
      await database
          .into(database.socialProfiles)
          .insert(SocialProfilesCompanion(
            id: const Value(1),
            myName: Value(state.social.myName),
            visitingPet: Value(state.social.visitingPet?.name),
            visitingExpireMs:
                Value(state.social.visitingExpire?.millisecondsSinceEpoch),
            pendant: Value(state.roam.pendant),
          ));
      if (state.social.postcards.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.postcards,
            state.social.postcards
                .map((postcard) => PostcardsCompanion.insert(
                      code: postcard.code,
                      friendName: postcard.friendName,
                      friendPet: postcard.friendPet.name,
                      receivedAtMs: postcard.receivedAt.millisecondsSinceEpoch,
                    ))
                .toList(),
          );
        });
      }

      if (mazeJson != null) await _writeMazeRun(mazeJson);
    });
  }

  Future<void> _ensureCatalogEntries(
    GameState state,
    Map<String, dynamic>? mazeJson,
  ) async {
    await database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        database.dailyQuestCatalog,
        state.daily.quests.keys
            .map((code) => DailyQuestCatalogCompanion.insert(code: code))
            .toList(),
      );
      final souvenirIds = <String>{
        ...state.roam.souvenirs.keys,
        if (state.roam.pendant != null) state.roam.pendant!,
      };
      batch.insertAllOnConflictUpdate(
        database.souvenirCatalog,
        souvenirIds.map((code) {
          final definition = kSouvenirs[code];
          return SouvenirCatalogCompanion.insert(
            code: code,
            pendant: definition?.pendant ?? (state.roam.pendant == code),
            rarity: definition?.rarity ?? 1,
          );
        }).toList(),
      );
      if (mazeJson != null) {
        final settlement = mazeJson['settlement'] as Map<String, dynamic>?;
        final loot = (settlement?['loot'] as Map?) ?? const {};
        batch.insertAllOnConflictUpdate(
          database.itemCatalog,
          loot.keys
              .map((code) => ItemCatalogCompanion.insert(code: code as String))
              .toList(),
        );
      }
    });
  }

  Future<void> _clearStateRows() async {
    await database.delete(database.mazeUndoCellStates).go();
    await database.delete(database.mazeUndoSnapshots).go();
    await database.delete(database.mazeSettlementLootRows).go();
    await database.delete(database.mazeSettlements).go();
    await database.delete(database.mazeCellStates).go();
    await database.delete(database.activeMazeRuns).go();
    await database.delete(database.activeFocusSessions).go();
    await database.delete(database.dailyQuestProgressRows).go();
    await database.delete(database.taskRows).go();
    await database.delete(database.petRecords).go();
    await database.delete(database.inventoryRows).go();
    await database.delete(database.climateDays).go();
    await database.delete(database.achievementUnlocks).go();
    await database.delete(database.roamSlots).go();
    await database.delete(database.souvenirInventoryRows).go();
    await database.delete(database.postcards).go();
    await database.delete(database.playerProfiles).go();
    await database.delete(database.gameStatistics).go();
    await database.delete(database.streakStates).go();
    await database.delete(database.keeperStates).go();
    await database.delete(database.resonanceStates).go();
    await database.delete(database.climateStates).go();
    await database.delete(database.focusMetadata).go();
    await database.delete(database.dailyStates).go();
    await database.delete(database.socialProfiles).go();
  }

  Future<void> _writeMazeRun(Map<String, dynamic> run) async {
    await database.into(database.activeMazeRuns).insert(ActiveMazeRunsCompanion(
          id: const Value(1),
          zoneIndex: Value((run['zoneIndex'] as num).toInt()),
          seed: Value((run['seed'] as num).toInt()),
          startLevel: Value((run['startLevel'] as num).toInt()),
          floorIndex: Value((run['fi'] as num).toInt()),
          positionX: Value(_coordinate(run['pos'], 'x')),
          positionY: Value(_coordinate(run['pos'], 'y')),
          level: Value((run['level'] as num).toInt()),
          keys: Value((run['keys'] as num).toInt()),
          lanterns: Value((run['lanterns'] as num?)?.toInt() ?? 0),
          steps: Value((run['steps'] as num?)?.toInt() ?? 0),
          kills: Value((run['kills'] as num?)?.toInt() ?? 0),
          eliteKills: Value((run['eliteKills'] as num?)?.toInt() ?? 0),
          bossBeaten: Value(run['bossBeaten'] as bool? ?? false),
          usedUndo: Value(run['usedUndo'] as bool? ?? false),
          active: Value(run['active'] as bool? ?? true),
        ));

    final cells = <String, _CellFlags>{};
    _applyFlags(cells, run['consumed'], (flags) => flags.consumed = true);
    _applyFlags(cells, run['picked'], (flags) => flags.picked = true);
    _applyFlags(cells, run['opened'], (flags) => flags.opened = true);
    if (cells.isNotEmpty) {
      await database.batch((batch) {
        batch.insertAll(
          database.mazeCellStates,
          cells.entries
              .map((entry) => MazeCellStatesCompanion.insert(
                    floorIndex: entry.value.floorIndex,
                    cellKey: entry.value.cellKey,
                    consumed: entry.value.consumed,
                    picked: entry.value.picked,
                    opened: entry.value.opened,
                  ))
              .toList(),
        );
      });
    }

    final rawHistory = (run['history'] as List?) ?? const [];
    final snapshotRows = <MazeUndoSnapshotsCompanion>[];
    final snapshotCells = <MazeUndoCellStatesCompanion>[];
    for (var index = 0; index < rawHistory.length; index++) {
      final snapshot = rawHistory[index] as Map<String, dynamic>;
      snapshotRows.add(MazeUndoSnapshotsCompanion.insert(
        snapshotIndex: Value(index),
        positionX: _coordinate(snapshot['pos'], 'x'),
        positionY: _coordinate(snapshot['pos'], 'y'),
        level: (snapshot['level'] as num).toInt(),
        keys: (snapshot['keys'] as num).toInt(),
        steps: (snapshot['steps'] as num).toInt(),
        kills: (snapshot['kills'] as num).toInt(),
        eliteKills: (snapshot['eliteKills'] as num).toInt(),
        bossBeaten: snapshot['bossBeaten'] as bool? ?? false,
      ));
      final flags = <String, _CellFlags>{};
      _applyFlags(flags, snapshot['consumed'], (item) => item.consumed = true);
      _applyFlags(flags, snapshot['picked'], (item) => item.picked = true);
      _applyFlags(flags, snapshot['opened'], (item) => item.opened = true);
      snapshotCells
          .addAll(flags.values.map((flag) => MazeUndoCellStatesCompanion.insert(
                snapshotIndex: index,
                floorIndex: flag.floorIndex,
                cellKey: flag.cellKey,
                consumed: flag.consumed,
                picked: flag.picked,
                opened: flag.opened,
              )));
    }
    if (snapshotRows.isNotEmpty || snapshotCells.isNotEmpty) {
      await database.batch((batch) {
        if (snapshotRows.isNotEmpty) {
          batch.insertAll(database.mazeUndoSnapshots, snapshotRows);
        }
        if (snapshotCells.isNotEmpty) {
          batch.insertAll(database.mazeUndoCellStates, snapshotCells);
        }
      });
    }

    final settlement = run['settlement'] as Map<String, dynamic>?;
    if (settlement != null) {
      await database.into(database.mazeSettlements).insert(
            MazeSettlementsCompanion.insert(
              id: const Value(1),
              exp: (settlement['exp'] as num).toInt(),
              clearingGain: (settlement['clearingGain'] as num).toInt(),
              perfect: settlement['perfect'] as bool,
            ),
          );
      final loot = (settlement['loot'] as Map?) ?? const {};
      if (loot.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(
            database.mazeSettlementLootRows,
            loot.entries
                .map((entry) => MazeSettlementLootRowsCompanion.insert(
                      itemCode: entry.key as String,
                      quantity: (entry.value as num).toInt(),
                    ))
                .toList(),
          );
        });
      }
    }
  }

  Future<MazeRun?> _loadMazeRun() async {
    final row =
        await database.select(database.activeMazeRuns).getSingleOrNull();
    if (row == null) return null;
    final cells = await database.select(database.mazeCellStates).get();
    final history = await (database.select(database.mazeUndoSnapshots)
          ..orderBy([(snapshot) => OrderingTerm.asc(snapshot.snapshotIndex)]))
        .get();
    final historyCells =
        await database.select(database.mazeUndoCellStates).get();
    final settlement =
        await database.select(database.mazeSettlements).getSingleOrNull();
    final loot = await database.select(database.mazeSettlementLootRows).get();
    final position = {'x': row.positionX, 'y': row.positionY};
    final json = <String, dynamic>{
      'zoneIndex': row.zoneIndex,
      'seed': row.seed,
      'startLevel': row.startLevel,
      'fi': row.floorIndex,
      'pos': position,
      'level': row.level,
      'keys': row.keys,
      'lanterns': row.lanterns,
      'consumed': _flagsFor(
        cells,
        (cell) => cell.floorIndex,
        (cell) => cell.cellKey,
        (cell) => cell.consumed,
      ),
      'picked': _flagsFor(
        cells,
        (cell) => cell.floorIndex,
        (cell) => cell.cellKey,
        (cell) => cell.picked,
      ),
      'opened': _flagsFor(
        cells,
        (cell) => cell.floorIndex,
        (cell) => cell.cellKey,
        (cell) => cell.opened,
      ),
      'history': [
        for (final snapshot in history)
          {
            'pos': {'x': snapshot.positionX, 'y': snapshot.positionY},
            'level': snapshot.level,
            'keys': snapshot.keys,
            'steps': snapshot.steps,
            'kills': snapshot.kills,
            'eliteKills': snapshot.eliteKills,
            'bossBeaten': snapshot.bossBeaten,
            'consumed': _flagsFor(
              historyCells.where(
                  (cell) => cell.snapshotIndex == snapshot.snapshotIndex),
              (cell) => cell.floorIndex,
              (cell) => cell.cellKey,
              (cell) => cell.consumed,
            ),
            'picked': _flagsFor(
              historyCells.where(
                  (cell) => cell.snapshotIndex == snapshot.snapshotIndex),
              (cell) => cell.floorIndex,
              (cell) => cell.cellKey,
              (cell) => cell.picked,
            ),
            'opened': _flagsFor(
              historyCells.where(
                  (cell) => cell.snapshotIndex == snapshot.snapshotIndex),
              (cell) => cell.floorIndex,
              (cell) => cell.cellKey,
              (cell) => cell.opened,
            ),
          },
      ],
      'steps': row.steps,
      'kills': row.kills,
      'eliteKills': row.eliteKills,
      'bossBeaten': row.bossBeaten,
      'usedUndo': row.usedUndo,
      'active': row.active,
      'settlement': settlement == null
          ? null
          : {
              'loot': {for (final item in loot) item.itemCode: item.quantity},
              'exp': settlement.exp,
              'clearingGain': settlement.clearingGain,
              'perfect': settlement.perfect,
            },
    };
    return MazeRun.fromJson(json);
  }

  List<String> _flagsFor<T>(
    Iterable<T> rows,
    int Function(T) floorIndex,
    String Function(T) cellKey,
    bool Function(T) selected,
  ) {
    final result = <String>[];
    for (final row in rows) {
      if (!selected(row)) continue;
      result.add('${floorIndex(row)}:${cellKey(row)}');
    }
    result.sort();
    return result;
  }

  List<_MazeFlagKey> _readFlags(Object? raw) =>
      ((raw as List?) ?? const []).map((entry) {
        final key = entry as String;
        final separator = key.indexOf(':');
        if (separator <= 0) {
          throw const FormatException('Invalid maze cell key');
        }
        return _MazeFlagKey(
          int.parse(key.substring(0, separator)),
          key.substring(separator + 1),
        );
      }).toList();

  void _applyFlags(
    Map<String, _CellFlags> target,
    Object? raw,
    void Function(_CellFlags) mark,
  ) {
    for (final key in _readFlags(raw)) {
      final mapKey = '${key.floorIndex}:${key.cellKey}';
      mark(target.putIfAbsent(
        mapKey,
        () => _CellFlags(key.floorIndex, key.cellKey),
      ));
    }
  }

  int _coordinate(Object? raw, String axis) =>
      ((raw as Map<String, dynamic>)[axis] as num).toInt();

  LocalDate _parseDate(String value) {
    final parts = value.split('-');
    return LocalDate(
        int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  String? _dateString(LocalDate? value) => value?.toString();

  DateTime? _dateTime(int? milliseconds) => milliseconds == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(milliseconds);

  DateTime _requiredDateTime(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);
}

class _MazeFlagKey {
  final int floorIndex;
  final String cellKey;

  const _MazeFlagKey(this.floorIndex, this.cellKey);
}

class _CellFlags {
  final int floorIndex;
  final String cellKey;
  bool consumed = false;
  bool picked = false;
  bool opened = false;

  _CellFlags(this.floorIndex, this.cellKey);
}
