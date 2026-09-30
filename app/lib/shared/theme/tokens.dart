/// 设计 token（docs/01 视觉语言 + docs/05 §3.4）。
///
/// 奶油纸感 + 暖棕描边 + 底部实体阴影 + 贴纸插画；与 AI 美术管线共用色板。
/// 暗色主题在 M7 打磨期接入（token 已预留语义分组）。
library;
import 'package:flutter/material.dart';

/// 全局色板（12 色锁定的 UI 子集；精灵 10 色见 EmotionMeta.colorValue）。
class MoodisleColors {
  MoodisleColors._();

  /// 随包分发的中文子集字体族名（app/pubspec.yaml fonts 声明；
  /// 由 tool/subset_font.py 生成）。裸 TextPainter 等不经过主题的文本需显式引用。
  static const String fontFamily = 'MoodisleSans';

  static const Color orange = Color(0xFFE0A23C); // 主色
  static const Color green = Color(0xFF5FE08E); // 成功
  static const Color yellow = Color(0xFFFFE9B0);
  static const Color mint = Color(0xFF39D3C3);
  static const Color pink = Color(0xFFFF8FB1);
  static const Color wood = Color(0xFF8A6B4F);
  static const Color ink = Color(0xFF3A2E23); // 主文字
  static const Color ink2 = Color(0xFF7A6A52); // 次文字
  static const Color paper = Color(0xFFFFFAF0); // 面板底
  static const Color line = Color(0xFFD9B97E); // 描边
  static const Color shadow = Color(0xFFE3C98E); // 底部实体阴影
  static const Color pageBg = Color(0xFFF6EAD2); // 页面底
}

/// 圆角体系。
class MoodisleRadii {
  MoodisleRadii._();
  static const double s = 10;
  static const double m = 14;
  static const double l = 16;
  static const double xl = 20;
}

/// 纸感面板装饰（panel = 原型 .panel 的 Flutter 对应物）。
class PaperPanel {
  PaperPanel._();

  static BoxDecoration decoration({Color? color}) => BoxDecoration(
        color: color ?? MoodisleColors.paper,
        border: Border.all(color: MoodisleColors.line, width: 2),
        borderRadius: BorderRadius.circular(MoodisleRadii.l),
        boxShadow: const [
          BoxShadow(
            color: MoodisleColors.shadow,
            offset: Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      );
}

/// 应用主题（M2 骨架用；随里程碑演进）。
ThemeData buildMoodisleTheme() {
  // 随包分发的中文子集字体（SIL OFL），界面文本离线可用；
  // 集外字符走系统/在线回退
  final base = ThemeData(useMaterial3: true, fontFamily: MoodisleColors.fontFamily);
  return base.copyWith(
    scaffoldBackgroundColor: MoodisleColors.pageBg,
    colorScheme: base.colorScheme.copyWith(
      primary: MoodisleColors.orange,
      secondary: MoodisleColors.green,
      surface: MoodisleColors.paper,
      onSurface: MoodisleColors.ink,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: MoodisleColors.ink,
      displayColor: MoodisleColors.ink,
    ),
  );
}
