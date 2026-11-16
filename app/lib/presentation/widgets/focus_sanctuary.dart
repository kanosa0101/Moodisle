import 'package:flutter/material.dart';

import '../../shared/theme/tokens.dart';

/// 复用心屿场景与伙伴立绘，不引入独立的平台页面或新美术资源。
class FocusSanctuary extends StatelessWidget {
  final double progress;
  final bool paused;
  final Widget companion;
  const FocusSanctuary(
      {super.key,
      required this.progress,
      required this.paused,
      required this.companion});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
            height: 190,
            child: Stack(fit: StackFit.expand, children: [
              Image.asset('assets/island/map_spring_day.png',
                  fit: BoxFit.cover,
                  color: const Color(0x99FFFFFF),
                  colorBlendMode: BlendMode.screen),
              const DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x00FFFAF0), Color(0xEEFFFAF0)]))),
              Center(
                  child: SizedBox(
                width: 136,
                height: 136,
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xDFFFFFF7))),
                  SizedBox.expand(
                      child: TweenAnimationBuilder<double>(
                    tween: Tween(end: progress.clamp(0.0, 1.0)),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, _) => CircularProgressIndicator(
                      value: value,
                      strokeWidth: 5,
                      color:
                          paused ? MoodisleColors.ink2 : MoodisleColors.green,
                      backgroundColor: MoodisleColors.line,
                      semanticsLabel: '专注进度',
                      semanticsValue: '${(value * 100).round()}%',
                    ),
                  )),
                  companion,
                ]),
              )),
              Positioned(
                  left: 12,
                  top: 10,
                  child: Text(paused ? '暂时休息' : '心屿 · 安静陪伴',
                      style: const TextStyle(
                          color: MoodisleColors.ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w800))),
            ])),
      );
}
