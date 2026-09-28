import 'dart:math' show Random;

import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/config/game_config.dart';
import 'package:moodisle_app/domain/engine/climate.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/events/game_events.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/game_core.dart';
import 'package:moodisle_app/domain/time/local_date.dart';

/// 固定随机源：灵感时刻永不触发（nextDouble 恒 0.99）。
class _FixedRandom implements Random {
  final double v;
  _FixedRandom(this.v);
  @override
  bool nextBool() => false;
  @override
  int nextInt(int max) => max - 1;
  @override
  double nextDouble() => v;
}

/// docs/03 §5.1 算例 TC-CAP-001 的回归断言。
void main() {
  final now = DateTime(2026, 9, 25, 10, 0);
  const today = LocalDate(2026, 9, 25);

  GameState setup() {
    final s = GameState.fresh();
    s.streak.sunnyDays = 3;
    s.streak.lastSunny = today.yesterday;
    s.keeper.level = 3;
    s.keeper.exp = 55;
    s.resonance.last = Emotion.shy; // 霞→雷 承接（docs/02 §4 新环序）
    s.resonance.len = 2;
    s.resonance.best = 2;
    s.resonance.lastAt = now.subtract(const Duration(hours: 1));
    s.climate.tier = ClimateTier.mist; // 薄雾（文档口径 fog=48）
    s.pets[Emotion.anxious] = PetRecord(
        emotion: Emotion.anxious,
        count: 4,
        stage: PetStage.clear,
        bond: Bond(minutes: 0));
    s.pets[Emotion.emo] = PetRecord(
        emotion: Emotion.emo,
        count: 1,
        stage: PetStage.clear,
        bond: Bond(minutes: 0));
    // 每日面初始化（任务槽就绪；tier 保持 mist，雾露投放不影响断言）
    GameCore(s, rng: _FixedRandom(0.99)).ensureDaily(now);
    return s;
  }

  test('TC-CAP-001 完成焦虑待办：收服/共鸣/连晴/放晴/升级全链路', () {
    final s = setup();
    final core = GameCore(s, rng: _FixedRandom(0.99));
    core.addTask('写周报', Emotion.anxious, 2, now);
    final events =
        core.completeTask(1, feedback: FeedbackKind.relieved, now: now);

    // ② 精灵计数与形态：4 → 5 跨入虹态
    final pet = s.pets[Emotion.anxious]!;
    expect(pet.count, 5);
    expect(pet.stage, PetStage.rainbow);
    final evoEvents = events.whereType<EvolutionRevealed>().toList();
    expect(evoEvents.length, 1);
    expect(evoEvents.first.emotion, Emotion.anxious);
    expect(evoEvents.first.stage, PetStage.rainbow);

    // ⑥ 共鸣：霞→雷 续链 len 2→3；共演掉落 1 + 里程碑 1 = 虹晶×2
    expect(s.resonance.len, 3);
    expect(s.resonance.best, 3);
    expect(s.resonance.last, Emotion.anxious);
    expect(s.items[ItemId.prismCrystal], 2);
    expect(events.whereType<ResonanceFired>().length, 1);

    // ⑦ 连晴 3 → 4
    expect(s.streak.sunnyDays, 4);
    expect(s.streak.lastSunny, today);

    // ⑧⑨ 放晴：round(7×1.2)=8 + 链 2 = 10
    expect(s.clearing, 10.0);

    // ⑩ 行动力
    expect(s.energy, 1);

    // ⑪ 经验：25+20+2=47 → 55+47=102 → Lv4 exp2，解锁每日回廊+1
    expect(s.keeper.level, 4);
    expect(s.keeper.exp, 2);
    final lu = events.whereType<KeeperLevelUp>().toList();
    expect(lu.length, 1);
    expect(lu.first.unlocks, contains('每日回廊次数 +1'));

    // ⑫⑬ 气候桶与每日任务
    expect(s.climate.days.firstWhere((b) => b.date == today).done, 1);
    expect(s.daily.quests['do3']!.prog, 1);
    expect(s.daily.quests['chain3']!.prog, 3);

    // ⑭ 汇总事件
    final cap = events.whereType<TaskCaptured>().toList();
    expect(cap.length, 1);
    expect(cap.first.chainLinked, isTrue);
    expect(cap.first.chainLen, 3);
    expect(cap.first.evolved, isTrue);
    expect(cap.first.keeperLevelUp, isTrue);
  });

  test('重复完成同一待办被拒绝', () {
    final s = setup();
    final core = GameCore(s, rng: _FixedRandom(0.99));
    core.addTask('写周报', Emotion.anxious, 2, now);
    core.completeTask(1, feedback: FeedbackKind.relieved, now: now);
    final again = core.completeTask(1, now: now);
    expect(again.whereType<TaskCaptured>(), isEmpty);
    expect(again.whereType<GameNotice>(), isNotEmpty);
  });

  test('培育：晨露推进计数，跨段派发进化事件；觉醒时判分支', () {
    final s = setup();
    s.items[ItemId.morningDew] = 6;
    final core = GameCore(s, rng: _FixedRandom(0.99));
    // anxious 从 count4（晴态）喂到觉醒态 count10：恰好 6 枚晨露
    for (var i = 0; i < 6; i++) {
      core.cultivate(Emotion.anxious, now: now);
    }
    expect(s.pets[Emotion.anxious]!.count, 10);
    expect(s.pets[Emotion.anxious]!.stage, PetStage.awakened);
    // turmoil(=anxious10+chaos0)=10 > persistence(=sunnyDays3+best3=6) → 深流线
    expect(s.pets[Emotion.anxious]!.branch, Branch.deepcurrent);
    expect(s.items[ItemId.morningDew], 0);
  });
}
