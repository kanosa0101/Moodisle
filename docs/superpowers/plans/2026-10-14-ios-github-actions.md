# iOS GitHub Actions Delivery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the existing Flutter application buildable for iOS from Windows through one deliberately triggered GitHub Actions job, with an unsigned compile artifact by default and an optional device-installable signed IPA.

**Architecture:** Keep all product behavior in the existing shared Dart/Flutter layers. Change only the iOS shell metadata, add one macOS workflow with two mutually exclusive output modes, and document the evidence boundary between compilation, signing, and real-device parity. The workflow never runs on push or pull request, cancels superseded runs for the same ref, and retains artifacts for three days.

**Tech Stack:** Flutter 3.47.5, Dart, Xcode on `macos-15`, GitHub Actions, Apple code signing tools.

> **Delivery evidence (2026-10-14):** Linux CI run `38557417103` passed before the only macOS dispatch. iOS run `38557785074` completed the `unsigned-app` path successfully in about four minutes; the downloaded inner artifact SHA-256 is `9508A5D2F10A596490B6791C6DB18A0F133C971C0F266A691C24D439BEC97BFB`. Signed IPA and real-device acceptance remain open because Apple signing material has not been provided.

---

## File structure

- Modify `app/ios/Runner/Info.plist`: align the iOS home-screen display name with Android.
- Modify `app/ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png`: replace Flutter template icons with deterministic size variants of the existing Moodisle icon master.
- Create `.github/workflows/ios-build.yml`: provide the only macOS build entry point and optional local code-signing steps.
- Modify `README.md`, `app/README.md`, `docs/05-多端技术架构.md`, `docs/07-工程计划与软工实践映射.md`, `docs/09-验收指南.md`, and `docs/README.md`: record how to trigger the workflow, configure secrets, and interpret its artifacts.

### Task 1: Align the iOS shell

**Files:**
- Modify: `app/ios/Runner/Info.plist`
- Modify: `app/ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png`

- [x] **Step 1: Set the iOS display name**

Replace the existing bundle display name value with:

```xml
<key>CFBundleDisplayName</key>
<string>心晴屿 Moodisle</string>
```

Keep `PRODUCT_BUNDLE_IDENTIFIER = dev.moodisle.moodisleApp` unchanged because changing an App ID without the Apple account configuration would invalidate any future provisioning profile.

- [x] **Step 2: Derive the iOS icon set from the existing master**

Use Pillow Lanczos resizing to generate every filename declared in `Contents.json` from `app/assets/ui/app_icon.png`. Convert outputs to RGB because App Store icons cannot contain transparency. Required pixel sizes are 20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, and 1024.

- [x] **Step 3: Verify the plist, identifier, and icons statically**

Run from the repository root:

```powershell
[xml](Get-Content -Raw app/ios/Runner/Info.plist) | Out-Null
rg -n "CFBundleDisplayName|dev\.moodisle\.moodisleApp" app/ios
python -c "from PIL import Image; from pathlib import Path; print([(p.name, Image.open(p).size, Image.open(p).mode) for p in Path('app/ios/Runner/Assets.xcassets/AppIcon.appiconset').glob('*.png')])"
```

Expected: XML parsing succeeds; the display-name key and current bundle identifier are present; all 15 icon files are RGB PNGs at their declared pixel sizes.

### Task 2: Add the quota-conscious iOS build workflow

**Files:**
- Create: `.github/workflows/ios-build.yml`

- [x] **Step 1: Add a manual-only workflow**

Create a workflow with `workflow_dispatch` only. Define an `artifact` choice whose default is `unsigned-app` and whose other value is `signed-ipa`. Use `macos-15`, Flutter `3.47.5`, `timeout-minutes: 30`, and:

```yaml
concurrency:
  group: ios-build-${{ github.ref }}
  cancel-in-progress: true
```

- [x] **Step 2: Fail early when signing inputs are absent**

For `signed-ipa`, require these repository secrets before dependency resolution or compilation:

```text
IOS_CERTIFICATE_BASE64
IOS_CERTIFICATE_PASSWORD
IOS_PROVISIONING_PROFILE_BASE64
IOS_KEYCHAIN_PASSWORD
```

The preflight step must exit nonzero if any value is empty, so a mistaken signed dispatch consumes only runner startup time.

- [x] **Step 3: Build exactly once**

Run `flutter pub get` and then:

```bash
flutter build ios --release --no-codesign
```

For `unsigned-app`, zip `build/ios/iphoneos/Runner.app`. For `signed-ipa`, install the certificate and provisioning profile, verify the profile bundle identifier equals `dev.moodisle.moodisleApp`, sign nested frameworks and the app, verify the signature, and package `Payload/Runner.app` as `Moodisle.ipa`. Do not start a second Flutter build for signing.

- [x] **Step 4: Limit artifact storage**

Upload only the selected artifact with `retention-days: 3`, `compression-level: 0`, and `if-no-files-found: error`.

### Task 3: Document operation and evidence boundaries

**Files:**
- Modify: `README.md`
- Modify: `app/README.md`
- Modify: `docs/05-多端技术架构.md`
- Modify: `docs/07-工程计划与软工实践映射.md`
- Modify: `docs/09-验收指南.md`
- Modify: `docs/README.md`

- [x] **Step 1: Document the Windows-to-iOS path**

State that contributors trigger **Actions → iOS Build → Run workflow** only after the Linux CI for the same commit is green. Explain that `unsigned-app` proves compilation but cannot be installed on a physical device.

- [x] **Step 2: Document signed IPA prerequisites**

Record the four secret names, the fixed bundle identifier, and the requirement that the provisioning profile include the target iPhone UDID. State that repository secrets must contain base64 file contents and must never be committed.

- [x] **Step 3: Define iOS acceptance**

Require installation on a real iPhone and a focused parity pass covering first-run onboarding, text input, task capture, local save restore, audio and mute, foreground/background focus timing, collection layouts, island movement, and maze touch controls. Keep Live Activity, notifications, widgets, haptics, and dark mode outside this scope.

### Task 4: Perform local static verification

**Files:**
- Verify: all files changed by Tasks 1–3

- [x] **Step 1: Check syntax and whitespace**

Run:

```powershell
[xml](Get-Content -Raw app/ios/Runner/Info.plist) | Out-Null
python -c "import pathlib, yaml; yaml.safe_load(pathlib.Path('.github/workflows/ios-build.yml').read_text(encoding='utf-8')); print('workflow yaml ok')"
git diff --check
```

Expected: plist and YAML parse successfully; `git diff --check` prints nothing.

- [x] **Step 2: Confirm the cost controls**

Run:

```powershell
rg -n "workflow_dispatch|macos-15|timeout-minutes|cancel-in-progress|retention-days|flutter build ios --release --no-codesign" .github/workflows/ios-build.yml
```

Expected: every guard is present and no `push`, `pull_request`, or `schedule` trigger exists.

- [x] **Step 3: Review the final diff**

Run:

```powershell
git status --short
git diff --stat
git diff -- .github/workflows/ios-build.yml app/ios/Runner/Info.plist README.md app/README.md docs
```

Expected: every changed line maps to iOS shell metadata, the manual workflow, or its documentation. No remote workflow is dispatched during this static review.
