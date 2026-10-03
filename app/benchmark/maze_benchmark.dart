/// 迷宫性能基准（docs/04 §7 验收目标）：
///   · 生成+求解单次 < 50ms（中端机）
///   · 回放 1000 局 < 5s
/// 纯 Dart 实现，不依赖 Flutter 绑定。运行：
///   cd app && dart run benchmark/maze_benchmark.dart
// ignore_for_file: avoid_print
library;

import 'dart:io';

import 'package:moodisle_app/domain/engine/maze/maze_generator.dart';
import 'package:moodisle_app/domain/engine/maze/maze_solver.dart';

double medianMillis(List<int> samples) {
  if (samples.isEmpty) {
    throw ArgumentError.value(samples, 'samples', 'cannot be empty');
  }
  final sorted = [...samples]..sort();
  final middle = sorted.length ~/ 2;
  if (sorted.length.isOdd) return sorted[middle].toDouble();
  return (sorted[middle - 1] + sorted[middle]) / 2;
}

bool meetsMazeBudget({
  required double worstGenerationMs,
  required List<int> replaySamplesMs,
}) =>
    worstGenerationMs < 50 && medianMillis(replaySamplesMs) < 5000;

void main() {
  final watch = Stopwatch();
  final samples = <int>[];

  // 1) 生成+求解：10 区 × 每区 100 种子采样，共 1000 组
  for (var zi = 0; zi < 10; zi++) {
    for (var seed = 0; seed < 100; seed++) {
      watch
        ..reset()
        ..start();
      final m =
          MazeGenerator.generate(zoneIndex: zi, startLevel: 5, seed: seed);
      MazeSolver.solve(m.floors.last, m.floorStartLevels.last);
      samples.add(watch.elapsedMicroseconds);
    }
  }
  samples.sort();
  double ms(int micros) => micros / 1000.0;
  final median = ms(samples[samples.length ~/ 2]);
  final p95 = ms(samples[samples.length * 95 ~/ 100 - 1]);
  final worst = ms(samples.last);
  print('生成+求解（1000 组采样）：中位数 ${median.toStringAsFixed(2)} ms，'
      'p95 ${p95.toStringAsFixed(2)} ms，最差 ${worst.toStringAsFixed(2)} ms'
      '（目标 < 50 ms）');

  // 2) 回放 1000 局，测三次并以中位数作为门禁值，降低单次调度抖动影响。
  final replaySamplesMs = <int>[];
  for (var trial = 0; trial < 3; trial++) {
    final replay = Stopwatch()..start();
    for (var i = 0; i < 1000; i++) {
      final m =
          MazeGenerator.generate(zoneIndex: i % 10, startLevel: 5, seed: i);
      MazeSolver.solve(m.floors.last, m.floorStartLevels.last);
    }
    replay.stop();
    replaySamplesMs.add(replay.elapsedMilliseconds);
  }
  final replayMedian = medianMillis(replaySamplesMs);
  print('回放 1000 局（三次样本 ${replaySamplesMs.join(', ')} ms）：'
      '中位数 ${replayMedian.toStringAsFixed(0)} ms（目标 < 5000 ms）');

  final ok = meetsMazeBudget(
    worstGenerationMs: worst,
    replaySamplesMs: replaySamplesMs,
  );
  print(ok ? '结论：达标' : '结论：未达标');
  if (!ok) exitCode = 1;
}
