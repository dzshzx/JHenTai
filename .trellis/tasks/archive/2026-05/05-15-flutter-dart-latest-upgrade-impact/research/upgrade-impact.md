# Flutter/Dart Latest Upgrade Impact

Research date: 2026-05-15 Asia/Shanghai

## Verdict

Directly upgrading this repository from the current local toolchain to the latest stable Flutter/Dart is likely breaking. The breakage is manageable, but it requires dependency constraint updates, one confirmed Flutter API code change, platform minimum-version decisions, and Android build configuration adjustments before the project can be considered upgraded.

## Version Evidence

- Local toolchain: Flutter 3.24.5 / Dart 3.5.4. `flutter doctor -v` reports the SDK is on an unknown `[user-branch]` and has an unknown upstream source.
- Official latest Flutter stable at research time: Flutter 3.41.9, released 2026-04-30, bundled Dart 3.11.5. Source: `https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json`.
- Official latest standalone Dart stable at research time: Dart 3.11.6, dated 2026-05-05. Source: `https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION`.
- For Flutter apps, the relevant Dart runtime is the Dart bundled with the selected Flutter SDK, so Flutter 3.41.9 means Dart 3.11.5 unless the app is analyzed separately with standalone Dart.

## Current Project State

- `pubspec.yaml` declares Dart `>=3.0.0 <4.0.0`.
- `pubspec.lock` currently records SDK floors of Dart `>=3.5.1 <4.0.0` and Flutter `>=3.24.0`.
- The dependency graph currently contains 183 packages; 60 are direct/dev dependencies.
- `flutter pub outdated --json` on the current SDK reports:
  - 59 of 60 direct/dev packages are not at latest.
  - No current package was reported as retracted or affected by a pub advisory.
  - 5 packages were reported as discontinued: direct `template_expressions`; transitive `build_resolvers`, `build_runner_core`, `js`, and `macros`.
- There are 14 direct git dependencies or forks in `.dart_tool/package_config.json`. Several have stale package metadata, old Android Gradle files, or low compile SDK values.

## Confirmed Upgrade Blockers

These were verified by running official Flutter 3.41.9 against a temporary copy at `/tmp/jhentai_flutter_3_41_9_check`; the real repository was not edited.

1. `flutter pub get` fails immediately because latest `flutter_test` pins `path 1.9.1`, while the project directly pins `path 1.9.0`.
2. After temporarily changing `path` to 1.9.1, `flutter pub get` fails because latest `flutter_localizations` pins `intl 0.20.2`, while the project directly pins `intl 0.19.0`.
3. After temporarily changing `intl` to 0.20.2, `template_expressions 3.2.0+7` becomes unsatisfiable because it depends on `intl ^0.19.0`.
4. After temporarily changing `template_expressions` to 3.3.1+2, `syncfusion_flutter_charts 27.1.48` becomes unsatisfiable because it requires `intl <0.20.0`.
5. After temporarily changing `syncfusion_flutter_charts` to 33.2.6, `flutter analyze` with Flutter 3.41.9 reports one compile-level Flutter API error:
   - `lib/src/config/theme_config.dart:23`: `DialogTheme` is no longer assignable to `DialogThemeData?` for `ThemeData.copyWith(dialogTheme: ...)`.
6. Android debug build initially fails with `Java heap space` during Jetifier transforms when using the project setting `org.gradle.jvmargs=-Xmx1536M`.
7. Raising Gradle heap to `-Xmx4096M` in the temporary copy allows Android debug build to succeed after the dependency/API probes above.

## Platform Minimum-Version Impact

Latest Flutter supported-platform docs state Flutter 3.41.x supports:

- Android API 24 to 36; API 23 and earlier are unsupported.
- iOS 13 to 26; iOS 12 and earlier are unsupported.
- macOS 10.15 and newer; 10.14 and earlier are unsupported.

Repository-specific impact:

- Android currently uses `minSdkVersion 21`. Flutter 3.41.9 build migration changed the temporary copy to `minSdkVersion flutter.minSdkVersion`, which resolves to the latest Flutter minimum, currently API 24. This drops Android 5/6 install support.
- iOS `Podfile` and Xcode project still target iOS 12.0. This is below latest Flutter support and should be raised to at least 13.0.
- macOS `Podfile` is 10.15, but `macos/Runner.xcodeproj/project.pbxproj` still contains several `MACOSX_DEPLOYMENT_TARGET = 10.14` entries. These should be normalized to 10.15+.

## Android Build Tooling Risks

The current Android files are usable enough to build a debug APK under Flutter 3.41.9 after the temporary dependency/API/heap fixes, but the toolchain is behind current Flutter templates:

- Current project:
  - Gradle 8.4
  - Android Gradle Plugin 8.3.1
  - Kotlin Gradle Plugin 2.0.20
  - compileSdk 35
  - targetSdk 34
  - Gradle heap 1536M
- Flutter 3.41.9 template constants:
  - Gradle 8.14
  - Android Gradle Plugin 8.11.1
  - Kotlin Gradle Plugin 2.2.20
  - compileSdk 36
  - targetSdk 36
  - minSdk 24
  - NDK 28.2.13676358

During the temporary Flutter 3.41.9 build, Flutter warned that project support for Gradle 8.4, AGP 8.3.1, and Kotlin 2.0.20 will soon be dropped. This is not an immediate hard blocker in 3.41.9, but it should be handled during the upgrade instead of deferred.

Additional plugin warnings:

- `http_proxy` Android plugin declares compileSdk 28; the root build script overrides it to 31.
- `system_network_proxy` Android plugin declares compileSdk 29; the root build script overrides it to 31.
- `flutter_windowmanager_plus` declares compileSdk 33 and Kotlin 1.7.10.
- `fluttertoast` declares compileSdk 33 and Kotlin 1.7.0.

These are not proven failures under the temporary debug build, but they are fragile under newer AGP/Kotlin/compileSdk combinations.

## Dependency Risks

High-risk dependency areas:

- `dependency_overrides` pins `test_api 0.6.0`, `matcher 0.12.16`, and `collection 1.19.0`, while Flutter 3.41.9 `flutter_test` uses `test_api 0.7.10`, `matcher 0.12.19`, and `collection 1.19.1`. Overrides can hide solver conflicts and produce unsupported test behavior.
- `template_expressions` is discontinued even after moving to 3.3.1+2. It should be replaced or isolated behind tests.
- `drift`/`drift_dev` are far behind latest. Current versions resolved under the temporary probe, but analyzer output adds experimental warnings around `TableMigration`; generated database code should be regenerated and reviewed if drift is upgraded.
- `syncfusion_flutter_charts` must move from 27.x to 33.x to satisfy latest Flutter localization pins; this is a major package jump and needs visual/chart regression testing.
- Many UI packages are several major versions behind (`pinput`, `screen_brightness`, `file_picker`, `share_plus`, `local_auth`, `webview_flutter`, `extended_image`, etc.). They are not all required for the SDK upgrade, but upgrading them all at once would substantially increase risk.
- Git forks make compatibility less predictable than hosted pub packages. Some git package `pubspec.yaml` files still claim old SDK ranges such as `<3.0.0`; current pub resolution still accepted them, but they are a maintenance risk.

## Flutter API / Deprecation Impact

Confirmed compile error:

- `ThemeData.copyWith(dialogTheme: DialogTheme(...))` must become `DialogThemeData(...)` on Flutter 3.41.9.

Not immediate errors, but latest analyzer reports new deprecations:

- `Color.withOpacity(...)` should migrate to `.withValues(alpha: ...)`.
- `Color.value` should migrate to component accessors or `toARGB32()`.
- `Radio.groupValue` / `Radio.onChanged` should migrate to `RadioGroup`.
- `ShowValueIndicator.always` should migrate to `ShowValueIndicator.onDrag`.

These should be fixed while the SDK upgrade branch is open to avoid accumulating future breakage.

## Validation Results

Commands run:

- Current SDK:
  - `flutter --version`
  - `dart --version`
  - `flutter doctor -v`
  - `flutter pub outdated --json`
  - `flutter pub get`
  - `flutter analyze`
- Official latest SDK in temp:
  - downloaded `flutter_linux_3.41.9-stable.tar.xz`
  - `/tmp/flutter_3_41_9/flutter/bin/flutter --version`
  - `/tmp/flutter_3_41_9/flutter/bin/flutter pub get`
  - `/tmp/flutter_3_41_9/flutter/bin/flutter analyze`
  - `/tmp/flutter_3_41_9/flutter/bin/flutter build apk --debug -t lib/src/main.dart`

Temporary probe changes required to reach a successful Android debug build:

- `path: 1.9.1`
- `intl: 0.20.2`
- `template_expressions: 3.3.1+2`
- `syncfusion_flutter_charts: 33.2.6`
- `DialogThemeData(...)` instead of `DialogTheme(...)`
- `org.gradle.jvmargs=-Xmx4096M`

Flutter 3.41.9 also auto-migrated the temporary Android app build file from `minSdkVersion 21` to `minSdkVersion flutter.minSdkVersion`.

## Recommended Upgrade Path

1. Create an upgrade branch and pin the target SDK version explicitly, preferably through the project’s usual version-management workflow.
2. Update the SDK-pinned package constraints first:
   - `path 1.9.1`
   - `intl 0.20.2`
   - `template_expressions 3.3.1+2` or replace it
   - `syncfusion_flutter_charts 33.2.6` or a verified compatible version
3. Remove or update unsafe `dependency_overrides`, especially `test_api`, `matcher`, and `collection`.
4. Apply the confirmed Flutter API fix in `theme_config.dart`.
5. Decide and document platform support changes:
   - Android minSdk 24
   - iOS deployment target 13.0+
   - macOS deployment target 10.15+
6. Raise Gradle heap before Android validation; then update Gradle/AGP/Kotlin toward current Flutter template versions.
7. Run focused validation:
   - `flutter pub get`
   - `flutter analyze`
   - `flutter build apk --debug -t lib/src/main.dart`
   - `flutter build apk --release -t lib/src/main.dart`
   - on macOS: `flutter build ios --no-codesign -t lib/src/main.dart` and `flutter build macos -t lib/src/main.dart`
8. Regression-test affected app areas:
   - chart pages
   - login/webview
   - share intent
   - downloads and database migrations
   - image reader gestures/zoom
   - Android app links/deep links
   - iOS/macOS build and permissions

