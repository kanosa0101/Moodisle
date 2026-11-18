import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/data/database.dart';
import 'package:moodisle_app/data/game_repository.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/events/game_events.dart';
import 'package:moodisle_app/domain/game_core.dart';
import 'package:moodisle_app/domain/time/local_date.dart';

GameState focusedState(DateTime start,
    {int minutes = 25, bool custom = false}) {
  final state = GameState.fresh();
  state.pets[Emotion.emo] = PetRecord(
      emotion: Emotion.emo,
      count: 1,
      stage: PetStage.clear,
      bond: Bond(minutes: 0));
  GameCore(state).startFocus(Emotion.emo, minutes, start, custom: custom);
  return state;
}

void main() {
  test('40 分钟自定义会话切后台暂停，SQLite 恢复后锁屏继续', () async {
    final db = MoodisleDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = SqliteGameRepository(database: db);
    final start = DateTime(2026, 11, 18, 10);
    final state = focusedState(start, minutes: 40, custom: true);
    final core = GameCore(state);
    core.focusOnBackgrounded(start.add(const Duration(minutes: 10)));
    await repo.save(state);
    final restored = (await repo.load())!.state;
    final resumed = GameCore(restored);
    final back = start.add(const Duration(minutes: 25));
    resumed.focusOnResumed(back);
    expect(restored.session!.remainingSecondsAt(back), 30 * 60);
    resumed.focusOnScreenLocked(back);
    final events =
        resumed.focusOnResumed(back.add(const Duration(minutes: 30)));
    expect(events.whereType<FocusCompleted>().single.minutes, 40);
    expect(restored.stats.deepDives, 0);
  });

  test('SQLite v2 升级保留旧任务，新增完成日期可持久化', () async {
    final directory =
        await Directory.systemTemp.createTemp('moodisle-task-schema-');
    final file = File('${directory.path}/save.sqlite');
    var db = MoodisleDatabase(NativeDatabase(file));
    try {
      final state = focusedState(DateTime(2026, 11, 15, 10));
      final core = GameCore(state);
      core.addTask('历史完成', Emotion.sloth, 1, DateTime(2026, 11, 15));
      core.completeTask(1, now: DateTime(2026, 11, 15));
      await SqliteGameRepository(database: db).save(state);
      await db.customStatement('ALTER TABLE tasks DROP COLUMN completed_on');
      await db.customStatement('PRAGMA user_version = 2');
      await db.close();
      db = MoodisleDatabase(NativeDatabase(file));
      final repository = SqliteGameRepository(database: db);
      final restored = (await repository.load())!.state;
      expect(restored.tasks.single.text, '历史完成');
      expect(restored.tasks.single.completedOn, isNull);
      expect(restored.session!.endsAt, state.session!.endsAt);
      final updated = GameCore(restored);
      updated.addTask('新任务', Emotion.sloth, 1, DateTime(2026, 11, 16));
      updated.completeTask(2, now: DateTime(2026, 11, 17));
      await repository.save(restored);
      expect((await repository.load())!.state.tasks.singleWhere((task) => task.id == 2).completedOn,
          const LocalDate(2026, 11, 17));
    } finally {
      await db.close();
      await directory.delete(recursive: true);
    }
  });

  for (final paused in [false, true]) {
    test('SQLite 恢复${paused ? '暂停' : '锁屏'}会话保留截止时间', () async {
      final db = MoodisleDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = SqliteGameRepository(database: db);
      final start = DateTime(2026, 11, 15, 10, 0, 0, 350);
      final state = focusedState(start);
      final core = GameCore(state);
      final leave = start.add(const Duration(milliseconds: 1250));
      if (paused) {
        core.focusOnBackgrounded(leave);
      } else {
        core.focusOnScreenLocked(leave);
      }
      await repository.save(state);
      final restored = (await repository.load())!.state;
      expect(restored.session!.endsAt, state.session!.endsAt);
      final returned = leave.add(const Duration(minutes: 30));
      final events = GameCore(restored).focusOnResumed(returned);
      if (paused) {
        expect(restored.session!.remainingAt(returned),
            const Duration(minutes: 24, seconds: 58, milliseconds: 750));
      } else {
        expect(events.whereType<FocusCompleted>(), hasLength(1));
        expect(restored.session, isNull);
        await repository.save(restored);
        expect((await repository.load())!.state.session, isNull);
      }
    });
  }

  test('真实 SQLite v1 文件升级至 v3 后保留旧会话与伙伴', () async {
    final directory = await Directory.systemTemp.createTemp('moodisle-schema-');
    final file = File('${directory.path}/save.sqlite');
    var db = MoodisleDatabase(NativeDatabase(file));
    try {
      final start = DateTime(2026, 11, 15, 10);
      final state = focusedState(start);
      GameCore(state)
          .focusOnBackgrounded(start.add(const Duration(minutes: 5)));
      await SqliteGameRepository(database: db).save(state);
      // 移除 v2 唯一新增列，构造与 v1 发布版一致的表和版本号。
      await db.customStatement(
          'ALTER TABLE active_focus_sessions DROP COLUMN ends_at_ms');
      await db.customStatement('ALTER TABLE tasks DROP COLUMN completed_on');
      await db.customStatement('PRAGMA user_version = 1');
      await db.close();
      db = MoodisleDatabase(NativeDatabase(file));
      final restored = (await SqliteGameRepository(database: db).load())!.state;
      expect(restored.pets[Emotion.emo], isNotNull);
      expect(restored.session!.phase, 'glancing');
      expect(restored.session!.endsAt, start.add(const Duration(minutes: 25)));
      final returned = start.add(const Duration(hours: 1));
      GameCore(restored).focusOnResumed(returned);
      expect(
          restored.session!.remainingAt(returned), const Duration(minutes: 20));
      final version = await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 3);
    } finally {
      await db.close();
      await directory.delete(recursive: true);
    }
  });
}
