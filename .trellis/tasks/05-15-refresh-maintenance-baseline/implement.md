# Implementation Plan

## Checklist

1. Re-read relevant frontend specs before code edits.
2. Add or update a project-local Flutter `3.41.9` marker and align SDK constraints.
3. Pin floating git dependencies using `pubspec.lock` `resolved-ref` values.
4. Run Flutter `3.41.9` dependency resolution and inspect lockfile changes.
5. Upgrade dependency tiers under Flutter `3.41.9`, starting with build/dev packages that can remove discontinued transitive packages.
6. Regenerate generated files when required by dependency upgrades with `dart run build_runner build`.
7. Fix analyzer issues that are safe and scoped.
8. Update CI action versions and conservative Android toolchain versions if compatible.
9. Align AltSource/iOS metadata and local packaging scripts with release policy.
10. Run validation and inspect diffs.
11. Run Trellis quality check, decide whether specs need updates, commit, and archive.

## Validation Commands

Use the Flutter `3.41.9` binary explicitly:

```bash
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter --version
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter pub get
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter pub outdated --json
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter analyze --no-pub
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter test
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter build apk --debug -t lib/src/main.dart
```

Run `flutter test` only if tests exist or Flutter creates a runnable test target; absence of tests should be recorded. Run the debug APK build after dependency/toolchain changes because Trellis quality guidelines require it after pub upgrades.

## Risky Files

- `pubspec.yaml`
- `pubspec.lock`
- `.dart_tool/package_config.json` and plugin metadata if regenerated locally, though ignored files should not be committed
- `lib/src/database/database.g.dart`
- `.github/workflows/build_publish.yml`
- Android Gradle files
- iOS/macOS platform files
- release helper scripts

## Review Gates

- Do not start implementation until `task.py start` marks the task `in_progress`.
- After dependency resolution, inspect `git diff --stat` and targeted diffs before continuing.
- If a dependency upgrade creates large app API breakage, prefer a smaller compatible upgrade set and document the blocker.
- Before commit, confirm no ignored build artifacts are accidentally tracked and no unrelated user changes were reverted.

## Validation Results

- `/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter --version`: Flutter `3.41.9`, Dart `3.11.5`.
- `/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter pub get`: passed under the project Flutter toolchain.
- `/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter pub outdated --json`: `0` discontinued packages, `0` current advisories, `19` direct packages still have newer latest versions intentionally left for compatibility/API-breakage reasons.
- `/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/dart run build_runner build`: passed with `build_runner` 2.15 syntax, no `--delete-conflicting-outputs`.
- `/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter analyze --no-pub --no-fatal-infos`: passed; strict analyzer still reports historical info-level style/deprecation items.
- `/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter test`: not runnable because the repository has no `test/` directory.
- `HTTP_PROXY=http://127.0.0.1:7897 HTTPS_PROXY=http://127.0.0.1:7897 ALL_PROXY=http://127.0.0.1:7897 /home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter build apk --debug -t lib/src/main.dart`: passed after stopping the stale Gradle daemon so the default `sqlite3` native asset hook inherited proxy settings.
