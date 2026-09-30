/// 云游卡（docs/02 §7）：派遣/倒计时/迎接归来；纯外观纪念品收藏。
library;

import 'package:flutter/material.dart';

import '../../application/game_controller.dart';
import '../../domain/config/roam_config.dart';
import '../../domain/entities/emotion.dart';
import '../../domain/entities/pet.dart';
import '../../shared/audio/moodisle_audio_scope.dart';
import '../../shared/audio/moodisle_audio_service.dart';
import '../../shared/theme/tokens.dart';
import 'game_icons.dart';
import 'pet_sprite.dart';

class RoamCard extends StatelessWidget {
  final GameController controller;
  const RoamCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final s = controller.state;
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: PaperPanel.decoration(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                UiStickerIcon('sections/roam',
                    size: 24, fallback: Icons.flight_takeoff_rounded),
                SizedBox(width: 5),
                Text('伙伴云游',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: MoodisleColors.ink)),
              ]),
              const SizedBox(height: 4),
              const Text('派伙伴独自远行，离线也会推进；带回纯外观的天气纪念品。不消耗行动力与每日次数。',
                  style: TextStyle(
                      fontSize: 11.5, color: MoodisleColors.ink2, height: 1.5)),
              const SizedBox(height: 10),
              for (var i = 0; i < s.roam.slots.length; i++)
                _RoamSlotRow(controller: controller, index: i),
              if (s.roam.slots.isEmpty) _RoamDispatch(controller: controller),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final e in s.roam.souvenirs.entries)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4D6),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: MoodisleColors.line),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SouvenirIcon(e.key, size: 16),
                        const SizedBox(width: 3),
                        Text('${kSouvenirs[e.key]?.cn ?? e.key} ×${e.value}',
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                ],
              ),
              if (s.roam.souvenirs.isEmpty)
                const Text('纪念品收藏还是空的～',
                    style: TextStyle(fontSize: 11, color: MoodisleColors.ink2)),
            ]),
          );
        });
  }
}

class _RoamSlotRow extends StatelessWidget {
  final GameController controller;
  final int index;
  const _RoamSlotRow({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final slot = controller.state.roam.slots[index];
    final route = routeById(slot.routeId);
    final due = slot.isDue(DateTime.now());
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 520;
      final details = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(route.cn,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
          Text(route.desc,
              style: const TextStyle(fontSize: 11, color: MoodisleColors.ink2)),
          const SizedBox(height: 5),
          Text(due ? '已抵达，可迎接归来' : '伙伴正在云游中…',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: due ? const Color(0xFF358C59) : MoodisleColors.ink2)),
          const SizedBox(height: 7),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: due
                  ? () {
                      controller.claimRoam(index);
                      MoodisleAudioScope.maybeOf(context)
                          ?.play([MoodisleSound.loot]);
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: MoodisleColors.green,
                foregroundColor: MoodisleColors.ink,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              ),
              child: const Text('迎接伙伴'),
            ),
          ),
        ],
      );
      return Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF7),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
              color: due ? MoodisleColors.green : const Color(0xFFEFE1C2)),
        ),
        child: wide
            ? Row(children: [
                Expanded(flex: 5, child: _RouteArtwork(routeId: route.id)),
                const SizedBox(width: 13),
                Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PetSprite(
                            emotion: slot.pet, stage: PetStage.clear, size: 58),
                        const SizedBox(width: 9),
                        Expanded(child: details),
                      ],
                    )),
              ])
            : Column(children: [
                _RouteArtwork(routeId: route.id, height: 150),
                const SizedBox(height: 8),
                Row(children: [
                  PetSprite(emotion: slot.pet, stage: PetStage.clear, size: 52),
                  const SizedBox(width: 8),
                  Expanded(child: details),
                ]),
              ]),
      );
    });
  }
}

class _RoamDispatch extends StatelessWidget {
  final GameController controller;
  const _RoamDispatch({required this.controller});

  @override
  Widget build(BuildContext context) {
    final owned = controller.state.pets.keys
        .where((e) => !controller.state.roam.isRoaming(e))
        .toList();
    if (owned.isEmpty) {
      return const Text('没有可云游的伙伴（都在远行中或未收服）',
          style: TextStyle(fontSize: 11, color: MoodisleColors.ink2));
    }
    final pet = (controller.state.companion != null &&
            owned.contains(controller.state.companion))
        ? controller.state.companion!
        : owned.first;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('选择路线并出发',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF5A3E22))),
      const SizedBox(height: 6),
      for (final r in kRoamRoutes)
        LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth >= 520;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(r.cn,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w900)),
              Text('${_fmt(r.duration)} · ${r.desc}',
                  style: const TextStyle(
                      fontSize: 11, color: MoodisleColors.ink2)),
            ],
          );
          final dispatch = FilledButton(
            onPressed: () => controller.dispatchRoam(pet, r.id),
            style: FilledButton.styleFrom(
                backgroundColor: MoodisleColors.orange,
                foregroundColor: MoodisleColors.paper,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9)),
            child: Text('${pet.petCn} 出发'),
          );
          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF7),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFFEFE1C2)),
            ),
            child: wide
                ? Row(children: [
                    Expanded(flex: 5, child: _RouteArtwork(routeId: r.id)),
                    const SizedBox(width: 13),
                    Expanded(
                      flex: 4,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(children: [
                              PetSprite(
                                  emotion: pet,
                                  stage: PetStage.clear,
                                  size: 56),
                              const SizedBox(width: 8),
                              Expanded(child: details),
                            ]),
                            const SizedBox(height: 8),
                            dispatch,
                          ]),
                    ),
                  ])
                : Column(children: [
                    _RouteArtwork(routeId: r.id, height: 150),
                    const SizedBox(height: 8),
                    Row(children: [
                      PetSprite(emotion: pet, stage: PetStage.clear, size: 50),
                      const SizedBox(width: 8),
                      Expanded(child: details),
                      const SizedBox(width: 6),
                      dispatch,
                    ]),
                  ]),
          );
        }),
    ]);
  }

  String _fmt(Duration d) {
    if (d.inHours >= 1) return '约 ${d.inHours} 小时';
    return '约 ${d.inMinutes} 分钟';
  }
}

class _RouteArtwork extends StatelessWidget {
  final String routeId;
  final double height;
  const _RouteArtwork({required this.routeId, this.height = 132});

  @override
  Widget build(BuildContext context) {
    final file = switch (routeId) {
      'monsoon' => 'monsoon_short',
      'tradeWind' => 'trade_wind_halfday',
      'polarNight' => 'polar_long',
      _ => 'monsoon_short',
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.asset(
          'assets/travel/$file.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFE2F0EA),
            alignment: Alignment.center,
            child: const Icon(Icons.explore_rounded,
                color: MoodisleColors.wood, size: 34),
          ),
        ),
      ),
    );
  }
}
