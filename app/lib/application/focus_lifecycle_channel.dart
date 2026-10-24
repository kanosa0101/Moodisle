import 'package:flutter/services.dart';

class FocusLifecycleChannel {
  FocusLifecycleChannel._();

  static const MethodChannel _channel =
      MethodChannel('moodisle/focus_lifecycle');

  static Future<void> listenForScreenState({
    required void Function() onScreenLocked,
    required void Function() onScreenUnlocked,
  }) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'screenLocked') onScreenLocked();
      if (call.method == 'screenUnlocked') onScreenUnlocked();
      return null;
    });

    try {
      await _channel.invokeMethod<void>('listen');
    } on MissingPluginException {
      // Web has no native screen-lock signal; its hidden lifecycle pauses focus.
    } on PlatformException {
      // 原生侧注册失败（如进程重启后 channel 断开）时，与 web 同路径：
      // 仅靠生命周期状态（hidden/resumed）驱动专注暂停。
    }
  }

  static void clearHandler() {
    _channel.setMethodCallHandler(null);
  }
}
