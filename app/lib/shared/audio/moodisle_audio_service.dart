import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

enum MoodisleSound {
  tap,
  add,
  complete,
  capture,
  evolve,
  light,
  loot,
  levelup,
  error,
  glance,
}

enum MoodisleMusic { sunny, mist, night }

const effectAssets = <MoodisleSound, String>{
  MoodisleSound.tap: 'assets/audio/tap.wav',
  MoodisleSound.add: 'assets/audio/add.wav',
  MoodisleSound.complete: 'assets/audio/complete.wav',
  MoodisleSound.capture: 'assets/audio/capture.wav',
  MoodisleSound.evolve: 'assets/audio/evolve.wav',
  MoodisleSound.light: 'assets/audio/light.wav',
  MoodisleSound.loot: 'assets/audio/loot.wav',
  MoodisleSound.levelup: 'assets/audio/levelup.wav',
  MoodisleSound.error: 'assets/audio/error.wav',
  MoodisleSound.glance: 'assets/audio/glance.wav',
};

const musicAssets = <MoodisleMusic, String>{
  MoodisleMusic.sunny: 'assets/audio/bgm_sunny.mp3',
  MoodisleMusic.mist: 'assets/audio/bgm_mist.mp3',
  MoodisleMusic.night: 'assets/audio/bgm_night.mp3',
};

/// App-scoped audio playback. Missing files and platform playback failures are silent.
class MoodisleAudioService {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectsPlayer = AudioPlayer();
  final Queue<MoodisleSound> _effectsQueue = Queue<MoodisleSound>();
  Set<String> _availableAssets = {};
  MoodisleMusic? _requestedMusic;
  MoodisleMusic? _loadedMusic;
  bool _ready = false;
  bool _unlocked = false;
  bool _muted = false;
  bool _foreground = true;
  bool _musicBusy = false;
  bool _effectsBusy = false;
  bool _disposed = false;

  bool get hasAudio => _availableAssets.isNotEmpty;
  bool get isMuted => _muted;

  Future<void> initialize() async {
    if (_ready || _disposed) return;
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final bundled = manifest.listAssets().toSet();
      _availableAssets = {
        ...effectAssets.values.where(bundled.contains),
        ...musicAssets.values.where(bundled.contains),
      };
    } catch (_) {
      _availableAssets = {};
    }
    _ready = true;
    _syncMusic();
    _drainEffects();
  }

  void play(Iterable<MoodisleSound> sounds) {
    if (_disposed) return;
    _unlocked = true;
    if (!_muted) _effectsQueue.addAll(sounds);
    _syncMusic();
    _drainEffects();
  }

  void updateMusic({required bool mist, required DateTime now}) {
    if (_disposed) return;
    _requestedMusic = now.hour >= 18 || now.hour < 6
        ? MoodisleMusic.night
        : mist
            ? MoodisleMusic.mist
            : MoodisleMusic.sunny;
    _syncMusic();
  }

  void toggleMuted() {
    if (_disposed) return;
    _unlocked = true;
    _muted = !_muted;
    if (_muted) {
      unawaited(_pausePlayers());
    } else {
      _syncMusic();
      _drainEffects();
    }
  }

  void onLifecycleChanged(AppLifecycleState state) {
    if (_disposed) return;
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground) {
      _syncMusic();
      _drainEffects();
    } else {
      unawaited(_pausePlayers());
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _effectsQueue.clear();
    await Future.wait([
      _safely(_musicPlayer.dispose()),
      _safely(_effectsPlayer.dispose()),
    ]);
  }

  void _syncMusic() {
    if (!_ready || !_unlocked || _muted || !_foreground || _disposed) return;
    final track = _requestedMusic;
    if (track == null || _musicBusy) return;
    if (_loadedMusic == track && _musicPlayer.playing) return;
    final path = musicAssets[track]!;
    if (!_availableAssets.contains(path)) return;
    _musicBusy = true;
    unawaited(_prepareMusic(track, path));
  }

  Future<void> _prepareMusic(MoodisleMusic track, String path) async {
    try {
      if (_loadedMusic != track) {
        await _musicPlayer.setAsset(path);
        await _musicPlayer.setLoopMode(LoopMode.one);
        _loadedMusic = track;
      }
      if (_requestedMusic == track &&
          !_muted &&
          _foreground &&
          !_disposed &&
          !_musicPlayer.playing) {
        unawaited(_safely(_musicPlayer.play()));
      }
    } catch (_) {
      _loadedMusic = null;
    } finally {
      _musicBusy = false;
      if (_requestedMusic != track) _syncMusic();
    }
  }

  void _drainEffects() {
    if (!_ready || _effectsBusy || _muted || !_foreground || _disposed) return;
    _effectsBusy = true;
    unawaited(_playQueuedEffects());
  }

  Future<void> _playQueuedEffects() async {
    try {
      while (_effectsQueue.isNotEmpty && !_muted && _foreground && !_disposed) {
        final sound = _effectsQueue.removeFirst();
        final path = effectAssets[sound]!;
        if (!_availableAssets.contains(path)) continue;
        try {
          await _effectsPlayer.setAsset(path);
          if (_muted || !_foreground || _disposed) continue;
          await _effectsPlayer.play();
        } catch (_) {
          // A missing or unsupported effect must not affect app interaction.
        }
      }
    } finally {
      _effectsBusy = false;
      if (_effectsQueue.isNotEmpty && !_muted && _foreground && !_disposed) {
        _drainEffects();
      }
    }
  }

  Future<void> _pausePlayers() async {
    await Future.wait([
      _safely(_musicPlayer.pause()),
      _safely(_effectsPlayer.pause()),
    ]);
  }

  Future<void> _safely(Future<void> operation) async {
    try {
      await operation;
    } catch (_) {
      // Browser autoplay and platform audio failures are non-blocking.
    }
  }
}
