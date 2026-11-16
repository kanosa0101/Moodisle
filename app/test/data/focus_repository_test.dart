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

GameState focusedState(DateTime start) {
  final state = GameState.fresh();
  state.pets[Emotion.emo] = PetRecord(
      emotion: Emotion.emo, count: 1, stage: PetStage.clear,
      bond: Bond(minutes: 0));
  GameCore(state).startFocus(Emotion.emo, 25, start);
  return state;
}

void main() {
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

  test('真实 SQLite v1 文件升级至 v2 后保留旧会话与伙伴', () async {
    final directory = await Directory.systemTemp.createTemp('moodisle-schema-');
    final file = File('${directory.path}/save.sqlite');
    var db = MoodisleDatabase(NativeDatabase(file));
    try {
      final start = DateTime(2026, 11, 15, 10);
      final state = focusedState(start);
      GameCore(state).focusOnBackgrounded(
          start.add(const Duration(minutes: 5)));
      await SqliteGameRepository(database: db).save(state);
      // 移除 v2 唯一新增列，构造与 v1 发布版一致的表和版本号。
      await db.customStatement(
          'ALTER TABLE active_focus_sessions DROP COLUMN ends_at_ms');
      await db.customStatement('PRAGMA user_version = 1');
      await db.close();
      db = MoodisleDatabase(NativeDatabase(file));
      final restored = (await SqliteGameRepository(database: db).load())!.state;
      expect(restored.pets[Emotion.emo], isNotNull);
      expect(restored.session!.phase, 'glancing');
      expect(restored.session!.endsAt, start.add(const Duration(minutes: 25)));
      final returned = start.add(const Duration(hours: 1));
      GameCore(restored).focusOnResumed(returned);
      expect(restored.session!.remainingAt(returned),
          const Duration(minutes: 20));
      final version = await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 2);
    } finally {
      await db.close();
      await directory.delete(recursive: true);
    }
  });
}
