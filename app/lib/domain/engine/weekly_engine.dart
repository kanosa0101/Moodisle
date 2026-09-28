/// 心晴周报引擎（docs/02 §9）：纯本地聚合 + 模板文案（无 LLM）。
library;

import '../entities/game_state.dart';
import '../entities/emotion.dart';
import '../entities/pet.dart';
import '../time/local_date.dart';

class WeeklyReport {
  final List<String> lines; // 报告正文（数据行 + 洞察句）
  final String headline; // 一句话洞察
  final LocalDate weekStart;

  const WeeklyReport(
      {required this.lines, required this.headline, required this.weekStart});
}

class WeeklyEngine {
  WeeklyEngine._();

  /// 生成最近 7 天周报（气候桶数据 + 图鉴 + 共鸣 + 专注）。
  static WeeklyReport build(GameState s, DateTime now) {
    final today = LocalDate.today(now);
    final weekStart = today.addDays(-6);
    var done7 = 0;
    var focus7 = 0;
    for (final b in s.climate.days) {
      if (b.date >= weekStart) {
        done7 += b.done;
        focus7 += b.focusMin;
      }
    }
    final owned = s.pets.length;
    final topPet = _topPet(s);
    final fog = s.climate.fog.round();
    final lines = <String>[
      '完成待办 $done7 件 · 专注 $focus7 分钟',
      '图鉴 $owned/10 · 回廊 ${s.stats.mazeRuns} 次',
      '最长共鸣链 ×${s.resonance.best} · 放晴度 ${s.clearing.round()}% · 心雾 $fog%',
      if (topPet != null)
        '最默契的伙伴：${topPet.emotion.petCn}（羁绊 Lv.${topPet.bond.level}）',
    ];
    return WeeklyReport(
      lines: lines,
      headline: _insight(
          done7: done7, focus7: focus7, fog: fog, best: s.resonance.best),
      weekStart: weekStart,
    );
  }

  static PetRecord? _topPet(GameState s) {
    PetRecord? top;
    for (final p in s.pets.values) {
      if (top == null || p.bond.minutes > top.bond.minutes) top = p;
    }
    return top;
  }

  /// 模板洞察（≥30 条目标下的 MVP 分支文案；按数据分支选择，全本地）。
  static String _insight(
      {required int done7,
      required int focus7,
      required int fog,
      required int best}) {
    if (done7 == 0 && focus7 == 0) {
      return '这一周小岛安静得很。没关系，雾里也有雾露——回来就好。';
    }
    if (fog >= 60) {
      return '岛上雾气有点重，别急，每天完成一件小事，雾就会从边缘开始散。';
    }
    if (best >= 5) {
      return '共鸣链已经连到 ×$best 了——你比上周更懂自己的情绪节奏了。';
    }
    if (focus7 >= 150) {
      return '本周专注了 $focus7 分钟，它一直在你身边。这份安稳是攒出来的。';
    }
    if (done7 >= 10) {
      return '完成 $done7 件真实的事——天气在变好，你的心情也是。';
    }
    return '细水长流的一周。每只被安抚的精灵，都是你照顾自己的证据。';
  }
}
