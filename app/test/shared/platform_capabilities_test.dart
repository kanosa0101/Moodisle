import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moodisle_app/shared/build_flags.dart';
import 'package:moodisle_app/shared/platform_capabilities.dart';
import 'package:moodisle_app/shared/audio/moodisle_audio_service.dart';

void main() {
  const expectedMp = bool.fromEnvironment('EXPECTED_MP');
  test('构建开关实际选择正确的平台能力', () {
    expect(kMoodisleMp, expectedMp);
    expect(PlatformCapabilities.sqlite, !expectedMp);
    expect(PlatformCapabilities.nativeScreenLock, !expectedMp && !kIsWeb);
    expect(PlatformCapabilities.audioPlayback, !expectedMp);
    if (expectedMp) {
      expect(PlatformCapabilities.focusDescription, contains('息屏时会暂停'));
    }
  });

  test('无音频能力时不创建播放器，生命周期和静音操作可安全调用', () async {
    final service = MoodisleAudioService(enabled: false);
    await service.initialize();
    service.play([MoodisleSound.tap]);
    service.updateMusic(mist: false, now: DateTime(2026, 11, 16, 10));
    service.setMusicSuppressed(true);
    service.toggleMuted();
    expect(service.hasAudio, isFalse);
    await service.dispose();
  });
}
