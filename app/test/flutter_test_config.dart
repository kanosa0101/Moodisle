import 'dart:async';

import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';

import 'helpers/fake_just_audio_platform.dart';

/// 全局测试配置：用替身替换 just_audio 平台接口。
///
/// AppShell 持有的 MoodisleAudioService 在构造时创建 just_audio 播放器，
/// 测试环境没有平台音频实现，播放器激活链路会抛出未捕获的
/// MissingPluginException 并炸掉 widget 测试。替身让全部平台调用空转，
/// 测试中音频无声即预期，与服务"音频失败不阻断交互"的设计一致。
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  JustAudioPlatform.instance = FakeJustAudioPlatform();
  await testMain();
}
