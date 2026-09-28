/// 新手引导（对齐原版 coach.js 的聚光灯分步教学）：
/// 全屏遮罩 + 目标元素抠洞 + 步骤卡片；部分步骤等待玩家真实操作后放行。
library;

import 'dart:math' show max;

import 'package:flutter/material.dart';

import '../../shared/theme/tokens.dart';

/// 引导步骤：target 为目标元素的 GlobalKey；wait 标记需要真实操作的等待。
class CoachStep {
  final GlobalKey target;
  final String text;
  final String tab; // 进入该步前切换到的 Tab（island/tasks/dex/maze）
  final String? wait; // 'add' | 'capture'
  const CoachStep(this.target, this.text, {this.tab = '', this.wait});
}

/// 聚光灯遮罩：目标矩形外压暗，内抠圆角洞；提示卡片自动置于洞上/下方。
class CoachOverlay extends StatelessWidget {
  final Rect? hole;
  final int stepIndex;
  final int total;
  final String text;
  final bool waiting;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const CoachOverlay({
    super.key,
    required this.hole,
    required this.stepIndex,
    required this.total,
    required this.text,
    required this.waiting,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _SpotlightPainter(hole: hole)),
            ),
          ),
          ..._barriers(size),
          Positioned.fill(
            child: Stack(children: [_tipCard(context, size)]),
          ),
        ]);
      },
    );
  }

  List<Widget> _barriers(Size size) {
    final target = waiting ? hole : null;
    if (target == null) {
      return [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onNext,
          ),
        ),
      ];
    }
    final left = target.left.clamp(0.0, size.width).toDouble();
    final top = target.top.clamp(0.0, size.height).toDouble();
    final right = target.right.clamp(0.0, size.width).toDouble();
    final bottom = target.bottom.clamp(0.0, size.height).toDouble();
    return [
      if (top > 0)
        Positioned(
            left: 0,
            top: 0,
            right: 0,
            height: top,
            child: const _CoachBarrier()),
      if (bottom < size.height)
        Positioned(
            left: 0,
            top: bottom,
            right: 0,
            bottom: 0,
            child: const _CoachBarrier()),
      if (left > 0)
        Positioned(
            left: 0,
            top: top,
            width: left,
            height: bottom - top,
            child: const _CoachBarrier()),
      if (right < size.width)
        Positioned(
            left: right,
            top: top,
            right: 0,
            height: bottom - top,
            child: const _CoachBarrier()),
    ];
  }

  Widget _tipCard(BuildContext context, Size screen) {
    final tipWidth = (screen.width - 24).clamp(0.0, 300.0).toDouble();
    final card = Container(
      key: const ValueKey('coach_tip_card'),
      width: tipWidth,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MoodisleColors.paper,
        border: Border.all(color: MoodisleColors.line, width: 2),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x47000000), blurRadius: 22, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('第 ${stepIndex + 1} / $total 步',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: MoodisleColors.orange)),
            const SizedBox(height: 4),
            Text.rich(
              _coachText(text),
              style: const TextStyle(
                  fontSize: 13.5, height: 1.6, color: MoodisleColors.ink),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(
                onTap: onSkip,
                child: const Text('跳过引导',
                    style: TextStyle(
                        fontSize: 12,
                        color: MoodisleColors.ink2,
                        decoration: TextDecoration.underline)),
              ),
              if (!waiting)
                FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                      backgroundColor: MoodisleColors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7)),
                  child: const Text('下一步', style: TextStyle(fontSize: 13)),
                )
              else
                const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.touch_app_outlined,
                      size: 15, color: MoodisleColors.ink2),
                  SizedBox(width: 3),
                  Text('在高亮处操作后自动继续',
                      style:
                          TextStyle(fontSize: 10, color: MoodisleColors.ink2)),
                ]),
            ]),
          ]),
    );
    final hole = this.hole;
    if (hole == null) {
      return Positioned(
        left: 12,
        right: 12,
        bottom: 88,
        child: Center(child: card),
      );
    }
    final below = hole.bottom + 12 + 140 < screen.height;
    final top = (below ? hole.bottom + 12 : hole.top - 152)
        .clamp(12.0, max(12.0, screen.height - 172))
        .toDouble();
    final left = (hole.center.dx - tipWidth / 2)
        .clamp(12.0, max(12.0, screen.width - tipWidth - 12))
        .toDouble();
    return Positioned(
      left: left,
      top: top,
      child: card,
    );
  }

  TextSpan _coachText(String value) {
    final spans = <InlineSpan>[];
    final bold = RegExp(r'<b>(.*?)</b>', dotAll: true);
    var start = 0;
    for (final match in bold.allMatches(value)) {
      if (match.start > start) {
        spans.add(TextSpan(text: value.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ));
      start = match.end;
    }
    if (start < value.length) {
      spans.add(TextSpan(text: value.substring(start)));
    }
    return TextSpan(children: spans);
  }
}

class _CoachBarrier extends StatelessWidget {
  const _CoachBarrier();

  @override
  Widget build(BuildContext context) => const ModalBarrier(
        color: Colors.transparent,
        dismissible: false,
      );
}

/// 抠洞遮罩画笔：全屏压暗 + 目标矩形 BlendMode.clear 抠洞 + 虚线描边。
class _SpotlightPainter extends CustomPainter {
  final Rect? hole;
  _SpotlightPainter({required this.hole});

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.saveLayer(bounds, Paint());
    canvas.drawRect(bounds, Paint()..color = const Color(0x9E281E14));
    if (hole != null) {
      final rrect =
          RRect.fromRectAndRadius(hole!.deflate(4), const Radius.circular(14));
      canvas.drawRRect(rrect, Paint()..blendMode = BlendMode.clear);
      canvas.drawRRect(
          rrect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = const Color(0xE6FFE978));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.hole != hole;
}
