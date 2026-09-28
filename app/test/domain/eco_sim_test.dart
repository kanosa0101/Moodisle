import 'package:flutter_test/flutter_test.dart';
import 'dart:math' show Random;
import 'package:moodisle_app/domain/engine/eco_sim.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';
import 'package:moodisle_app/domain/entities/game_state.dart';
import 'package:moodisle_app/domain/entities/pet.dart';
import 'package:moodisle_app/domain/game_core.dart';

void main() {
  test('rebuild：未完成待办 → 野生怪；已收服 → 定居精灵；位置保持', () {
    final s = GameState.fresh();
    final c = GameCore(s);
    final now = DateTime(2026, 9, 26, 9, 0);
    c.ensureDaily(now);
    c.addTask('任务A', Emotion.anxious, 2, now);
    c.addTask('任务B', Emotion.emo, 1, now);
    s.pets[Emotion.sloth] = PetRecord(
        emotion: Emotion.sloth, count: 3, stage: PetStage.clear, bond: Bond(minutes: 0));

    final sim = EcoSim(rng: RandomStub());
    sim.rebuild(s);
    expect(sim.actors.length, 3);
    expect(sim.actors.where((a) => a.wild).length, 2);
    expect(sim.actors.where((a) => !a.wild).length, 1);

    // 落户映射：焦虑→晴坪 / 低落→雨湖 / 拖延→雾林
    expect(
        sim.actors.firstWhere((a) => a.emotion == Emotion.anxious).biome,
        Biome.sunnyMeadow);
    expect(sim.actors.firstWhere((a) => a.emotion == Emotion.emo).biome,
        Biome.rainLake);
    expect(sim.actors.firstWhere((a) => a.emotion == Emotion.sloth).biome,
        Biome.mistWoods);

    // 完成任务A → 收服（anxious 定居上岛），对应野生怪离场，其余位置保持
    c.completeTask(1, now: now);
    final before = sim.actors.firstWhere((a) => a.key == 'wild:2');
    sim.rebuild(s);
    expect(sim.actors.where((a) => a.key == 'wild:1'), isEmpty);
    expect(sim.actors.firstWhere((a) => a.key == 'wild:2').x, before.x);
    expect(sim.actors.where((a) => a.key == 'pet:anxious').length, 1);
    expect(sim.actors.length, 3);
  });

  test('tick：walk 状态向目标移动并在到达后转 idle', () {
    final sim = EcoSim(rng: RandomStub());
    final s = GameState.fresh();
    s.pets[Emotion.perfect] = PetRecord(
        emotion: Emotion.perfect, count: 1, stage: PetStage.clear, bond: Bond(minutes: 0));
    sim.rebuild(s);
    final a = sim.actors.single;
    a.x = 0;
    a.y = 0;
    a.tx = 100;
    a.ty = 0;
    a.state = ActorState.walk;
    // 速度 ≈ 37px/s：100px 需约 163 帧；170 帧后应已到达且仍在 idle（计时未走完）
    for (var i = 0; i < 170; i++) {
      sim.tick(1 / 60);
    }
    expect(a.x, 100);
    expect(a.state, ActorState.idle);
  });

  test('tap：命中半径内返回 actor 并触发小动作', () {
    final sim = EcoSim(rng: RandomStub());
    final s = GameState.fresh();
    s.pets[Emotion.anxious] = PetRecord(
        emotion: Emotion.anxious, count: 1, stage: PetStage.clear, bond: Bond(minutes: 0));
    sim.rebuild(s);
    final a = sim.actors.single;
    a.x = 600;
    a.y = 400;
    final hit = sim.tap(600, 382); // 命中点偏向身体中部
    expect(hit, same(a));
    expect(a.state, ActorState.act);
    expect(sim.tap(0, 0), isNull);
  });

  test('所有情绪都有合法落户区且区内取点落在世界范围内', () {
    final sim = EcoSim(rng: RandomStub());
    for (final e in Emotion.values) {
      final b = Biome.of(e);
      for (var i = 0; i < 50; i++) {
        final p = sim.zonePoint(b);
        expect(p.dx, inInclusiveRange(0, kWorldW));
        expect(p.dy, inInclusiveRange(0, kWorldH));
      }
    }
  });
}

class RandomStub implements Random {
  var i = 0;
  @override
  bool nextBool() => false;
  @override
  int nextInt(int max) => (i++ * 7) % max;
  @override
  double nextDouble() => 0.42;
}
