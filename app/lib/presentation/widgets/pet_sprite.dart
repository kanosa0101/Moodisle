/// 精灵立绘组件：优先加载正式 AI 图（docs/08 §3 命名规范），
/// 缺失时回退到程序化占位（主色圆 + 天气符号），美术到位即无缝切换。
library;

import 'package:flutter/material.dart';

import '../../domain/engine/eco_sim.dart' show Biome;
import '../../domain/entities/emotion.dart';
import '../../domain/entities/pet.dart';
import '../../shared/theme/tokens.dart';

/// 立绘资产路径（docs/08 §3 命名规范；供 widget 与迷宫画布共用）。
String petAssetPath(
    Emotion emotion, PetStage stage, Branch? branch, String dir) {
  final st = switch (stage) {
    PetStage.clear => 2,
    PetStage.rainbow => 3,
    PetStage.awakened => 4,
  };
  final branchSeg = stage == PetStage.awakened
      ? (branch == Branch.deepcurrent ? 'deepcurrent' : 'constellation')
      : 'clear';
  return 'assets/pets/${emotion.name}/st${st}_${branchSeg}_$dir.png';
}

/// 天气图标（占位绘制用；正式图就位后仅作角标）。
const Map<Emotion, IconData> kWeatherIcon = {
  Emotion.anxious: Icons.bolt_rounded,
  Emotion.emo: Icons.water_drop_rounded,
  Emotion.sloth: Icons.blur_on_rounded,
  Emotion.burnout: Icons.wb_twilight_rounded,
  Emotion.neikao: Icons.cloud_rounded,
  Emotion.chaos: Icons.cyclone_rounded,
  Emotion.distract: Icons.air_rounded,
  Emotion.perfect: Icons.ac_unit_rounded,
  Emotion.fomo: Icons.auto_awesome_rounded,
  Emotion.shy: Icons.wb_twilight_rounded,
};

class PetSprite extends StatelessWidget {
  final Emotion emotion;
  final PetStage stage;
  final Branch? branch;

  /// front / back / left / right
  final String dir;
  final double size;
  final bool wild; // 阴态：晴态图 + 灰化

  const PetSprite({
    super.key,
    required this.emotion,
    this.stage = PetStage.clear,
    this.branch,
    this.dir = 'front',
    this.size = 48,
    this.wild = false,
  });

  String get assetPath => petAssetPath(emotion, stage, branch, dir);

  @override
  Widget build(BuildContext context) {
    Widget img = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none,
      cacheWidth: (size * 2).round(), // 按显示尺寸 2x 解码，控制内存
      errorBuilder: (_, __, ___) => _PlaceholderPet(
          emotion: emotion,
          size: size,
          glyph: kWeatherIcon[emotion] ?? Icons.cloud_rounded),
    );
    if (wild) {
      img = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: Opacity(opacity: 0.75, child: img),
      );
    }
    return img;
  }
}

/// 占位立绘：主色圆 + 天气符号 + 暖棕描边（美术资源缺失时的兜底）。
class _PlaceholderPet extends StatelessWidget {
  final Emotion emotion;
  final double size;
  final IconData glyph;

  const _PlaceholderPet(
      {required this.emotion, required this.size, required this.glyph});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(emotion.colorValue).withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: MoodisleColors.line, width: 2),
      ),
      child: Center(
          child: Icon(glyph, size: size * 0.45, color: MoodisleColors.ink)),
    );
  }
}

/// 微气候区 → 背景色（心岛地图用）。
Color biomeColor(Biome b) => switch (b) {
      Biome.sunnyMeadow => const Color(0xFF9FE0B0),
      Biome.rainLake => const Color(0xFF8CC8E8),
      Biome.mistWoods => const Color(0xFF8FBF98),
      Biome.windCliff => const Color(0xFFC8C4B0),
      Biome.sunsetShore => const Color(0xFFF2DCA0),
    };
