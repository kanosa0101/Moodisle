# Focus Screen Lock Lifecycle Implementation Plan

> **For agentic workers:** Execute this plan inline in the current task. Keep the shared focus rules in Dart and isolate OS lifecycle signals in platform adapters.

**Goal:** Keep a focus session counting through device screen lock while pausing it when Moodisle is backgrounded by switching apps.

**Architecture:** Extend the existing persisted focus phase with a screen-locked mode. Android and iOS send native screen-lock and unlock signals through one Flutter method channel; Flutter lifecycle backgrounding pauses immediately, and a lock signal in the transition window can upgrade that pause to locked-time accumulation. Web has no standard signal that distinguishes a locked screen from a hidden tab, so hidden Web sessions pause. A paused app-switch session remains resumable without a two-minute timeout.

**Tech Stack:** Flutter/Dart, Kotlin Android `BroadcastReceiver`, Swift/UIKit protected-data notification, existing Drift/SQLite and JSON phase persistence.

---

### Task 1: Update the shared focus state machine

**Files:**
- Modify: `app/lib/domain/entities/game_state.dart`
- Modify: `app/lib/domain/engine/focus_engine.dart`
- Modify: `app/lib/domain/game_core.dart`
- Modify: `app/lib/domain/config/game_config.dart`
- Modify: `app/lib/domain/events/game_events.dart`
- Modify: `app/test/domain/focus_test.dart` (replace obsolete two-minute expectations without adding test cases)
- Modify: `app/test/domain/invariants_fuzz_test.dart` (allow the persisted `screenLocked` phase)

- Treat `screenLocked` as elapsed focus time and settle it on the first tick/resume after suspension.
- Treat `glancing` as a durable paused state; resume it regardless of pause duration and do not auto-void it.
- Keep explicit user cancellation as the only focus-session void action.
- Reuse the existing string `phase` persistence in SQLite and JSON; no schema migration is needed.

### Task 2: Route platform lifecycle reasons into the shared state machine

**Files:**
- Create: `app/lib/application/focus_lifecycle_channel.dart`
- Modify: `app/lib/main.dart`
- Modify: `app/lib/application/game_controller.dart`
- Modify: `app/lib/presentation/pages/focus_page.dart`
- Modify: `app/android/app/src/main/kotlin/dev/moodisle/moodisle_app/MainActivity.kt`
- Modify: `app/ios/Runner/AppDelegate.swift`

- Receive a native `screenLocked` event over `moodisle/focus_lifecycle`.
- Android listens for `ACTION_SCREEN_OFF` and `ACTION_USER_PRESENT` while the activity engine is attached, so it can stop counting when the user unlocks into another app.
- iOS reports protected-data lock and unlock notifications; if that signal is unavailable, backgrounding falls back to pause.
- Do not pause on `inactive` alone. Apply `hidden`/`paused` immediately; a native lock signal can upgrade the just-paused session during the short lifecycle race window.
- Persist lifecycle transitions and preserve session state across process restoration.

### Task 3: Align user-facing copy and design documentation

**Files:**
- Modify: `docs/01-产品定位与差异化设计.md`
- Modify: `docs/02-系统设计总纲-GDD.md`
- Modify: `docs/03-逻辑内核详细设计.md`
- Modify: `docs/11-软件系统设计说明书.md`
- Modify: `docs/09-验收指南.md`
- Modify: `docs/10-数据库设计.md` (document phase values; no schema change)

- Explain that switching apps pauses focus and the user can resume later.
- Keep the completion result visible if screen-lock elapsed time reaches the selected target before the user returns.
- Document that device lock continues elapsed focus without keeping the screen awake.
- Document the Web visibility limitation and the iOS protected-data fallback.

### Task 4: Review implementation and available verification

- Inspect the complete diff for stale grace-period references and lifecycle races.
- Run `flutter analyze --fatal-infos` and a Kotlin/Android compile check if the local toolchain allows it.
- Do not execute the test suite in this task; leave an explicit note if platform/device acceptance is still needed.
- Manual acceptance matrix: Android screen-off continues; Android app switch pauses; iOS lock continues when protected-data signaling is available; iOS app switch pauses; Web hidden pauses.

### Execution record (2026-10-18)

- [x] Shared state machine now distinguishes active focus, lock-time accumulation, and resumable app-switch pause.
- [x] Android lock/unlock and iOS protected-data lock/unlock signals are bridged into the shared Dart state machine.
- [x] Restore-time lifecycle reconciliation, completion presentation, and cancellation persistence are handled.
- [x] Product, logic, database, system design, and acceptance documents describe the new policy and its platform limits.
- [x] `flutter analyze --fatal-infos` completed with no issues.
- [x] `:app:compileDebugKotlin` completed successfully.
- [ ] Flutter tests and Android/iOS/Web runtime acceptance remain pending; the test suite was not run, and iOS compilation requires macOS/Xcode.
