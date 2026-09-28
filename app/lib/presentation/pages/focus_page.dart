/// 专注页：陪伴专注（选伙伴 → 档位 → 倒计时 → 完成结算）。
/// 中断宽限（张望 120s）由 App 生命周期桥接（见 app_shell）。
library;

import 'package:flutter/material.dart';

import '../../application/game_controller.dart';
import '../../domain/config/game_config.dart';
import '../../domain/entities/emotion.dart';
import '../../shared/theme/tokens.dart';
import '../widgets/pet_sprite.dart';
import '../widgets/roam_card.dart';

class FocusPage extends StatelessWidget {
  final GameController controller;
  const FocusPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final s = controller.state;
          final session = s.session;
          if (session != null) return _FocusingView(controller: controller);
          final owned = s.pets.keys.where((e) => s.pets[e] != null).toList();
          return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: PaperPanel.decoration(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Icon(Icons.timer_rounded,
                              color: MoodisleColors.orange, size: 20),
                          SizedBox(width: 5),
                          Text('陪伴专注',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: MoodisleColors.ink)),
                        ]),
                        const SizedBox(height: 4),
                        const Text('选一位伙伴陪你专注。中途离开它只会张望等你（2 分钟内回来无缝继续），超时也不惩罚。',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: MoodisleColors.ink2,
                                height: 1.5)),
                        const SizedBox(height: 12),
                        const Text('选择陪伴精灵',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        if (owned.isEmpty)
                          const Text('还没有伙伴～先去「待办」完成一件真实的事吧。',
                              style: TextStyle(
                                  fontSize: 12, color: MoodisleColors.ink2))
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final e in owned)
                                _CompanionChip(
                                    controller: controller, emotion: e),
                            ],
                          ),
                      ]),
                ),
                if (owned.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _FocusPlanPanel(
                    controller: controller,
                    emotion: s.companion != null && owned.contains(s.companion)
                        ? s.companion
                        : null,
                  ),
                ],
                const SizedBox(height: 10),
                RoamCard(controller: controller),
              ]);
        });
  }
}

class _CompanionChip extends StatelessWidget {
  final GameController controller;
  final Emotion emotion;
  const _CompanionChip({required this.controller, required this.emotion});

  @override
  Widget build(BuildContext context) {
    final e = emotion;
    final selected = controller.state.companion == e;
    return InkWell(
      onTap: () => controller.setCompanion(e),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 82,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? MoodisleColors.orange : const Color(0xFFEFE1C2),
              width: selected ? 2 : 1),
        ),
        child: Column(children: [
          PetSprite(
              emotion: e,
              stage: controller.state.pets[e]!.stage,
              branch: controller.state.pets[e]!.branch,
              size: 40),
          Text(e.petCn,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
          Text('羁绊 Lv.${controller.state.pets[e]!.bond.level}',
              style: const TextStyle(fontSize: 9, color: MoodisleColors.ink2)),
          if (selected) ...[
            const SizedBox(height: 3),
            const Icon(Icons.check_circle,
                color: MoodisleColors.green, size: 16),
          ],
        ]),
      ),
    );
  }
}

class _FocusPlanPanel extends StatefulWidget {
  final GameController controller;
  final Emotion? emotion;
  const _FocusPlanPanel({required this.controller, required this.emotion});

  @override
  State<_FocusPlanPanel> createState() => _FocusPlanPanelState();
}

class _FocusPlanPanelState extends State<_FocusPlanPanel> {
  int _plan = 25;

  @override
  Widget build(BuildContext context) {
    final canStart = widget.emotion != null;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: PaperPanel.decoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('选择专注时长',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Row(children: [
          for (final minutes in GameConfig.focusPlans)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () => setState(() => _plan = minutes),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _plan == minutes
                          ? const Color(0xFFFFE5BA)
                          : const Color(0xFFFFFDF7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _plan == minutes
                            ? MoodisleColors.orange
                            : MoodisleColors.line,
                        width: _plan == minutes ? 1.5 : 1,
                      ),
                    ),
                    child: Column(children: [
                      Text('$minutes',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: _plan == minutes
                                  ? MoodisleColors.orange
                                  : MoodisleColors.ink)),
                      const Text('分钟',
                          style: TextStyle(
                              fontSize: 10, color: MoodisleColors.ink2)),
                    ]),
                  ),
                ),
              ),
            ),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MoodisleRadii.m),
              boxShadow: const [
                BoxShadow(
                  color: MoodisleColors.shadow,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: FilledButton.icon(
              onPressed: !canStart
                  ? null
                  : () => widget.controller.startFocus(widget.emotion!, _plan),
              icon: Image.asset('assets/ui/actions/start.png',
                  width: 22, height: 22),
              label: Text(canStart ? '开始 $_plan 分钟专注' : '先选择一位伙伴'),
              style: FilledButton.styleFrom(
                backgroundColor: MoodisleColors.orange,
                foregroundColor: MoodisleColors.paper,
                disabledBackgroundColor: const Color(0xFFD9D0BF),
                disabledForegroundColor: MoodisleColors.ink2,
                side: const BorderSide(color: MoodisleColors.ink, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MoodisleRadii.m)),
                minimumSize: const Size.fromHeight(48),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _FocusingView extends StatelessWidget {
  final GameController controller;
  const _FocusingView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final s = controller.state;
          final session = s.session;
          if (session == null) {
            // 结算完成：展示结果
            final done = controller.pendingFocusDone;
            return Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: PaperPanel.decoration(),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset('assets/items/icons/star_badge.png',
                      width: 44, height: 44),
                  const Text('专注完成！',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  if (done != null) ...[
                    const SizedBox(height: 6),
                    Text(
                        '${done.pet.petCn} 羁绊 +${done.bondGain} 分钟 · '
                        '星屑 +${done.stardust}'
                        '${done.bondLevelUpTo != null ? ' · 羁绊升到 Lv.${done.bondLevelUpTo}' : ''}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: () {
                      controller.clearFocusDone();
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: MoodisleColors.orange),
                    child: const Text('真棒，继续前行'),
                  ),
                ]),
              ),
            );
          }
          final remain = session.planMin - session.doneMin;
          final glancing = session.phase == 'glancing';
          return Center(
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(22),
              decoration: PaperPanel.decoration(),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                PetSprite(
                    emotion: session.pet,
                    stage: s.pets[session.pet]!.stage,
                    branch: s.pets[session.pet]!.branch,
                    size: 88),
                const SizedBox(height: 8),
                Text(
                    glancing
                        ? 'It looking around... 它在原地张望等你（2 分钟内回来无缝继续）'
                        : '${session.pet.petCn} 正安静地陪着你',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, color: MoodisleColors.ink2)),
                const SizedBox(height: 10),
                Text('${remain.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: MoodisleColors.orange)),
                Text('已专注 ${session.doneMin} / ${session.planMin} 分钟',
                    style: const TextStyle(
                        fontSize: 11.5, color: MoodisleColors.ink2)),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () => controller.cancelFocus(),
                  child:
                      const Text('放弃本次（零惩罚）', style: TextStyle(fontSize: 12)),
                ),
              ]),
            ),
          );
        });
  }
}
