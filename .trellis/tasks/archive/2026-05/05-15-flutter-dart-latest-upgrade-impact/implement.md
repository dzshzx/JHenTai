# Safe Flutter/Dart Upgrade Implementation Plan

## Pre-Start Gate

- User confirms acceptance of latest Flutter platform floors:
  - Android API 24+
  - iOS 13+
  - macOS 10.15+
- After confirmation, run `python3 ./.trellis/scripts/task.py start flutter-dart-latest-upgrade-impact` from the primary worktree.
- Load implementation context with `trellis-before-dev` before editing code.

## Step 1: Create Isolated Worktree

```bash
mkdir -p ~/upgrade-sandbox/jhentai
git worktree add ~/upgrade-sandbox/jhentai/worktree -b chore/flutter-3.41 HEAD
```

Use the isolated worktree for all application changes:

```bash
cd ~/upgrade-sandbox/jhentai/worktree
export SANDBOX_ROOT=~/upgrade-sandbox/jhentai
export PUB_CACHE="$SANDBOX_ROOT/pub-cache"
export GRADLE_USER_HOME="$SANDBOX_ROOT/gradle"
export PATH="$SANDBOX_ROOT/flutter/bin:$PATH"
```

Network commands should use the local proxy when the environment requires it:

```bash
export http_proxy=http://127.0.0.1:7897
export https_proxy=http://127.0.0.1:7897
export HTTP_PROXY="$http_proxy"
export HTTPS_PROXY="$https_proxy"
export all_proxy=socks5h://127.0.0.1:7897
export ALL_PROXY="$all_proxy"
```

For Gradle dependency downloads, also write the proxy into the isolated Gradle
user home or pass equivalent JVM system properties:

```properties
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=7897
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=7897
```

If using an isolated Android SDK:

```bash
export ANDROID_SDK_ROOT="$SANDBOX_ROOT/android-sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
```

## Step 2: Pin Flutter SDK

Install or copy Flutter 3.41.9 stable into the sandbox:

```bash
"$SANDBOX_ROOT/flutter/bin/flutter" --version
```

Expected Flutter version:

```text
Flutter 3.41.9
Tools • Dart 3.11.5
```

## Step 3: Minimal Dependency Compatibility

Edit `pubspec.yaml` in the upgrade worktree:

- `path: 1.9.1`
- `intl: 0.20.2`
- `template_expressions: 3.3.1+2`
- `syncfusion_flutter_charts: 33.2.6` or compatible
- Remove or update `dependency_overrides` for `test_api`, `matcher`, and `collection` unless a command proves they are still needed.

Run:

```bash
flutter pub get
```

Inspect `pubspec.lock` and `.dart_tool/package_config.json` for unexpected SDK floors or package downgrades.

## Step 4: Source Compatibility

Apply confirmed API fix:

- `lib/src/config/theme_config.dart`: replace `DialogTheme(...)` with `DialogThemeData(...)`.

Run:

```bash
flutter analyze
```

Treat compile errors as blockers. Existing warnings may be recorded separately, but new SDK deprecations should be triaged for future cleanup unless they block compilation.

## Step 5: Platform Compatibility

Android:

- Raise `android/gradle.properties` heap to at least `-Xmx4096M`.
- Set minSdk to Flutter latest supported floor, preferably `flutter.minSdkVersion` or explicit `24`.
- Consider raising compileSdk/targetSdk to Flutter template values if Gradle validation warns or release build requires it.
- Update Gradle wrapper / AGP / Kotlin toward supported versions if warnings become blockers.

iOS:

- Raise `ios/Podfile` platform to `13.0`.
- Update `ios/Runner.xcodeproj/project.pbxproj` deployment target entries to `13.0`.

macOS:

- Keep `macos/Podfile` at `10.15` or higher.
- Normalize all `MACOSX_DEPLOYMENT_TARGET` entries in `macos/Runner.xcodeproj/project.pbxproj` to `10.15` or higher.

## Step 6: Validation

Minimum validation commands in the upgrade worktree:

```bash
flutter pub get
flutter analyze
flutter build apk --debug -t lib/src/main.dart
```

If debug build passes, continue with:

```bash
flutter build apk --release -t lib/src/main.dart
```

If macOS/iOS tooling is available on the executing machine:

```bash
flutter build ios --no-codesign -t lib/src/main.dart
flutter build macos -t lib/src/main.dart
```

## Step 7: Manual Regression Checklist

Manual checks after a runnable build:

- Chart rendering pages affected by Syncfusion.
- Login and WebView flows.
- Share intent entry point.
- Download queue and archive/gallery download paths.
- Database opening and migration path.
- Image reader gestures and zoom.
- Android app links / deep links.
- Permission and local auth prompts.

## Risk Files

- `pubspec.yaml`
- `pubspec.lock`
- `lib/src/config/theme_config.dart`
- `android/gradle.properties`
- `android/app/build.gradle`
- `android/settings.gradle`
- `android/gradle/wrapper/gradle-wrapper.properties`
- `ios/Podfile`
- `ios/Runner.xcodeproj/project.pbxproj`
- `macos/Podfile`
- `macos/Runner.xcodeproj/project.pbxproj`

## Review Gate

Before merging the upgrade branch back, compare:

```bash
git diff --stat master...HEAD
git diff master...HEAD -- pubspec.yaml pubspec.lock android ios macos lib/src/config/theme_config.dart
```

The diff should remain focused on SDK compatibility. Broad package modernization should be split into follow-up tasks.
