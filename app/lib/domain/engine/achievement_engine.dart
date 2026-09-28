/// 成就引擎（docs/02 §12）：谓词式全量扫描（继承思想、自研实现）。
/// 任何写事件后调用 check；零惩罚——成就只增不减。
library;

import '../entities/game_state.dart';
import '../entities/pet.dart';

class AchievementDef {
  final String id;
  final String title;
  final String desc;
  final bool Function(GameState s) test;
  const AchievementDef(this.id, this.title, this.desc, this.test);
}

final List<AchievementDef> kAchievements = [
  AchievementDef('first', '初次放晴', '首次收服天气精灵', (s) => s.stats.totalDone >= 1),
  AchievementDef('sunny3', '连晴三日', '连晴天数达到 3', (s) => s.streak.sunnyDays >= 3),
  AchievementDef('sunny7', '连晴一周', '连晴天数达到 7', (s) => s.streak.sunnyDays >= 7),
  AchievementDef('dex', '图鉴大师', '集齐全部 10 种精灵', (s) => s.pets.length >= 10),
  AchievementDef('rainbow', '虹态初现', '首次培育到虹态',
      (s) => s.pets.values.any((p) => p.stage == PetStage.rainbow)),
  AchievementDef('awakened', '觉醒之友', '首次到达觉醒态',
      (s) => s.pets.values.any((p) => p.stage == PetStage.awakened)),
  AchievementDef(
      'constellation',
      '星宿同游',
      '觉醒星宿线形态',
      (s) => s.pets.values.any((p) =>
          p.branch == Branch.constellation && p.stage == PetStage.awakened)),
  AchievementDef(
      'deepcurrent',
      '深流同游',
      '觉醒深流线形态',
      (s) => s.pets.values.any((p) =>
          p.branch == Branch.deepcurrent && p.stage == PetStage.awakened)),
  AchievementDef('clear100', '雾散见日', '放晴度达到 100%', (s) => s.clearing >= 100),
  AchievementDef('chain3', '共鸣初响', '共鸣链达到 ×3', (s) => s.resonance.best >= 3),
  AchievementDef('chain5', '共鸣大师', '共鸣链达到 ×5', (s) => s.resonance.best >= 5),
  AchievementDef(
      'maze10', '回廊行者', '累计探索回廊 10 次', (s) => s.stats.mazeRuns >= 10),
  AchievementDef(
      'dew20', '雾中拾荒', '累计拾取 20 枚雾露', (s) => s.stats.mistDewCollected >= 20),
  AchievementDef(
      'deep5', '深潜者', '完成 5 次深潜（50 分钟）', (s) => s.stats.deepDives >= 5),
  AchievementDef('bond10', '心流同频', '任一精灵羁绊达到 Lv.10',
      (s) => s.pets.values.any((p) => p.bond.level >= 10)),
  AchievementDef('collector', '收藏家', '集齐 4 件以上云游纪念品',
      (s) => s.roam.souvenirs.keys.length >= 4),
  AchievementDef(
      'penpal', '笔友', '首次互通岛屿明信片', (s) => s.social.postcards.isNotEmpty),
  AchievementDef('visitor', '客座嘉宾', '有好友精灵到访岛上', (s) => s.social.hasVisitor),
];

class AchievementEngine {
  AchievementEngine._();

  /// 全量扫描并解锁新成就；返回新解锁列表（供 toast）。
  static List<AchievementDef> check(GameState s) {
    final fresh = <AchievementDef>[];
    for (final def in kAchievements) {
      if (!s.achievements.contains(def.id) && def.test(s)) {
        s.achievements.add(def.id);
        fresh.add(def);
      }
    }
    return fresh;
  }
}
