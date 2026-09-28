/// 成长页：看岛人看板 / 连晴 / 签到 / 每日任务 / 放晴度 / 存档导入导出。
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../application/game_controller.dart';
import '../../domain/config/game_config.dart';
import '../../domain/config/keeper.dart';
import '../../domain/engine/achievement_engine.dart';
import '../../domain/engine/climate.dart';
import '../../domain/engine/season_engine.dart';
import '../../domain/engine/weekly_engine.dart';
import '../../domain/entities/emotion.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/page_frame.dart';
import '../widgets/game_icons.dart';

class GrowPage extends StatelessWidget {
  final GameController controller;
  GrowPage({super.key, required this.controller}) {
    GrowPageRegistry.last = controller;
  }

  @override
  Widget build(BuildContext context) {
    // 独立路由页也要套 460 框架（对齐原版 #app 全局约束）
    return PageFrame(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('成长',
              style: TextStyle(
                  fontWeight: FontWeight.w900, color: Color(0xFF5A3E22))),
        ),
        body: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final s = controller.state;
              final perks = keeperPerks(s.keeper.level);
              return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    Row(children: [
                      _Stat(v: '${s.streak.sunnyDays}', k: '连晴天数'),
                      const SizedBox(width: 10),
                      _Stat(v: '${s.stats.totalDone}', k: '累计完成'),
                      const SizedBox(width: 10),
                      _Stat(v: '${s.stats.mazeRuns}', k: '回廊探索'),
                    ]),
                    const SizedBox(height: 10),
                    _Panel(
                      title: '看岛人 Lv.${s.keeper.level}',
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: s.keeper.exp / GameConfig.expPerLevel,
                                minHeight: 10,
                                backgroundColor: const Color(0xFFE6D4AC),
                                color: MoodisleColors.orange,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                                '${s.keeper.exp} / ${GameConfig.expPerLevel} 经验',
                                style: const TextStyle(
                                    fontSize: 11, color: MoodisleColors.ink2)),
                            const SizedBox(height: 8),
                            Text(
                                '每日回廊 +${perks.extraDailyMaze} · '
                                '寻宝率 +${(perks.lootChance * 100).round()}% · '
                                '点亮 +${perks.lightBonus}',
                                style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF5A3E22))),
                          ]),
                    ),
                    const SizedBox(height: 10),
                    _Panel(
                      title: '放晴度 ${s.clearing.round()}%',
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: s.clearing / 100,
                                minHeight: 10,
                                backgroundColor: const Color(0xFFE6D4AC),
                                color: MoodisleColors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                                '心雾 ${s.climate.fog.round()}% · '
                                '${switch (s.climate.tier) {
                                  ClimateTier.sunny => '晴',
                                  ClimateTier.mist => '薄雾',
                                  ClimateTier.denseFog => '浓雾',
                                }} · 今日心雾随你的待办与专注而变化',
                                style: const TextStyle(
                                    fontSize: 11, color: MoodisleColors.ink2)),
                          ]),
                    ),
                    const SizedBox(height: 10),
                    _Panel(
                      title: '每日心流（连续签到 ${s.daily.checkinDays} 天）',
                      child: Column(children: [
                        FilledButton(
                          onPressed: s.daily.checkedToday
                              ? null
                              : () => controller.checkin(),
                          style: FilledButton.styleFrom(
                              backgroundColor: MoodisleColors.green),
                          child:
                              Text(s.daily.checkedToday ? '今日已签到 ✓' : '签到领奖'),
                        ),
                        const SizedBox(height: 10),
                        for (final q in kDailyQuests)
                          _QuestRow(controller: controller, questId: q.id),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    _Panel(
                      title:
                          '成就墙（${s.achievements.length}/${kAchievements.length}）',
                      child: Column(children: [
                        for (final a in kAchievements)
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFDF7),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: s.achievements.contains(a.id)
                                      ? MoodisleColors.green
                                      : const Color(0xFFEFE1C2)),
                            ),
                            child: Row(children: [
                              Opacity(
                                opacity:
                                    s.achievements.contains(a.id) ? 1 : 0.4,
                                child: Image.asset(
                                    'assets/items/icons/star_badge.png',
                                    width: 24,
                                    height: 24),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${a.title}${s.achievements.contains(a.id) ? '' : '（未解锁）'}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color:
                                                  s.achievements.contains(a.id)
                                                      ? const Color(0xFF5A3E22)
                                                      : MoodisleColors.ink2)),
                                      Text(a.desc,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: MoodisleColors.ink2)),
                                    ]),
                              ),
                            ]),
                          ),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    _Panel(
                      title: '心晴周报',
                      child: Column(children: [
                        FilledButton(
                          onPressed: () => _showWeekly(context),
                          style: FilledButton.styleFrom(
                              backgroundColor: MoodisleColors.orange),
                          child: const Text('生成本周心晴周报'),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    _Panel(
                      title: '群岛（零服务器异步社交）',
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                '把你的岛屿明信片码发给朋友；导入对方码，对方的招牌精灵会来你家岛客住 72 小时。',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: MoodisleColors.ink2,
                                    height: 1.5)),
                            const SizedBox(height: 8),
                            Row(children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text: controller.myPostcardCode()));
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('你的明信片码已复制')));
                                    }
                                  },
                                  child: const Text('复制我的码',
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _importCodeDialog(context),
                                  child: const Text('导入好友码',
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ]),
                            if (s.social.hasVisitor)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                    '「${s.social.postcards.firstOrNull?.friendName ?? '朋友'}」的'
                                    '${s.social.visitingPet?.petCn ?? ""} 正在你岛上做客',
                                    style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2EA05F))),
                              ),
                            for (final pc in s.social.postcards.take(3))
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                    '${pc.friendName} · ${pc.friendPet.petCn}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: MoodisleColors.ink2)),
                              ),
                          ]),
                    ),
                    const SizedBox(height: 10),
                    _SeasonCard(),
                    const SizedBox(height: 10),
                    _Panel(
                      title: '存档（本机 / 导出导入）',
                      child: Column(children: [
                        Row(children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(
                                    text: controller.exportSaveJson()));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('存档 JSON 已复制到剪贴板')));
                                }
                              },
                              child: const Text('导出（复制 JSON）',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final data =
                                    await Clipboard.getData('text/plain');
                                final ok = data?.text != null &&
                                    controller.importSaveJson(data!.text!);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(ok
                                              ? '存档已恢复'
                                              : '导入失败：剪贴板不是有效存档')));
                                }
                              },
                              child: const Text('导入（读取剪贴板）',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ]),
                      ]),
                    ),
                  ]);
            }),
      ),
    );
  }
}

/// 气候档位显示直接使用 domain 的 ClimateTier（见上方 switch）。

class _Stat extends StatelessWidget {
  final String v;
  final String k;
  const _Stat({required this.v, required this.k});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: PaperPanel.decoration(),
        child: Column(children: [
          Text(v,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: MoodisleColors.orange)),
          Text(k,
              style:
                  const TextStyle(fontSize: 10.5, color: MoodisleColors.ink2)),
        ]),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final Widget child;
  const _Panel({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: PaperPanel.decoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF5A3E22))),
        const SizedBox(height: 8),
        child,
      ]),
    );
  }
}

class _QuestRow extends StatelessWidget {
  final GameController controller;
  final String questId;
  const _QuestRow({required this.controller, required this.questId});

  @override
  Widget build(BuildContext context) {
    final def = kDailyQuests.firstWhere((q) => q.id == questId);
    final slot = controller.state.daily.quests[questId];
    final prog = slot?.prog ?? 0;
    final done = prog >= def.goal;
    final claimed = slot?.claimed ?? false;
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF7),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
            color: done && !claimed
                ? MoodisleColors.green
                : const Color(0xFFEFE1C2)),
      ),
      child: Row(children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(def.title,
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w800)),
              ),
              ItemIcon(def.reward, size: 16),
              const SizedBox(width: 3),
              Text('${def.reward.cn}×${def.rewardN}',
                  style: const TextStyle(
                      fontSize: 10.5, color: MoodisleColors.ink2)),
            ]),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: prog / def.goal,
                minHeight: 6,
                backgroundColor: const Color(0xFFECE0C4),
                color: MoodisleColors.green,
              ),
            ),
          ]),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 66,
          child: FilledButton(
            onPressed:
                claimed || !done ? null : () => controller.claimQuest(questId),
            style: FilledButton.styleFrom(
                backgroundColor: MoodisleColors.green,
                padding: const EdgeInsets.symmetric(vertical: 6)),
            child: Text(claimed ? '已领取' : '领取',
                style: const TextStyle(fontSize: 11)),
          ),
        ),
      ]),
    );
  }
}

extension _FirstOrNullX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

/// 心晴周报弹窗：聚合数据 + 模板洞察，可复制分享。
void _showWeekly(BuildContext context) {
  final shell = context.findAncestorStateOfType<State>();
  void ignore(_) {}
  ignore(shell);
  // 通过路由拿 controller：GrowPage 由 main 传入 —— 这里用注册表获取。
  final controller = GrowPageRegistry.last!;
  final report = controller.buildWeeklyReport();
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: MoodisleColors.paper,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MoodisleRadii.xl)),
      title: const Text('心晴周报', textAlign: TextAlign.center),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        for (final l in report.lines)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(l,
                style: const TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.w700)),
          ),
        const SizedBox(height: 8),
        Text(report.headline,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 12.5, color: MoodisleColors.ink2, height: 1.6)),
      ]),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _weeklyShareText(report)));
            Navigator.pop(ctx);
          },
          child: const Text('复制分享'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          style: FilledButton.styleFrom(backgroundColor: MoodisleColors.orange),
          child: const Text('收好'),
        ),
      ],
    ),
  );
}

final String kNewline = String.fromCharCode(10);

String _weeklyShareText(WeeklyReport report) =>
    '【心晴周报】${report.lines.join(kNewline)}$kNewline${report.headline}';

/// 导入好友明信片码弹窗。
void _importCodeDialog(BuildContext context) {
  final edit = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: MoodisleColors.paper,
      title: const Text('导入好友明信片'),
      content: TextField(
        controller: edit,
        decoration: const InputDecoration(hintText: 'MDSL-XXXX…（粘贴好友的码）'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
        FilledButton(
          onPressed: () {
            final msg = GrowPageRegistry.last!.importPostcard(edit.text);
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg)));
          },
          style: FilledButton.styleFrom(backgroundColor: MoodisleColors.green),
          child: const Text('导入'),
        ),
      ],
    ),
  );
}

/// GrowPage 与对话框之间传递控制器的轻量注册表（单实例应用足够）。
class GrowPageRegistry {
  static GameController? last;
}

/// 季节/节日横幅卡（按真实月份切换色调文案）。
class _SeasonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final season = seasonOf(DateTime.now());
    final festival = festivalOf(DateTime.now());
    final tip = festival == null
        ? season.tip
        : '${season.tip}$kNewline${festival.name}：${festival.blurb}';
    return _Panel(
      title: '当季：${season.cn}',
      child: Text(tip,
          style: const TextStyle(
              fontSize: 11.5, color: MoodisleColors.ink2, height: 1.6)),
    );
  }
}
