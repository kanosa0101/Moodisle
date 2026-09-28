/// 天气循环环（docs/02 §4 设计真源）。
///
/// 环序依据「情绪的自然滑动」：雷→雨→雾→霭→云→涡→风→霜→星→霞→雷。
/// 全部为本项目原创设定（docs/00 R3），禁用任何参考原型环序。
library;
import '../entities/emotion.dart';

const Map<Emotion, Emotion> kWeatherNext = {
  Emotion.anxious: Emotion.emo, // 雷→雨：雷雨过后情绪落下来
  Emotion.emo: Emotion.sloth, // 雨→雾：雨后起雾，提不起劲
  Emotion.sloth: Emotion.burnout, // 雾→霭：雾积成霾，越拖越蔫
  Emotion.burnout: Emotion.neikao, // 霭→云：蔫着蔫着开始盘旋想太多
  Emotion.neikao: Emotion.chaos, // 云→涡：盘旋成结，生活变乱
  Emotion.chaos: Emotion.distract, // 涡→风：乱流四起，注意力吹散
  Emotion.distract: Emotion.perfect, // 风→霜：风停了，僵在「要做得完美」
  Emotion.perfect: Emotion.fomo, // 霜→星：僵到怕错过一切
  Emotion.fomo: Emotion.shy, // 星→霞：观望久了不敢加入
  Emotion.shy: Emotion.anxious, // 霞→雷：霞光退场，又聚起新的雷
};

/// 环上的下一环。
Emotion nextInCycle(Emotion e) => kWeatherNext[e]!;

/// 从 [start] 沿环展开一整圈（含起点，长度 = 情绪总数）。
List<Emotion> cycleFrom(Emotion start) {
  final out = <Emotion>[start];
  var cur = start;
  for (var i = 0; i < kWeatherNext.length - 1; i++) {
    cur = nextInCycle(cur);
    out.add(cur);
  }
  return out;
}
