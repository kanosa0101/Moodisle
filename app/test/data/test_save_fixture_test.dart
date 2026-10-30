/// 测试存档夹具守护（tool/make_test_save.py 的产物）：
/// fixture 必须能被 decodeSaveDocument 解码为「基本全收集」形态；
/// 明信片码必须能被 SocialEngine.decode 验真。
/// save_codec / 枚举命名 / 明信片编码任一变更都会让本测试红，提示重新生成夹具。
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/data/save_codec.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/config/roam_config.dart';
import 'package:moodisle_app/domain/engine/achievement_engine.dart';
import 'package:moodisle_app/domain/engine/social_engine.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/pet.dart';

void main() {
  test('测试存档夹具可解码且为基本全收集形态', () {
    final raw = File('test/fixtures/test_save_v2.json').readAsStringSync();
    final doc = decodeSaveDocument(raw);
    final s = doc.state;

    expect(s.version, 2);
    expect(s.onboarded, isTrue);
    expect(s.session, isNull, reason: '夹具不应携带进行中的专注');
    expect(doc.activeMazeRun, isNull, reason: '夹具不应携带进行中的回廊');

    // 图鉴 10/10，形态与收服计数一致（JSON 与 SQLite 两条恢复链的共同不变式）
    expect(s.pets.length, 10);
    for (final e in Emotion.values) {
      final rec = s.pets[e];
      expect(rec, isNotNull, reason: '$e 应已收服');
      expect(rec!.stage, stageForCount(rec.count), reason: '$e 形态应与计数一致');
    }
    expect(
        s.pets.values.where((p) => p.stage == PetStage.awakened).length,
        greaterThanOrEqualTo(4),
        reason: '应覆盖觉醒双线样本');

    // 成就全解锁
    expect(s.achievements.toSet(), kAchievements.map((a) => a.id).toSet());

    // 十类道具全有库存
    for (final id in ItemId.values) {
      expect(s.items[id] ?? 0, greaterThan(0), reason: '${id.cn} 应有库存');
    }

    // 纪念品 20/20
    expect(s.roam.souvenirs.keys.toSet(), kSouvenirs.keys.toSet());

    // 全区域解锁（十区门槛最高 55 次累计探索）
    expect(s.stats.mazeRuns, greaterThanOrEqualTo(55));

    // 出战伙伴与行动力就绪，可直接进回廊
    expect(s.companion, isNotNull);
    expect(s.energy, greaterThan(0));

    // 明信片码可被 SocialEngine 验真（编码逐位一致）
    for (final pc in s.social.postcards) {
      final decoded = SocialEngine.decode(pc.code);
      expect(decoded, isNotNull, reason: '${pc.code} 应为有效明信片码');
      expect(decoded!.islandName, pc.friendName);
      expect(decoded.pet, pc.friendPet);
    }
  });
}
