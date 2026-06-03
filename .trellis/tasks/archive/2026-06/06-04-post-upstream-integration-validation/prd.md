# Post-upstream integration validation

## Goal

Verify that the completed upstream `8.0.13+311` integration is operational on the
fork's stable branch and that the local Android build environment requirements
are captured for repeatable future validation.

This is a lightweight post-merge validation task. It does not introduce new app
behavior; it checks the merged behavior and records the environment assumptions
needed to reproduce the build.

## Confirmed Facts

- `master` contains the upstream integration merge and has been pushed to
  `origin/master`.
- `flutter build apk --debug -t lib/src/main.dart` now succeeds and produces
  `build/app/outputs/flutter-apk/app-debug.apk`.
- The current shell proxy environment points HTTP/HTTPS/SOCKS traffic at
  `127.0.0.1:7897`.
- Gradle also has user-level proxy settings in `~/.gradle/gradle.properties`.
- The Android build path depends on repository/user Gradle mirror configuration
  because older dependency chains still touch Maven/JCenter-era artifacts.
- The highest-risk merged runtime surface is Archive Bot / Archive-at-Home
  behavior, especially preserving local proxy support for `ehArBot` without
  applying it to `archiveAtHome`.

## Requirements

- Confirm the post-merge Android debug build remains reproducible from the
  current `master`.
- Review the Archive Bot settings and request paths for the intended behavior:
  `ehArBot` can use the local JHenTai proxy server, while `archiveAtHome` uses
  its own API address and does not route through the local proxy toggle.
- Record the Android build environment assumptions that were necessary to get
  Gradle dependency resolution working in this WSL environment.
- Keep any repository changes documentation-only unless validation exposes a
  concrete code defect.

## Acceptance Criteria

- [x] `flutter build apk --debug -t lib/src/main.dart` completes successfully
  on the current branch.
- [x] Source review confirms Archive Bot settings persist and resolve API
  addresses according to the selected bot type.
- [x] Source review confirms Archive-at-Home request paths use
  `ArchiveBotConsts.archiveAtHomeXClient` headers and do not use
  `ArchiveBotConsts.proxyServerAddress`.
- [x] Build environment notes identify the effective proxy endpoint, Gradle
  proxy settings, and Maven mirror strategy used for this repository.
- [x] The final working tree contains only intentional task/documentation
  changes.

## Validation Record

- `flutter build apk --debug -t lib/src/main.dart` passed and produced
  `build/app/outputs/flutter-apk/app-debug.apk`.
- `flutter test` passed all tests in `test/smoke_test.dart`.
- `flutter analyze --no-pub` returned exit code 1 because the repository still
  has 125 existing info-level lint/deprecation findings; no new code was changed
  in this task.
- Source review covered `ArchiveBotSetting`, `ArchiveBotRequest`,
  `EHArchiveBotSettingDialog`, `ArchiveBotSettingsPage`,
  `archive_download_service`, and `schedule_service`.

## Out of Scope

- Changing Archive Bot product behavior beyond fixing a concrete regression.
- Resolving existing analyzer info-level findings.
- Creating a release build or publishing release assets.
- Moving all user-level Gradle configuration into the repository in this task.
