/// 图鉴页：10 卡片 + 详情/培育弹层。
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../application/game_controller.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/pet.dart';
import '../../domain/config/game_config.dart';
import '../../shared/theme/tokens.dart';
import '../widgets/collectible_catalog.dart';
import '../widgets/game_icons.dart';
import '../widgets/pet_sprite.dart';

class DexPage extends StatefulWidget {
  final GameController controller;
  const DexPage({super.key, required this.controller});

  @override
  State<DexPage> createState() => _DexPageState();
}

class _DexPageState extends State<DexPage> {
  bool _showCollectibles = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final dew = widget.controller.state.items[ItemId.morningDew] ?? 0;
          return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: PaperPanel.decoration(),
                  child: Row(children: [
                    Image.asset('assets/ui/tabs/compendium.png',
                        width: 24, height: 24),
                    const SizedBox(width: 5),
                    Text(
                        _showCollectibles
                            ? '装扮与纪念品 · 20 件藏品'
                            : '伙伴图鉴 · 10 种心情天气',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: MoodisleColors.ink)),
                    if (!_showCollectibles) ...[
                      const Spacer(),
                      const ItemIcon(ItemId.morningDew, size: 18),
                      const SizedBox(width: 3),
                      Text('晨露 ×$dew',
                          style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2EA05F))),
                    ],
                  ]),
                ),
                const SizedBox(height: 10),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('伙伴')),
                    ButtonSegment(value: true, label: Text('装扮与纪念品')),
                  ],
                  selected: {_showCollectibles},
                  onSelectionChanged: (selection) =>
                      setState(() => _showCollectibles = selection.single),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) =>
                        states.contains(WidgetState.selected)
                            ? const Color(0xFFFFE5BA)
                            : MoodisleColors.paper),
                    foregroundColor:
                        const WidgetStatePropertyAll(MoodisleColors.ink),
                    side: const WidgetStatePropertyAll(
                        BorderSide(color: MoodisleColors.line)),
                  ),
                ),
                const SizedBox(height: 10),
                if (_showCollectibles)
                  CollectibleCatalog(controller: widget.controller)
                else
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.80,
                    children: [
                      for (final e in Emotion.values)
                        _DexCard(emotion: e, controller: widget.controller),
                    ],
                  ),
              ]);
        });
  }
}

class _DexCard extends StatelessWidget {
  final Emotion emotion;
  final GameController controller;
  const _DexCard({required this.emotion, required this.controller});

  @override
  Widget build(BuildContext context) {
    final rec = controller.state.pets[emotion];
    final owned = rec != null;
    final stage = owned ? rec.stage : PetStage.clear;
    return InkWell(
      onTap: () => _openDetail(context),
      borderRadius: BorderRadius.circular(MoodisleRadii.m),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: PaperPanel.decoration(),
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text('#${(emotion.index + 1).toString().padLeft(3, '0')}',
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: MoodisleColors.ink2)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) => Center(
                    child: PetSprite(
                      emotion: emotion,
                      stage: stage,
                      branch: rec?.branch,
                      size: constraints.biggest.shortestSide * 0.88,
                      wild: !owned,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(owned ? '${emotion.petCn} ${emotion.petEn}' : '？？？',
              style:
                  const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            decoration: BoxDecoration(
                color: Color(emotion.colorValue),
                borderRadius: BorderRadius.circular(99)),
            child: Text(emotion.emotionCn,
                style: const TextStyle(fontSize: 10, color: Colors.white)),
          ),
          const SizedBox(height: 4),
          Text(
            owned
                ? '${stageLabel(rec.stage, rec.branch)} · ${rec.count} 次'
                : '点击查看未发现形态',
            style: const TextStyle(fontSize: 10, color: MoodisleColors.ink2),
          ),
        ]),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _DexDetail(emotion: emotion, controller: controller),
    );
  }
}

String stageLabel(PetStage stage, Branch? branch) => switch (stage) {
      PetStage.clear => '晴态',
      PetStage.rainbow => '虹态',
      PetStage.awakened => branch == Branch.deepcurrent ? '觉醒·深流' : '觉醒·星宿',
    };

class _DexDetail extends StatefulWidget {
  final Emotion emotion;
  final GameController controller;
  const _DexDetail({required this.emotion, required this.controller});

  @override
  State<_DexDetail> createState() => _DexDetailState();
}

class _DexDetailState extends State<_DexDetail> {
  late PetStage _selectedStage;
  Branch? _selectedBranch;

  @override
  void initState() {
    super.initState();
    final rec = widget.controller.state.pets[widget.emotion];
    _selectedStage = rec?.stage ?? PetStage.clear;
    _selectedBranch = rec?.branch;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final rec = widget.controller.state.pets[widget.emotion];
          final dew = widget.controller.state.items[ItemId.morningDew] ?? 0;
          final forms =
              <({PetStage stage, Branch? branch, String label, bool found})>[
            (
              stage: PetStage.clear,
              branch: null,
              label: '晴态',
              found: rec != null
            ),
            (
              stage: PetStage.rainbow,
              branch: null,
              label: '虹态',
              found: rec != null && rec.stage.index >= PetStage.rainbow.index
            ),
            (
              stage: PetStage.awakened,
              branch: Branch.constellation,
              label: '觉醒·星宿',
              found: rec?.stage == PetStage.awakened &&
                  rec?.branch == Branch.constellation
            ),
            (
              stage: PetStage.awakened,
              branch: Branch.deepcurrent,
              label: '觉醒·深流',
              found: rec?.stage == PetStage.awakened &&
                  rec?.branch == Branch.deepcurrent
            ),
          ];
          final selected = forms.firstWhere((form) =>
              form.stage == _selectedStage && form.branch == _selectedBranch);
          final maxed = rec?.stage == PetStage.awakened;
          final nextLabel = rec?.stage == PetStage.clear ? '虹态' : '觉醒态';
          final need = rec?.stage == PetStage.clear ? 5 : 10;
          final viewport = MediaQuery.sizeOf(context);
          final dialogWidth = math.max(0, math.min(740, viewport.width - 32));
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            backgroundColor: MoodisleColors.paper,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MoodisleRadii.xl)),
            child: SizedBox(
              width: dialogWidth.toDouble(),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: viewport.height * 0.82),
                child: LayoutBuilder(builder: (context, constraints) {
                  final topHeight = math
                      .max(128.0,
                          math.min(340.0, (constraints.maxWidth - 10) / 2))
                      .toDouble();
                  final heroSize = topHeight * 0.72;
                  final hero = Container(
                    height: topHeight,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F2E7),
                      borderRadius: BorderRadius.circular(MoodisleRadii.l),
                      border: Border.all(color: const Color(0xFFD1DFC8)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(selected.label,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w800)),
                        Flexible(
                          child: PetSprite(
                            emotion: widget.emotion,
                            stage: selected.stage,
                            branch: selected.branch,
                            size: heroSize,
                            wild: !selected.found,
                          ),
                        ),
                        Text(selected.found ? '已发现' : '未发现 · 形态预览',
                            style: const TextStyle(
                                fontSize: 10, color: MoodisleColors.ink2)),
                      ],
                    ),
                  );
                  final formGrid = SizedBox(
                    height: topHeight,
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1,
                      children: [
                        for (final form in forms)
                          _DexFormCard(
                            emotion: widget.emotion,
                            stage: form.stage,
                            branch: form.branch,
                            label: form.label,
                            found: form.found,
                            selected: form.stage == _selectedStage &&
                                form.branch == _selectedBranch,
                            onTap: () => setState(() {
                              _selectedStage = form.stage;
                              _selectedBranch = form.branch;
                            }),
                          ),
                      ],
                    ),
                  );
                  final info = Container(
                    constraints: const BoxConstraints(minHeight: 142),
                    padding: const EdgeInsets.all(10),
                    decoration: _detailPanelDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(
                              rec == null
                                  ? '未发现的天气精灵'
                                  : '${widget.emotion.petCn} ${widget.emotion.petEn}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              tooltip: '关闭',
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close_rounded, size: 19),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        Text(
                            '${widget.emotion.emotionCn} · ${widget.emotion.weatherCn}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11, color: MoodisleColors.ink2)),
                        if (rec != null) ...[
                          const SizedBox(height: 5),
                          Text(
                              '${stageLabel(rec.stage, rec.branch)} · ${rec.count} 次收服',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11, color: MoodisleColors.ink2)),
                          Text(
                              '羁绊 Lv.${rec.bond.level} · 专注 ${rec.bond.minutes} 分钟',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10.5, color: MoodisleColors.ink2)),
                        ] else ...[
                          const SizedBox(height: 5),
                          const Text('完成对应待办，发现它的第一种形态。',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10.5, color: MoodisleColors.ink2)),
                        ],
                      ],
                    ),
                  );
                  final cultivation = Container(
                    constraints: const BoxConstraints(minHeight: 142),
                    padding: const EdgeInsets.all(10),
                    decoration: _detailPanelDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          ItemIcon(ItemId.morningDew, size: 18),
                          SizedBox(width: 5),
                          Text('形态培育',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w900)),
                        ]),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              rec == null
                                  ? '发现伙伴后即可培育'
                                  : maxed
                                      ? '当前路线的形态已觉醒'
                                      : '距「$nextLabel」 ${rec.count}/${need.clamp(0, 10)} 次',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 10.5, color: MoodisleColors.ink2),
                            ),
                          ),
                        ),
                        _CultivateButton(
                          label: rec == null
                              ? '发现后开启'
                              : maxed
                                  ? '已达形态终点'
                                  : dew > 0
                                      ? '培育 · 消耗 1 晨露'
                                      : '晨露不足',
                          enabled: rec != null && !maxed && dew > 0,
                          onTap: () =>
                              widget.controller.cultivate(widget.emotion),
                        ),
                      ],
                    ),
                  );
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Expanded(child: hero),
                          const SizedBox(width: 10),
                          Expanded(child: formGrid),
                        ]),
                        const SizedBox(height: 10),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: info),
                              const SizedBox(width: 10),
                              Expanded(child: cultivation),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        });
  }
}

BoxDecoration _detailPanelDecoration() => BoxDecoration(
      color: const Color(0xFFFFFDF7),
      borderRadius: BorderRadius.circular(MoodisleRadii.m),
      border: Border.all(color: MoodisleColors.line),
    );

class _CultivateButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _CultivateButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: radius,
        child: Ink(
          height: 40,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFFFD27F) : const Color(0xFFECE7DC),
            borderRadius: radius,
            border: Border.all(
                color: enabled ? MoodisleColors.ink : MoodisleColors.line),
            boxShadow: enabled
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
              if (enabled) ...[
                const ItemIcon(ItemId.morningDew, size: 17),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: enabled ? MoodisleColors.ink : MoodisleColors.ink2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DexFormCard extends StatelessWidget {
  final Emotion emotion;
  final PetStage stage;
  final Branch? branch;
  final String label;
  final bool found;
  final bool selected;
  final VoidCallback onTap;
  const _DexFormCard({
    required this.emotion,
    required this.stage,
    required this.branch,
    required this.label,
    required this.found,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFE5BA) : const Color(0xFFFFFDF7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? MoodisleColors.orange : MoodisleColors.line,
              width: selected ? 2 : 1),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => PetSprite(
                emotion: emotion,
                stage: stage,
                branch: branch,
                size: math
                    .min(90.0, constraints.biggest.shortestSide * 0.78)
                    .toDouble(),
                wild: !found,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(found ? label : '未发现',
              style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: found ? MoodisleColors.ink : MoodisleColors.ink2)),
        ]),
      ),
    );
  }
}
