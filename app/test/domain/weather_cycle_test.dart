import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/config/weather_cycle.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';

void main() {
  test('环上每个情绪都有后继且指向合法情绪', () {
    for (final e in Emotion.values) {
      expect(kWeatherNext.containsKey(e), isTrue, reason: '$e 缺少后继');
      expect(Emotion.values.contains(kWeatherNext[e]), isTrue);
    }
    expect(kWeatherNext.length, Emotion.values.length);
  });

  test('从雷灵出发走 10 步回到起点（环闭合）', () {
    var cur = Emotion.anxious;
    for (var i = 0; i < Emotion.values.length; i++) {
      cur = nextInCycle(cur);
    }
    expect(cur, Emotion.anxious);
  });

  test('一整圈恰好覆盖全部 10 种情绪各一次', () {
    final ring = cycleFrom(Emotion.anxious);
    expect(ring.length, 10);
    expect(ring.toSet(), Emotion.values.toSet());
  });

  test('任意起点展开的环一致（环形不变性）', () {
    final a = cycleFrom(Emotion.anxious);
    final b = cycleFrom(Emotion.shy);
    expect(b.toSet(), a.toSet());
  });
}
