/// 十情绪 × 十天气精灵。
///
/// 设计真源：docs/02 §1（阵容与配色）、docs/08（美术文本描述）。
/// 本文件为纯 Dart，禁止依赖 Flutter。
enum Emotion {
  anxious, // 焦虑 · 雷灵
  emo, // 低落 · 雨灵
  sloth, // 拖延 · 雾灵
  burnout, // 倦怠 · 霭灵
  neikao, // 内耗 · 云灵
  chaos, // 混乱 · 涡灵
  distract, // 分心 · 风灵
  perfect, // 完美主义 · 霜灵
  fomo, // 错失焦虑 · 星灵
  shy, // 社恐 · 霞灵
}

extension EmotionMeta on Emotion {
  String get emotionCn => switch (this) {
        Emotion.anxious => '焦虑',
        Emotion.emo => '低落',
        Emotion.sloth => '拖延',
        Emotion.burnout => '倦怠',
        Emotion.neikao => '内耗',
        Emotion.chaos => '混乱',
        Emotion.distract => '分心',
        Emotion.perfect => '完美主义',
        Emotion.fomo => '错失焦虑',
        Emotion.shy => '社恐',
      };

  /// 情绪压力权重（docs/03 §7 气候引擎）。
  double get stressWeight => switch (this) {
        Emotion.anxious || Emotion.neikao => 1.3,
        Emotion.emo || Emotion.burnout => 1.1,
        _ => 1.0,
      };

  String get petCn => switch (this) {
        Emotion.anxious => '雷灵',
        Emotion.emo => '雨灵',
        Emotion.sloth => '雾灵',
        Emotion.burnout => '霭灵',
        Emotion.neikao => '云灵',
        Emotion.chaos => '涡灵',
        Emotion.distract => '风灵',
        Emotion.perfect => '霜灵',
        Emotion.fomo => '星灵',
        Emotion.shy => '霞灵',
      };

  String get petEn => switch (this) {
        Emotion.anxious => 'Zappy',
        Emotion.emo => 'Drippy',
        Emotion.sloth => 'Misty',
        Emotion.burnout => 'Hazy',
        Emotion.neikao => 'Nimbus',
        Emotion.chaos => 'Swirly',
        Emotion.distract => 'Breezy',
        Emotion.perfect => 'Frosty',
        Emotion.fomo => 'Starry',
        Emotion.shy => 'Rosy',
      };

  String get weatherCn => switch (this) {
        Emotion.anxious => '雷阵雨',
        Emotion.emo => '连绵雨',
        Emotion.sloth => '起雾',
        Emotion.burnout => '暮霭',
        Emotion.neikao => '低云盘旋',
        Emotion.chaos => '乱流',
        Emotion.distract => '风',
        Emotion.perfect => '霜',
        Emotion.fomo => '流星',
        Emotion.shy => '晚霞',
      };

  /// 精灵主色（docs/02 §1 配色表）。
  int get colorValue => switch (this) {
        Emotion.anxious => 0xFFA06FE0,
        Emotion.emo => 0xFF5B8FD6,
        Emotion.sloth => 0xFF9AA7C9,
        Emotion.burnout => 0xFFA3B18A,
        Emotion.neikao => 0xFF6C7FD8,
        Emotion.chaos => 0xFFE05F8F,
        Emotion.distract => 0xFF39C3B0,
        Emotion.perfect => 0xFF7FD0E8,
        Emotion.fomo => 0xFFF0C94A,
        Emotion.shy => 0xFFF299A3,
      };
}
