# Refresh project maintenance baseline

## Goal

Bring the project maintenance baseline back into a coherent, reproducible state based on the update audit from 2026-05-15. Handle the highest-priority items first, then the secondary maintenance items, without changing product behavior intentionally.

## Confirmed Facts

- The repository is a Flutter app with release entrypoint `lib/src/main.dart`.
- The working tree was clean before task creation.
- The project Trellis spec names Flutter `3.41.9`, Dart `3.11.5`, Java `17`, Android SDK `36`, and release packaging via `.github/workflows/build_publish.yml` as the current baseline.
- The local default `flutter` on PATH is `3.24.5`, while an available project-compatible toolchain exists at `/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter` and reports Flutter `3.41.9`.
- `pubspec.lock` requires Dart `>=3.9.0-0 <4.0.0` and Flutter `>=3.35.1`, while `pubspec.yaml` currently declares Dart `>=3.0.0 <4.0.0`.
- `flutter pub outdated --json` under Flutter `3.41.9` reports many direct, dev, and transitive updates, no current advisory/retracted packages, and discontinued transitive packages `build_resolvers`, `build_runner_core`, and `js`.
- Several git dependencies in `pubspec.yaml` float on branch/default refs while `pubspec.lock` records concrete `resolved-ref` commits.
- `flutter analyze --no-pub` under Flutter `3.41.9` currently fails with analyzer issues, including warnings and newer API deprecations.
- Release metadata differs: `pubspec.yaml` is `8.0.12+309`, while `altsource/AltSource.json` still points to `8.0.12+308` and has an empty `buildVersion`.
- iOS deployment metadata differs: Podfile/Xcode target use iOS `13.0`, while `ios/Flutter/AppFrameworkInfo.plist` declares `12.0`.
- CI uses older Actions versions in `.github/workflows/build_publish.yml`.

## Requirements

- Highest-priority updates must be addressed before secondary updates:
  - Align developer toolchain discovery so project commands consistently use or document Flutter `3.41.9`.
  - Update Dart/Flutter SDK constraints in `pubspec.yaml` to match the lockfile/toolchain baseline.
  - Pin floating git dependencies to immutable refs from `pubspec.lock`, unless evidence shows a dependency should intentionally stay floating.
  - Refresh dependency declarations/lockfile enough to remove stale discontinued transitive packages where feasible under Flutter `3.41.9`.
- Secondary updates must be addressed after the highest-priority baseline is stable:
  - Reduce analyzer failures by fixing current warnings/deprecations that are safe and mechanical.
  - Update CI workflow action versions where compatible.
  - Evaluate Android Gradle/AGP/Kotlin updates conservatively and apply only versions compatible with Flutter `3.41.9`.
  - Align release metadata and iOS minimum version metadata.
  - Align local packaging scripts with the CI release-packaging policy where they are stale.
- Preserve application behavior unless a compatibility update requires a small documented adjustment.
- Do not rewrite unrelated code or broad architecture.
- Use `lib/src/main.dart` for Flutter validation/build commands.
- Keep Trellis specs updated if this work discovers durable maintenance rules.

## Acceptance Criteria

- [x] A project-local toolchain marker or documented command path makes the Flutter `3.41.9` baseline explicit for developers.
- [x] `pubspec.yaml`, `pubspec.lock`, and generated dependency metadata resolve cleanly under Flutter `3.41.9`.
- [x] Floating git dependencies targeted by this task are pinned to immutable refs or explicitly documented as intentionally floating.
- [x] `flutter pub outdated --json` no longer reports the previously noted discontinued transitive packages if dependency updates can resolve them without incompatible toolchain jumps; otherwise the remaining blocker is documented.
- [x] `flutter analyze --no-pub` under Flutter `3.41.9` has materially fewer issues and no newly introduced high-risk analyzer warnings from this work.
- [x] CI workflow action versions are updated where safe.
- [x] Release metadata and iOS minimum deployment metadata are internally consistent.
- [x] Packaging helper scripts no longer contradict the authoritative CI release commands for supported artifacts.
- [x] Relevant validation commands are run and their outcomes are recorded.
- [x] Trellis finish flow is completed through quality verification and spec update; commit/archive are handled in Phase 3.4/3.5.

## Out of Scope

- Product feature changes.
- Full migration to Flutter newer than `3.41.9`.
- Full AGP 9.x migration unless required by a verified compatibility issue.
- Publishing a release or pushing tags.
- Rewriting the state-management architecture or generated database layer by hand.

## Open Questions

- None blocking. The user explicitly asked to handle the audit recommendations in priority order and follow the full Trellis flow.
