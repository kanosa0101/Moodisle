import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../domain/config/game_config.dart';
import '../domain/config/roam_config.dart';
import '../domain/entities/emotion.dart';

part 'database.g.dart';

class EmotionCatalog extends Table {
  late final code = text()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

class ItemCatalog extends Table {
  late final code = text()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

class DailyQuestCatalog extends Table {
  late final code = text()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

class SouvenirCatalog extends Table {
  late final code = text()();
  late final pendant = boolean()();
  late final rarity = integer()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

class PlayerProfiles extends Table {
  late final id = integer()();
  late final saveFormatVersion = integer()();
  late final nextTaskId = integer()();
  late final clearing = real()();
  late final energy = integer()();
  late final warmFrontTurns = integer()();
  late final tailwindTurns = integer()();
  late final companion = text().nullable().references(EmotionCatalog, #code)();
  late final onboarded = boolean()();
  late final lastReportWeek = text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'idx_tasks_status_created_on', columns: {#status, #createdOn})
class TaskRows extends Table {
  @override
  String get tableName => 'tasks';

  late final id = integer()();
  late final position =
      integer().customConstraint('NOT NULL CHECK (position >= 0)')();
  late final taskText = text()();
  late final emotion = text().references(EmotionCatalog, #code)();
  late final difficulty = integer()
      .customConstraint('NOT NULL CHECK (difficulty BETWEEN 1 AND 3)')();
  late final status = text()
      .customConstraint("NOT NULL CHECK (status IN ('pending', 'done'))")();
  late final createdOn = text()();
  late final pinned = boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DbPetRecord')
class PetRecords extends Table {
  late final emotion = text().references(EmotionCatalog, #code)();
  late final count =
      integer().customConstraint('NOT NULL CHECK (count >= 0)')();
  late final branch = text().nullable()();
  late final bondMinutes =
      integer().customConstraint('NOT NULL CHECK (bond_minutes >= 0)')();

  @override
  Set<Column<Object>> get primaryKey => {emotion};
}

class InventoryRows extends Table {
  @override
  String get tableName => 'inventory';

  late final itemCode = text().references(ItemCatalog, #code)();
  late final quantity =
      integer().customConstraint('NOT NULL CHECK (quantity >= 0)')();

  @override
  Set<Column<Object>> get primaryKey => {itemCode};
}

class GameStatistics extends Table {
  late final id = integer()();
  late final totalDone = integer()();
  late final totalFocusSessions = integer()();
  late final totalFocusMinutes = integer()();
  late final mazeRuns = integer()();
  late final mistDewCollected = integer()();
  late final deepDives = integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StreakStates extends Table {
  late final id = integer()();
  late final sunnyDays = integer()();
  late final lastSunny = text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class KeeperStates extends Table {
  late final id = integer()();
  late final level = integer()();
  late final exp = integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ResonanceStates extends Table {
  late final id = integer()();
  late final lastEmotion =
      text().nullable().references(EmotionCatalog, #code)();
  late final length = integer()();
  late final best = integer()();
  late final lastAtMs = integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ClimateStates extends Table {
  late final id = integer()();
  late final fog = real()();
  late final tier = text()();
  late final tierHoldDays = integer()();
  late final zeroDoneStreak = integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ClimateDays extends Table {
  late final date = text()();
  late final done = integer()();
  late final focusMinutes = integer()();

  @override
  Set<Column<Object>> get primaryKey => {date};
}

class FocusMetadata extends Table {
  late final id = integer()();
  late final todayMinutes = integer()();
  late final weekMinutes = integer()();
  late final weekStart = text().nullable()();
  late final glancesToday = integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ActiveFocusSessions extends Table {
  late final id = integer()();
  late final pet = text().references(EmotionCatalog, #code)();
  late final planMinutes = integer()();
  late final tierMultiplier = real()();
  late final phase = text()();
  late final accumulatedSeconds = integer()();
  late final startedAtMs = integer()();
  late final lastTickAtMs = integer()();
  late final pausedAtMs = integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class DailyStates extends Table {
  late final id = integer()();
  late final date = text().nullable()();
  late final checkinDays = integer()();
  late final checkinBest = integer()();
  late final checkedToday = boolean()();
  late final lastCheckin = text().nullable()();
  late final lastGreet = text().nullable()();
  late final mazeToday = integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class DailyQuestProgressRows extends Table {
  @override
  String get tableName => 'daily_quest_progress';

  late final questCode = text().references(DailyQuestCatalog, #code)();
  late final progress = integer()();
  late final claimed = boolean()();

  @override
  Set<Column<Object>> get primaryKey => {questCode};
}

class AchievementUnlocks extends Table {
  late final code = text()();
  late final position =
      integer().customConstraint('NOT NULL CHECK (position >= 0)')();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

class RoamSlots extends Table {
  late final slotIndex = integer()();
  late final pet = text().references(EmotionCatalog, #code)();
  late final routeId = text()();
  late final startedAtMs = integer()();
  late final durationMs = integer()();

  @override
  Set<Column<Object>> get primaryKey => {slotIndex};
}

class SouvenirInventoryRows extends Table {
  @override
  String get tableName => 'souvenir_inventory';

  late final souvenirCode = text().references(SouvenirCatalog, #code)();
  late final quantity =
      integer().customConstraint('NOT NULL CHECK (quantity >= 0)')();

  @override
  Set<Column<Object>> get primaryKey => {souvenirCode};
}

class SocialProfiles extends Table {
  late final id = integer()();
  late final myName = text()();
  late final visitingPet =
      text().nullable().references(EmotionCatalog, #code)();
  late final visitingExpireMs = integer().nullable()();
  late final pendant = text().nullable().references(SouvenirCatalog, #code)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'idx_postcards_received_at', columns: {#receivedAtMs})
class Postcards extends Table {
  late final id = integer().autoIncrement()();
  late final code = text()();
  late final friendName = text()();
  late final friendPet = text().references(EmotionCatalog, #code)();
  late final receivedAtMs = integer()();
}

class ActiveMazeRuns extends Table {
  late final id = integer()();
  late final zoneIndex = integer()();
  late final seed = integer()();
  late final startLevel = integer()();
  late final floorIndex = integer()();
  late final positionX = integer()();
  late final positionY = integer()();
  late final level = integer()();
  late final keys = integer()();
  late final lanterns = integer()();
  late final steps = integer()();
  late final kills = integer()();
  late final eliteKills = integer()();
  late final bossBeaten = boolean()();
  late final usedUndo = boolean()();
  late final active = boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MazeCellStates extends Table {
  late final floorIndex = integer()();
  late final cellKey = text()();
  late final consumed = boolean()();
  late final picked = boolean()();
  late final opened = boolean()();

  @override
  Set<Column<Object>> get primaryKey => {floorIndex, cellKey};
}

class MazeUndoSnapshots extends Table {
  late final snapshotIndex = integer()();
  late final positionX = integer()();
  late final positionY = integer()();
  late final level = integer()();
  late final keys = integer()();
  late final steps = integer()();
  late final kills = integer()();
  late final eliteKills = integer()();
  late final bossBeaten = boolean()();

  @override
  Set<Column<Object>> get primaryKey => {snapshotIndex};
}

class MazeUndoCellStates extends Table {
  late final snapshotIndex = integer().references(
    MazeUndoSnapshots,
    #snapshotIndex,
    onDelete: KeyAction.cascade,
  )();
  late final floorIndex = integer()();
  late final cellKey = text()();
  late final consumed = boolean()();
  late final picked = boolean()();
  late final opened = boolean()();

  @override
  Set<Column<Object>> get primaryKey => {snapshotIndex, floorIndex, cellKey};
}

class MazeSettlements extends Table {
  late final id = integer()();
  late final exp = integer()();
  late final clearingGain = integer()();
  late final perfect = boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MazeSettlementLootRows extends Table {
  @override
  String get tableName => 'maze_settlement_loot';

  late final itemCode = text().references(ItemCatalog, #code)();
  late final quantity =
      integer().customConstraint('NOT NULL CHECK (quantity >= 0)')();

  @override
  Set<Column<Object>> get primaryKey => {itemCode};
}

@DriftDatabase(tables: [
  EmotionCatalog,
  ItemCatalog,
  DailyQuestCatalog,
  SouvenirCatalog,
  PlayerProfiles,
  TaskRows,
  PetRecords,
  InventoryRows,
  GameStatistics,
  StreakStates,
  KeeperStates,
  ResonanceStates,
  ClimateStates,
  ClimateDays,
  FocusMetadata,
  ActiveFocusSessions,
  DailyStates,
  DailyQuestProgressRows,
  AchievementUnlocks,
  RoamSlots,
  SouvenirInventoryRows,
  SocialProfiles,
  Postcards,
  ActiveMazeRuns,
  MazeCellStates,
  MazeUndoSnapshots,
  MazeUndoCellStates,
  MazeSettlements,
  MazeSettlementLootRows,
])
class MoodisleDatabase extends _$MoodisleDatabase {
  MoodisleDatabase(super.executor);

  MoodisleDatabase.defaults()
      : super(driftDatabase(
          name: 'moodisle',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await _seedCatalogs();
        },
        onUpgrade: (migrator, from, to) async {
          // Schema changes must be added here and increment schemaVersion.
        },
        beforeOpen: (_) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _seedCatalogs() async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        emotionCatalog,
        Emotion.values
            .map(
                (emotion) => EmotionCatalogCompanion.insert(code: emotion.name))
            .toList(),
      );
      batch.insertAllOnConflictUpdate(
        itemCatalog,
        ItemId.values
            .map((item) => ItemCatalogCompanion.insert(code: item.name))
            .toList(),
      );
      batch.insertAllOnConflictUpdate(
        dailyQuestCatalog,
        kDailyQuests
            .map((quest) => DailyQuestCatalogCompanion.insert(code: quest.id))
            .toList(),
      );
      batch.insertAllOnConflictUpdate(
        souvenirCatalog,
        kSouvenirs.values
            .map((souvenir) => SouvenirCatalogCompanion.insert(
                  code: souvenir.id,
                  pendant: souvenir.pendant,
                  rarity: souvenir.rarity,
                ))
            .toList(),
      );
    });
  }
}
