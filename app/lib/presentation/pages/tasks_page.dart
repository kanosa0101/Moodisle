/// 待办页：录入（情绪 + 难度）→ 列表（置顶优先）→ 完成 → 收服演出弹层。
library;

import 'package:flutter/material.dart';

import '../../application/game_controller.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/pet.dart';
import '../../domain/entities/task.dart';
import '../../domain/config/weather_cycle.dart';
import '../../domain/game_core.dart';
import '../../shared/theme/tokens.dart';
import '../widgets/game_icons.dart';
import '../widgets/pet_sprite.dart';

class TasksPage extends StatelessWidget {
  final GameController controller;
  final Key? addRowKey;
  final Key? typeChipsKey;
  final Key? taskListKey;
  final Key? chainKey;
  const TasksPage(
      {super.key,
      required this.controller,
      this.addRowKey,
      this.typeChipsKey,
      this.taskListKey,
      this.chainKey});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _AddPanel(
            controller: controller,
            panelKey: addRowKey,
            chipsKey: typeChipsKey),
        const SizedBox(height: 4),
        _TaskListPanel(
            controller: controller, panelKey: taskListKey, chainKey: chainKey),
      ],
    );
  }
}

class _AddPanel extends StatefulWidget {
  final GameController controller;
  final Key? panelKey;
  final Key? chipsKey;
  const _AddPanel({required this.controller, this.panelKey, this.chipsKey});

  @override
  State<_AddPanel> createState() => _AddPanelState();
}

class _AddPanelState extends State<_AddPanel> {
  final _input = TextEditingController();
  Emotion _emotion = Emotion.sloth;
  int _difficulty = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.panelKey,
      padding: const EdgeInsets.all(14),
      decoration: PaperPanel.decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.edit_note_rounded,
                color: MoodisleColors.orange, size: 20),
            SizedBox(width: 5),
            Text('录入今天的待办',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: MoodisleColors.ink)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _input,
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: '例如：写完周报、跑步30分钟…',
                  isDense: true,
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFFFFDF7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MoodisleRadii.s),
                    borderSide: const BorderSide(color: MoodisleColors.line),
                  ),
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: _add,
              style: FilledButton.styleFrom(
                  backgroundColor: MoodisleColors.orange),
              child: const Text('召唤'),
            ),
          ]),
          const SizedBox(height: 10),
          Wrap(
            key: widget.chipsKey,
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final e in Emotion.values)
                _EmotionChip(
                  emotion: e,
                  selected: e == _emotion,
                  onTap: () => setState(() => _emotion = e),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('任务难度',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: MoodisleColors.ink2)),
          const SizedBox(height: 5),
          Row(children: [
            for (final (val, name, file) in const [
              (1, '轻松', 'easy'),
              (2, '普通', 'steady'),
              (3, '挑战', 'challenge'),
            ])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _difficulty = val),
                      borderRadius: BorderRadius.circular(13),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          color: _difficulty == val
                              ? MoodisleColors.orange
                              : MoodisleColors.paper,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: _difficulty == val
                                ? MoodisleColors.ink
                                : MoodisleColors.line,
                            width: _difficulty == val ? 1.5 : 1,
                          ),
                          boxShadow: _difficulty == val
                              ? const [
                                  BoxShadow(
                                    color: MoodisleColors.shadow,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : const [],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/ui/difficulty/$file.png',
                                width: 25, height: 25),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _difficulty == val
                                      ? Colors.white
                                      : MoodisleColors.ink2,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 6),
          const Text(
            '选择任务对应的情绪属性，系统会召唤一只对应的「天气精灵」。完成现实中的事即可安抚收服它。',
            style: TextStyle(
                fontSize: 11, color: MoodisleColors.ink2, height: 1.5),
          ),
        ],
      ),
    );
  }

  void _add() {
    widget.controller.addTask(_input.text, _emotion, _difficulty);
    _input.clear();
    FocusScope.of(context).unfocus();
  }
}

class _EmotionChip extends StatelessWidget {
  final Emotion emotion;
  final bool selected;
  final VoidCallback onTap;
  const _EmotionChip(
      {required this.emotion, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? Color(emotion.colorValue) : const Color(0xFFFFFDF7),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
              color: selected ? Colors.transparent : MoodisleColors.line),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
                color: Color(emotion.colorValue), shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(emotion.emotionCn,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : MoodisleColors.ink2)),
        ]),
      ),
    );
  }
}

class _TaskListPanel extends StatefulWidget {
  final GameController controller;
  final Key? panelKey;
  final Key? chainKey;
  const _TaskListPanel(
      {required this.controller, this.panelKey, this.chainKey});

  @override
  State<_TaskListPanel> createState() => _TaskListPanelState();
}

class _TaskListPanelState extends State<_TaskListPanel> {
  bool _showDone = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final pend2 = controller.state.tasks
              .where((t) => t.status != TaskStatus.done)
              .toList()
            ..sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));
          final doneList = controller.state.tasks
              .where((t) => t.status == TaskStatus.done)
              .toList()
            ..sort((a, b) => b.difficulty - a.difficulty);
          final done = doneList.length;
          return Container(
            key: widget.panelKey,
            padding: const EdgeInsets.all(14),
            decoration: PaperPanel.decoration(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // 天气共鸣横幅（对齐原版 chainBanner）
              Container(
                key: widget.chainKey,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: controller.state.resonance.len >= 2
                          ? MoodisleColors.orange
                          : const Color(0xFFEFE1C2)),
                  gradient: controller.state.resonance.len >= 2
                      ? const LinearGradient(colors: [
                          Color(0xFFFFE9B0),
                          Color(0xFF9AF0BD),
                        ])
                      : null,
                  color: controller.state.resonance.len >= 2
                      ? null
                      : const Color(0xFFFFFDF7),
                ),
                child: Text(
                  controller.state.resonance.len >= 2
                      ? '天气共鸣链 ×${controller.state.resonance.len} 进行中 · 下一环：${_nextOf(controller.state.resonance.last)}'
                      : '天气共鸣：按循环（雷→雨→雾→霭→云→涡→风→霜→星→霞）连续完成同链待办，链越长奖励越多（历史最长 ×${controller.state.resonance.best}）',
                  style: const TextStyle(
                      fontSize: 11.5, height: 1.6, color: Color(0xFF5A3E22)),
                ),
              ),
              const Row(children: [
                Icon(Icons.cloud_rounded,
                    color: MoodisleColors.green, size: 20),
                SizedBox(width: 5),
                Text('心岛上的天气精灵',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: MoodisleColors.ink)),
              ]),
              const SizedBox(height: 10),
              if (pend2.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                      child: Text('还没有待办～录入真实任务，召唤第一只精灵吧。',
                          style: TextStyle(
                              fontSize: 12.5, color: MoodisleColors.ink2))),
                )
              else
                for (final t in pend2)
                  _TaskRow(task: t, controller: controller),
              if (done > 0) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InkWell(
                    onTap: () => setState(() => _showDone = !_showDone),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: MoodisleColors.line),
                        color: const Color(0xFFFBF3E0),
                      ),
                      child: Text(
                          '✓ 已安抚 $done 只 · ${_showDone ? '点击收起' : '点击展开'}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: MoodisleColors.ink2)),
                    ),
                  ),
                ),
                if (_showDone)
                  for (final t in doneList)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFDF7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFEFE1C2)),
                      ),
                      child: Row(children: [
                        Opacity(
                          opacity: 0.55,
                          child: PetSprite(
                              emotion: t.emotion,
                              stage: controller.state.pets[t.emotion]?.stage ??
                                  PetStage.clear,
                              branch: controller.state.pets[t.emotion]?.branch,
                              size: 30),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(t.text,
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  decoration: TextDecoration.lineThrough,
                                  color: MoodisleColors.ink2)),
                        ),
                        IconButton(
                          onPressed: () => controller.deleteTask(t.id),
                          icon: const Icon(Icons.delete_outline,
                              size: 17, color: MoodisleColors.ink2),
                        ),
                      ]),
                    ),
              ],
            ]),
          );
        });
  }
}

class _TaskRow extends StatelessWidget {
  final Task task;
  final GameController controller;
  const _TaskRow({required this.task, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                task.pinned ? MoodisleColors.orange : const Color(0xFFEFE1C2),
            width: task.pinned ? 1.5 : 1),
      ),
      child: Row(children: [
        PetSprite(emotion: task.emotion, size: 42, wild: true),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(task.text,
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(
                '${task.emotion.emotionCn} · ${task.emotion.petCn} · '
                '难度·${switch (task.difficulty) {
                  1 => '轻松',
                  3 => '挑战',
                  _ => '普通'
                }}',
                style: const TextStyle(
                    fontSize: 10.5, color: MoodisleColors.ink2)),
          ]),
        ),
        IconButton(
          tooltip: '标为重点',
          onPressed: () => controller.togglePin(task.id),
          icon: Icon(task.pinned ? Icons.star : Icons.star_border,
              size: 19,
              color: task.pinned ? MoodisleColors.orange : MoodisleColors.ink2),
        ),
        IconButton(
          tooltip: '完成并收服',
          onPressed: () => _completeFlow(context),
          icon: const Icon(Icons.check_circle,
              size: 22, color: MoodisleColors.green),
        ),
        IconButton(
          tooltip: '删除',
          onPressed: () => controller.deleteTask(task.id),
          icon: const Icon(Icons.delete_outline,
              size: 19, color: MoodisleColors.ink2),
        ),
      ]),
    );
  }

  /// 完成流程：先选复盘（docs/02 §1.2）→ 收服管线 → 演出弹层。
  void _completeFlow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MoodisleColors.paper,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(MoodisleRadii.xl))),
      builder: (sheetCtx) => _FeedbackSheet(
        onPick: (fb) {
          // ignore: avoid_print
          Navigator.of(sheetCtx).pop();
          controller.completeTask(task.id, fb);
          // ignore: avoid_print
          _showCapture(context);
        },
      ),
    );
  }

  void _showCapture(BuildContext context) {
    // ignore: avoid_print
    if (controller.pendingCapture == null) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CaptureDialog(controller: controller),
    );
  }
}

/// 完成复盘四选一（可跳过）。
class _FeedbackSheet extends StatelessWidget {
  final void Function(FeedbackKind?) onPick;
  const _FeedbackSheet({required this.onPick});

  @override
  Widget build(BuildContext context) {
    Widget option(Widget icon, String label, FeedbackKind? fb) => Padding(
          padding: const EdgeInsets.only(right: 6),
          child: OutlinedButton(
            key: fb == null ? const ValueKey('fb_skip') : ValueKey(fb),
            onPressed: () => onPick(fb),
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              icon,
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 12.5)),
            ]),
          ),
        );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('现实中做完啦？记一下感受（1 tap）',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5)),
          const SizedBox(height: 10),
          Wrap(children: [
            option(const UiStickerIcon('feedback/relief', size: 18), '如释重负',
                FeedbackKind.relieved),
            option(const UiStickerIcon('feedback/calm', size: 18), '平静',
                FeedbackKind.calm),
            option(const UiStickerIcon('feedback/proud', size: 18), '成就感',
                FeedbackKind.proud),
            option(const UiStickerIcon('feedback/easier', size: 18), '没那么难',
                FeedbackKind.easier),
            option(
                const Icon(Icons.skip_next_rounded,
                    size: 16, color: MoodisleColors.ink2),
                '跳过',
                null),
          ]),
        ]),
      ),
    );
  }
}

/// 收服 / 共鸣 / 升级 演出弹层（消费 controller.pendingCapture）。
class CaptureDialog extends StatelessWidget {
  final GameController controller;
  const CaptureDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final cap = controller.pendingCapture!;
    final rec = controller.state.pets[cap.emotion]!;
    final lines = <String>[];
    if (cap.evolved) {
      lines.add(cap.newStage == PetStage.awakened ? '它觉醒了全新形态！' : '进化到下一形态！');
    }
    if (cap.chainLinked && cap.chainLen >= 2) {
      lines.add('天气共鸣链 ×${cap.chainLen}！经验与放晴加成生效。');
    }
    if (cap.keeperLevelUp) {
      lines.add('看岛人升级到 Lv.${controller.state.keeper.level}！');
    }
    return Dialog(
      backgroundColor: MoodisleColors.paper,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MoodisleRadii.xl)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(cap.emotion.colorValue).withValues(alpha: 0.15),
            ),
            child: PetSprite(
              emotion: cap.emotion,
              stage: cap.newStage,
              branch: rec.branch,
              size: 96,
            ),
          ),
          const SizedBox(height: 10),
          Text(cap.evolved ? '进化成功！' : '收服成功！',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text('${cap.emotion.petCn} ${cap.emotion.petEn} 平静下来，成为你的伙伴。',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12.5, color: MoodisleColors.ink2, height: 1.5)),
          for (final l in lines)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(l,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w700)),
            ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.clearCapture();
            },
            style:
                FilledButton.styleFrom(backgroundColor: MoodisleColors.orange),
            child: const Text('收下伙伴'),
          ),
        ]),
      ),
    );
  }
}

String _nextOf(Emotion? e) => e == null ? '雷' : nextInCycle(e).emotionCn;
