import 'dart:math' show Random;

import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/entities/task.dart';
import 'package:moodisle_app/domain/game_core.dart';

/// 不变式模糊测试（docs/03 §12「不变式」行的可执行形态）：
/// 固定种子随机操作序列，每步之后全量断言状态合法性。
/// 任何「负资产/越界/计数漂移」类回归都会在此暴露。
void main() {
  test('300 次随机操作后全部不变式成立（seed=7 可复现）', () {
    final rng = Random(7);
    final state = GameState.fresh();
    final core = GameCore(state, rng: rng);
    var now = DateTime(2026, 9, 25, 8, 0);

    for (var i = 0; i < 300; i++) {
      final r = rng.nextDouble();
      if (r < 0.28) {
        core.addTask('任务$i', Emotion.values[rng.nextInt(Emotion.values.length)],
            1 + rng.nextInt(3), now);
      } else if (r < 0.52) {
        final pending =
            state.tasks.where((t) => t.status == TaskStatus.pending).toList();
        if (pending.isNotEmpty) {
          final t = pending[rng.nextInt(pending.length)];
          core.completeTask(t.id,
              feedback: rng.nextBool() ? FeedbackKind.calm : null, now: now);
        }
      } else if (r < 0.60) {
        if (state.session == null && state.pets.isNotEmpty) {
          final pets = state.pets.keys.toList();
          core.startFocus(pets[rng.nextInt(pets.length)], 15, now);
        }
      } else if (r < 0.72) {
        for (var k = 0; k < 20 && state.session != null; k++) {
          now = now.add(const Duration(minutes: 1));
          core.focusTick(now);
        }
        if (state.session?.phase == 'glancing') {
          core.focusOnResumed(now);
        }
      } else if (r < 0.78) {
        core.focusOnBackgrounded(now);
      } else if (r < 0.83) {
        core.focusOnResumed(now);
      } else if (r < 0.87) {
        core.cancelFocus(now);
      } else if (r < 0.93) {
        now = now.add(Duration(minutes: 60 + rng.nextInt(1800)));
        core.ensureDaily(now);
      } else if (r < 0.97) {
        final affordable = ItemId.values
            .where((id) => (state.items[id] ?? 0) > 0)
            .toList();
        if (affordable.isNotEmpty) {
          core.useItem(affordable[rng.nextInt(affordable.length)], now);
        }
      } else {
        final dew = state.items[ItemId.morningDew] ?? 0;
        if (dew > 0 && state.pets.isNotEmpty) {
          final pets = state.pets.keys.toList();
          core.cultivate(pets[rng.nextInt(pets.length)], now: now);
        }
      }
      _checkInvariants(state, 'step $i');
    }
  });
}

void _checkInvariants(GameState s, String where) {
  void expectTrue(bool cond, String msg) =>
      expect(cond, isTrue, reason: '$where: $msg');

  for (final e in s.items.entries) {
    expectTrue(e.value >= 0, '道具 ${e.key} 数量为负：${e.value}');
  }
  expect(s.clearing, inInclusiveRange(0, 100), reason: where);
  expectTrue(s.energy >= 0, '行动力为负');
  expect(s.keeper.exp, inInclusiveRange(0, 99), reason: where);
  expectTrue(s.keeper.level >= 1, '看岛人等级异常');
  expectTrue(s.resonance.len >= 0 && s.resonance.len <= s.resonance.best,
      '共鸣链长度越过历史最长');
  expectTrue(s.streak.sunnyDays >= 0, '连晴天数为负');
  final sess = s.session;
  if (sess != null) {
    expect(sess.planMin, inInclusiveRange(5, 120), reason: where);
    expectTrue(
        sess.phase == 'focusing' || sess.phase == 'glancing', '未知会话阶段');
  }
  for (final p in s.pets.values) {
    expect(p.bond.level, inInclusiveRange(0, 10), reason: where);
    expectTrue(p.count >= 1, '精灵计数异常');
    if (p.stage == PetStage.awakened) {
      expectTrue(p.branch != null, '觉醒态缺失分支');
    }
  }
}
