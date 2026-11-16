import 'package:flutter/foundation.dart';

import 'build_flags.dart';

/// 平台差异只在能力边界声明，页面、规则和存档格式始终共用。
abstract final class PlatformCapabilities {
  static const sqlite = !kMoodisleMp;
  static const nativeScreenLock = !kIsWeb && !kMoodisleMp;
  // 当前小程序无 just_audio 适配，不能把素材存在当作可播放。
  static const audioPlayback = !kMoodisleMp;
  static const focusDescription = kMoodisleMp
      ? '选一位伙伴陪你专注。切换应用、切后台或息屏时会暂停；回来后可以继续。'
      : kIsWeb
          ? '选一位伙伴陪你专注。切换标签页、应用或息屏隐藏网页时会暂停；回来后可以继续。'
          : '选一位伙伴陪你专注。切换到其他应用会暂停，不会自动结束；设备锁屏期间继续计时。';
}
