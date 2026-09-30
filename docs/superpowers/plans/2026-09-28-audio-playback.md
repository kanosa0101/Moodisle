# Moodisle Audio Playback Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire the ten specified sound effects and three user-provided BGM tracks into the shared Web/Android app.

**Architecture:** A `MoodisleAudioService` owns a looping music player and a queued effects player. `AppShell` owns the service, coordinates lifecycle and climate/time changes, and exposes it through a null-safe `InheritedWidget` so existing page constructors and saved game state stay unchanged. Assets are generated or copied into `assets-src/audio/original/`, mirrored to `app/assets/audio/`, and declared together.

**Tech Stack:** Flutter/Dart (project SDK floor remains Dart 3.3), `just_audio` 0.9.x, Flutter `AssetManifest`, bundled WAV/MP3 assets.

---

## Scope and constraints

- Keep the user’s existing working-tree modifications. Several target files already contain uncommitted font, UI, test, and documentation work; make narrow hunks and do not revert, stage, or commit those files.
- Generate the ten SFX deterministically with a project Python standard-library script because no callable SFX generation model is available; do not use third-party samples.
- Preserve the three user-supplied MP3 files unchanged in the source archive; record unavailable provenance fields as unavailable.
- Do not edit domain rules, `GameState`, save codecs, or the event schema.
- Add no automated tests or run `flutter test` in this task. Verify with analysis and release builds; actual listening checks require the user’s later audio files.
- Keep source and runtime copies byte-identical; add no silent placeholders.

## Files and responsibilities

- Create `app/lib/shared/audio/moodisle_audio_service.dart`: cue IDs, bundled-asset discovery, queued SFX, BGM selection, mute, lifecycle, disposal.
- Create `app/lib/shared/audio/moodisle_audio_scope.dart`: null-safe access to the app-owned service without changing page constructors.
- Modify `app/lib/main.dart`: service ownership, scope, top-bar mute control, first-gesture start, BGM sync, lifecycle forwarding, focus bond-level cue.
- Modify `app/lib/presentation/pages/tasks_page.dart`: task add/complete/capture/evolve/keeper-level cues.
- Modify `app/lib/presentation/pages/island_page.dart`: companion glance cue.
- Modify `app/lib/presentation/pages/maze_page.dart`: blocked-action, lantern, and picked-item cues using before/after `MazeRun` state.
- Modify `app/lib/presentation/widgets/roam_card.dart`: successful return-reward cue.
- Modify `app/pubspec.yaml`: declare the audio asset directory after all 13 actual resources have been generated/copied. `just_audio` is already present.
- Update only audio status/instructions in `docs/05-多端技术架构.md`, `docs/06-AI美术资产管线.md`, `docs/07-工程计划与软工实践映射.md`, `docs/08-美术资产描述总表.md`, `docs/09-验收指南.md`, `docs/README.md`, `README.md`, `app/README.md`, and `assets-src/README.md`.
- Add audio rows to `assets-src/ledger.md` and `assets-src/audio/manifest.csv` with truthful provenance and hashes.

## Task 1: Add the audio service and safe asset discovery

**Files:**
- Modify: `app/pubspec.yaml`
- Modify: `app/pubspec.lock`
- Create: `app/lib/shared/audio/moodisle_audio_service.dart`
- Create: `app/lib/shared/audio/moodisle_audio_scope.dart`

- [x] **Step 1: Add a Dart-floor-compatible player dependency**

Add `just_audio: ^0.9.46` under `dependencies`, preserving the existing font declaration and all other dependency versions. Do not upgrade the app’s `environment.sdk` lower bound.

Run from `app/`:

```powershell
& 'E:\flutter-sdk\flutter\bin\flutter.bat' pub get
```

Expected: dependency resolution succeeds and `pubspec.lock` records a `just_audio` 0.9.x version compatible with Dart 3.3.

- [x] **Step 2: Create the service API and cue maps**

Use typed effect and music identifiers. Keep asset paths centralized and do not import game-domain types into the audio service.

```dart
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
```

- [x] **Step 3: Implement a null-safe queued player service**

`MoodisleAudioService.initialize()` loads `AssetManifest` and records only the centralized paths actually present. `hasAudio` is true when at least one mapped asset is bundled. `play(Iterable<MoodisleSound>)` ignores missing paths, appends available effects to a FIFO queue, and drains it with one effects player. The service owns a separate music player configured with `LoopMode.one`.

Expose these methods and state:

```dart
bool get hasAudio;
bool get isMuted;
Future<void> initialize();
void play(Iterable<MoodisleSound> sounds);
void updateMusic({required bool mist, required DateTime now});
void toggleMuted();
void onLifecycleChanged(AppLifecycleState state);
Future<void> dispose();
```

Music selection is `night` when `now.hour >= 18 || now.hour < 6`; otherwise `mist` when `mist` is true and `sunny` when false. Repeated updates for the current track do nothing. Music starts only after `play` or a mute-toggle gesture has unlocked playback. Missing assets, browser playback rejection, and player exceptions are caught inside the service; they must not escape into UI callbacks.

- [x] **Step 4: Add a null-safe scope**

`MoodisleAudioScope` stores one `MoodisleAudioService`; expose `maybeOf(BuildContext)` returning nullable service. Existing widget tests that build pages outside `AppShell` therefore remain valid without test edits.

## Task 2: Wire app ownership, track updates, mute, and lifecycle

**Files:**
- Modify: `app/lib/main.dart`
- Modify: `app/lib/shared/audio/moodisle_audio_scope.dart`

- [x] **Step 1: Own and initialize the service in `AppShell`**

Create `_audio` beside `_controller` in `_AppShellState`; call `unawaited(_audio.initialize())` in `initState`. Wrap the page `IndexedStack` in `MoodisleAudioScope(service: _audio, child: ...)`, leaving AppBar layout and coach-overlay hit testing unchanged.

- [x] **Step 2: Synchronize BGM on state changes**

At the start of `_onControllerChanged`, call:

```dart
_audio.updateMusic(
  mist: _controller.state.climate.tier != ClimateTier.sunny,
  now: DateTime.now(),
);
```

The controller already notifies once per second. The service’s same-track guard prevents a reload on each notification and updates the local-time track at the existing 18:00/06:00 island transition.

- [x] **Step 3: Add one unified mute control**

Add an `IconButton` to the existing `AppBar.actions`. Show `volume_up_rounded` while enabled and `volume_off_rounded` while muted. Disable it and use tooltip `音频素材待接入` while `_audio.hasAudio` is false; otherwise toggle service mute and rebuild only the shell. The choice lasts for the current app run and is not added to game saves.

- [x] **Step 4: Forward lifecycle and release players**

In `didChangeAppLifecycleState`, forward every state to `_audio.onLifecycleChanged(state)` while preserving the current focus and save calls. In `dispose`, call `unawaited(_audio.dispose())` before `super.dispose()`.

- [x] **Step 5: Unlock Web playback on user actions only**

In the user-facing `NavigationBar.onDestinationSelected`, enqueue `tap` only when the selected index changes. Do not put this call in `_switchTab`, which is also used by the tutorial to change tabs programmatically.

## Task 3: Connect effect cues to existing UI outcomes

**Files:**
- Modify: `app/lib/presentation/pages/tasks_page.dart`
- Modify: `app/lib/presentation/pages/island_page.dart`
- Modify: `app/lib/presentation/pages/maze_page.dart`
- Modify: `app/lib/presentation/widgets/roam_card.dart`
- Modify: `app/lib/main.dart`

- [x] **Step 1: Connect task add and completion**

In `_AddPanelState._add`, enqueue `add` only when `_input.text.trim().isNotEmpty`; keep the current controller call, clear, and keyboard-dismiss behavior. In `_completeFlow`’s feedback callback, enqueue the following ordered cues after `controller.completeTask` and before calling `_showCapture`:

```dart
final capture = controller.pendingCapture;
final sounds = <MoodisleSound>[MoodisleSound.complete];
if (capture != null) {
  sounds.add(capture.evolved ? MoodisleSound.evolve : MoodisleSound.capture);
  if (capture.keeperLevelUp) sounds.add(MoodisleSound.levelup);
}
MoodisleAudioScope.maybeOf(context)?.play(sounds);
```

Do not play `capture` and `evolve` together for one result.

- [x] **Step 2: Connect companion glance**

At the start of `_tapActor` in `IslandPage`, call `MoodisleAudioScope.maybeOf(context)?.play([MoodisleSound.glance])`, then preserve the existing snackbar and ecosystem tap.

- [x] **Step 3: Connect maze movement outcomes from state deltas**

Before `mazeClick` or `mazeStep`, snapshot `controller.mazeRun?.picked.length ?? 0` and `controller.mazeRun?.lanterns ?? 0`. After the operation, choose exactly one cue in this priority order: any `MazeRunEvent.isError` → `error`; increased lantern count → `light`; increased picked count → `loot`; otherwise no cue. Pass events unchanged to `_toast`.

- [x] **Step 4: Connect cloud-travel reward claim**

In `RoamCard`’s enabled `迎接伙伴` callback, call `controller.claimRoam(index)` and enqueue `loot`. Keep the button disabled when `due` is false.

- [x] **Step 5: Connect focus bond level-up once**

In `_AppShellState._onControllerChanged`, inspect `pendingFocusDone`. When a new non-null event object first appears and `bondLevelUpTo != null`, enqueue `levelup`. Track the last handled object by identity and clear the reference after `pendingFocusDone` becomes null so a later session can play again.

## Task 4: Update audio source handoff and project status

**Files:**
- Modify: `docs/05-多端技术架构.md`
- Modify: `docs/06-AI美术资产管线.md`
- Modify: `docs/07-工程计划与软工实践映射.md`
- Modify: `docs/08-美术资产描述总表.md`
- Modify: `docs/09-验收指南.md`
- Modify: `docs/README.md`
- Modify: `README.md`
- Modify: `app/README.md`
- Modify: `assets-src/README.md`

- [x] **Step 1: Record the handoff contract**

Document source paths `assets-src/audio/original/`, runtime path `app/assets/audio/`, ten `.wav` names, three `.mp3` names, the sample-rate/channel/bit-depth/bitrate/duration contract from the approved design, and the `assets-src/audio/manifest.csv` provenance fields.

- [x] **Step 2: State the implementation boundary accurately**

The approved delivery uses 10 project-synthesized WAV effects and 3 user-provided MP3 tracks; all 13 resources are now present, registered, and hash-checked. Do not describe all resources as AI-generated. Actual Web/Android sound output and listening acceptance remain pending; unavailable BGM source and license fields stay marked “not provided.”

## Task 5: Generate, copy, and register the 13 audio resources

**Files:**
- Create: `tool/generate_audio_sfx.py`
- Create: 10 WAV files in `assets-src/audio/original/` and `app/assets/audio/`
- Copy/rename: 3 MP3 files from `assets-src/audio/original/` into `app/assets/audio/`
- Create: `assets-src/audio/manifest.csv`
- Modify: `assets-src/ledger.md`, audio documentation, `app/pubspec.yaml`

- [x] Generate the ten short mono PCM WAV effects with fixed per-cue seeds and no third-party dependencies or samples.
- [x] Copy the three user tracks without transcoding. Map `Barefoot_on_the_Lawn` to sunny, `Through_the_Orchard_Gate` to mist, and `Running_Toward_The_Horizon` to night provisionally by title.
- [x] Verify duration, sample rate, channels, encoding, and SHA-256 for all source/runtime pairs; record unavailable music provenance as “not provided.”
- [x] Add the audio asset directory to pubspec and update only audio-related project status and source documentation.

## Task 6: Verify the wiring without claiming audio playback acceptance

**Files:**
- No additional files.

- [x] **Step 1: Run static analysis**

From `app/` run:

```powershell
& 'E:\flutter-sdk\flutter\bin\flutter.bat' analyze
```

Expected: `No issues found!`.

- [x] **Step 2: Build Web Release**

From `app/` run:

```powershell
& 'E:\flutter-sdk\flutter\bin\flutter.bat' build web --release --pwa-strategy=none
```

Expected: exit code 0 and refreshed `app/build/web/` output. This verifies compilation only; it does not prove sound output while assets are absent.

- [x] **Step 3: Build Android Release**

From `app/` run:

```powershell
& 'E:\flutter-sdk\flutter\bin\flutter.bat' build apk --release
```

Expected: exit code 0 and refreshed `app/build/app/outputs/flutter-apk/app-release.apk`.

- [x] **Step 4: Check worktree boundaries**

Run `git status --short --branch` and confirm the new audio service, dependency, app wiring, and docs appear alongside (not replacing) the pre-existing user edits. Do not stage or commit implementation files because they overlap existing uncommitted files and the user has not asked to commit them.

After build verification, actual browser and Android listening acceptance was completed by the user on 2026-10-01: output, mute, track mapping, looping, lifecycle, and the ten event cues all check out on Web and Android.
