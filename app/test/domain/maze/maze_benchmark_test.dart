import 'package:flutter_test/flutter_test.dart';
import '../../../benchmark/maze_benchmark.dart' as benchmark;

void main() {
  test('replay median sorts samples and selects the middle value', () {
    expect(benchmark.medianMillis([5178, 4579, 4600]), 4600);
  });

  test('performance budget tolerates one slow replay sample', () {
    expect(
      benchmark.meetsMazeBudget(
        worstGenerationMs: 24.59,
        replaySamplesMs: [5178, 4579, 4600],
      ),
      isTrue,
    );
  });

  test('performance budget rejects a slow replay median or generation sample',
      () {
    expect(
      benchmark.meetsMazeBudget(
        worstGenerationMs: 24.59,
        replaySamplesMs: [5100, 5200, 5300],
      ),
      isFalse,
    );
    expect(
      benchmark.meetsMazeBudget(
        worstGenerationMs: 50,
        replaySamplesMs: [4000, 4500, 4800],
      ),
      isFalse,
    );
    expect(
      benchmark.meetsMazeBudget(
        worstGenerationMs: 24.59,
        replaySamplesMs: [4900, 5000, 5100],
      ),
      isFalse,
    );
  });
}
