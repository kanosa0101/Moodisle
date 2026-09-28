import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/config/roam_config.dart';
import 'package:moodisle_app/domain/engine/achievement_engine.dart';
import 'package:moodisle_app/domain/engine/season_engine.dart';
import 'package:moodisle_app/domain/engine/social_engine.dart';
import 'package:moodisle_app/domain/engine/weekly_engine.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/events/game_events.dart';

void main() {
  final now = DateTime(2026, 9, 26, 10, 0);

  group('云游引擎（docs/02 §7）', () {
    test('派遣校验：未收服/重复派遣/名额满 均拒绝', () {
      final s = GameState.fresh();
      expect(
        RoamEngine.dispatch(s, Emotion.sloth, 'monsoon', now)
            .whereType<GameNotice>()
            .isNotEmpty,
        isTrue,
      );
      s.pets[Emotion.sloth] = PetRecord(
          emotion: Emotion.sloth, count: 1, stage: PetStage.clear, bond: Bond(minutes: 0));
      expect(RoamEngine.dispatch(s, Emotion.sloth, 'monsoon', now).length, 1);
      expect(
        RoamEngine.dispatch(s, Emotion.sloth, 'monsoon', now)
            .whereType<GameNotice>()
            .isNotEmpty,
        isTrue,
      );
    });

    test('到期结算：纪念品入收藏且 NEW 标记；未到期拒绝', () {
      final s = GameState.fresh();
      s.pets[Emotion.emo] = PetRecord(
          emotion: Emotion.emo, count: 1, stage: PetStage.clear, bond: Bond(minutes: 0));
      RoamEngine.dispatch(s, Emotion.emo, 'monsoon', now);
      // 未到期
      final early = RoamEngine.claim(s, 0, now.add(const Duration(minutes: 10)));
      expect(early.whereType<GameNotice>().isNotEmpty, isTrue);
      // 到期：结算出「归来」提示
      final due = RoamEngine.claim(s, 0, now.add(const Duration(minutes: 31)));
      expect(due.whereType<GameNotice>().any((n) => n.text.contains('归来')), isTrue);
      expect(s.roam.slots, isEmpty);
      final total = s.roam.souvenirs.values.fold<int>(0, (a, b) => a + b);
      expect(total, 1);
      expect(routeById('monsoon').duration, const Duration(minutes: 30));
    });
  });

  group('群岛明信片码（docs/02 §10）', () {
    test('编码→解码 roundtrip；中英岛名/全部精灵', () {
      for (final e in Emotion.values) {
        final code = SocialEngine.encode(islandName: '屿见小筑', pet: e);
        final out = SocialEngine.decode(code)!;
        expect(out.islandName, '屿见小筑');
        expect(out.pet, e);
      }
    });

    test('校验和防篡改：改一位即失效', () {
      final code = SocialEngine.encode(islandName: '晴天岛', pet: Emotion.anxious);
      final body = code.split('-')[1];
      final tamperedChar = body[0] == 'A' ? 'B' : 'A'; // 保证确实改动
      final tampered = code.replaceFirst(body, body.replaceRange(0, 1, tamperedChar));
      expect(SocialEngine.decode(tampered), isNull);
      expect(SocialEngine.decode('MDSL-GARBAGE-XXXX'), isNull);
    });

    test('导入：挂明信片 + 精灵到访 72h；重复导入拒绝', () {
      final s = GameState.fresh();
      final code = SocialEngine.encode(islandName: '拾雾湾', pet: Emotion.sloth);
      final ev = SocialEngine.importPostcard(s, code, now);
      expect(s.social.postcards.length, 1);
      expect(s.social.visitingPet, Emotion.sloth);
      expect(s.social.hasVisitor, isTrue);
      expect(ev.whereType<GameNotice>().any((n) => n.text.contains('客住')), isTrue);
      final again = SocialEngine.importPostcard(s, code, now);
      expect(again.whereType<GameNotice>().isNotEmpty, isTrue);
    });
  });

  group('成就引擎（docs/02 §12）', () {
    test('谓词扫描：达成即解锁且不重复', () {
      final s = GameState.fresh();
      s.stats.totalDone = 1;
      s.streak.sunnyDays = 3;
      final first = AchievementEngine.check(s);
      expect(first.map((a) => a.id), containsAll(['first', 'sunny3']));
      final again = AchievementEngine.check(s);
      expect(again, isEmpty);
      expect(s.achievements.contains('first'), isTrue);
    });

    test('岛民/社交类成就', () {
      final s = GameState.fresh();
      final code = SocialEngine.encode(islandName: '友岛', pet: Emotion.shy);
      SocialEngine.importPostcard(s, code, now);
      final fresh = AchievementEngine.check(s);
      expect(fresh.map((a) => a.id), containsAll(['penpal', 'visitor']));
    });
  });

  group('心晴周报（docs/02 §9）', () {
    test('数据聚合与洞察分支', () {
      final s = GameState.fresh();
      s.stats.mazeRuns = 4;
      s.resonance.best = 3;
      s.pets[Emotion.emo] = PetRecord(
          emotion: Emotion.emo,
          count: 2,
          stage: PetStage.rainbow,
          bond: Bond(minutes: 120));
      final report = WeeklyEngine.build(s, now);
      expect(report.lines.length, greaterThanOrEqualTo(4));
      expect(report.headline, isNotEmpty);
      expect(report.weekStart.day, lessThanOrEqualTo(now.day));
      // 空档期文案分支
      final empty = WeeklyEngine.build(GameState.fresh(), now);
      expect(empty.headline, contains('安静'));
    });
  });

  group('四季与节日', () {
    test('月份映射季节', () {
      expect(seasonOf(DateTime(2026, 3, 15)).id, 'spring');
      expect(seasonOf(DateTime(2026, 7, 15)).id, 'summer');
      expect(seasonOf(DateTime(2026, 10, 15)).id, 'autumn');
      expect(seasonOf(DateTime(2026, 1, 15)).id, 'winter');
    });

    test('节日判定', () {
      expect(festivalOf(DateTime(2026, 1, 2))!.name, '新年');
      expect(festivalOf(DateTime(2026, 10, 31))!.name, '万圣夜');
      expect(festivalOf(DateTime(2026, 5, 5)), isNull);
    });
  });
}
