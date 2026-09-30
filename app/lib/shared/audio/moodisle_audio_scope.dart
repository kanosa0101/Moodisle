import 'package:flutter/widgets.dart';

import 'moodisle_audio_service.dart';

class MoodisleAudioScope extends InheritedWidget {
  final MoodisleAudioService service;

  const MoodisleAudioScope({
    super.key,
    required this.service,
    required super.child,
  });

  static MoodisleAudioService? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MoodisleAudioScope>()?.service;

  @override
  bool updateShouldNotify(MoodisleAudioScope oldWidget) =>
      service != oldWidget.service;
}
