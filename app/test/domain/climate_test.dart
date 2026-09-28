import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/domain/engine/climate.dart';
import 'package:moodisle_app/domain/entities/emotion.dart';

void main() {
  group('computeFog（docs/03 §7 算例 TC-CLI-001）', () {
    test('压力 14.0 / 舒缓 4.0 → 雾 45.5（薄雾）', () {
      final fog = computeFog(stress: 14.0, relief: 4.0);
      expect(fog, closeTo(45.45, 0.01));
      expect(tierForFog(fog), ClimateTier.mist);
    });

    test('压力与舒缓持平 → 雾 0（晴）', () {
      final fog = computeFog(stress: 6.0, relief: 6.0);
      expect(fog, 0.0);
      expect(tierForFog(fog), ClimateTier.sunny);
    });

    test('全零（分母 +4 保护）→ 恒晴', () {
      expect(computeFog(stress: 0, relief: 0), 0.0);
    });

    test('档位边界：29.9 晴 / 30 薄雾 / 59.9 薄雾 / 60 浓雾', () {
      expect(tierForFog(29.9), ClimateTier.sunny);
      expect(tierForFog(30.0), ClimateTier.mist);
      expect(tierForFog(59.9), ClimateTier.mist);
      expect(tierForFog(60.0), ClimateTier.denseFog);
    });
  });

  group('压力权重与舒缓', () {
    test('焦虑/内耗 1.3，低落/倦怠 1.1，其余 1.0', () {
      expect(taskStress(2, Emotion.anxious), closeTo(2.6, 1e-9));
      expect(taskStress(3, Emotion.neikao), closeTo(3.9, 1e-9));
      expect(taskStress(2, Emotion.emo), closeTo(2.2, 1e-9));
      expect(taskStress(1, Emotion.burnout), closeTo(1.1, 1e-9));
      expect(taskStress(2, Emotion.sloth), 2.0);
    });

    test('relief = 2×完成数 + 专注分钟/15', () {
      expect(reliefFrom(doneCount7d: 4, focusMinutes7d: 50), closeTo(11.333, 0.001));
    });
  });

  group('雾露投放', () {
    test('浓雾 4 / 薄雾 2 / 晴 0；暮雪 +1；上限 5', () {
      expect(dailyMistDew(ClimateTier.denseFog), 4);
      expect(dailyMistDew(ClimateTier.mist), 2);
      expect(dailyMistDew(ClimateTier.sunny), 0);
      expect(dailyMistDew(ClimateTier.sunny, twilightSnow: true), 1);
    });
  });

  group('档位防抖', () {
    test('单次跨档且跳变小 → 保持原档', () {
      final t = resolveTierWithHysteresis(
          current: ClimateTier.sunny,
          newFog: 31,
          previousFog: 29,
          tierHoldDays: 0);
      expect(t, ClimateTier.sunny);
    });

    test('连续两天跨档 → 切换', () {
      final t = resolveTierWithHysteresis(
          current: ClimateTier.sunny,
          newFog: 31,
          previousFog: 29,
          tierHoldDays: 1);
      expect(t, ClimateTier.mist);
    });

    test('单日剧变 > 25 → 立即切换', () {
      final t = resolveTierWithHysteresis(
          current: ClimateTier.sunny,
          newFog: 58,
          previousFog: 10,
          tierHoldDays: 0);
      expect(t, ClimateTier.mist);
    });

    test('回归：雾值大幅回落（30→0）→ 立即回晴', () {
      final t = resolveTierWithHysteresis(
          current: ClimateTier.mist,
          newFog: 0,
          previousFog: 30,
          tierHoldDays: 0);
      expect(t, ClimateTier.sunny);
    });
  });
}
