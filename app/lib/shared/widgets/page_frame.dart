library;

/// 460px 居中页面框架：被 Navigator.push 推出的独立页面也要套用
/// （对齐原版 #app{max-width:460px} 的全局约束）。
import 'package:flutter/material.dart';


class PageFrame extends StatelessWidget {
  final Widget child;
  const PageFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFFE9B0), Color(0xFFF6EAD2), Color(0xFFBFE9C0)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: child,
        ),
      ),
    );
  }
}
