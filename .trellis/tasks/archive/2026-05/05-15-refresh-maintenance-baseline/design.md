# Design

## Boundaries

This task is a maintenance-baseline refresh. It may edit project metadata, dependency manifests, workflow files, platform metadata, local packaging scripts, and narrow Dart code needed for analyzer compatibility. It should not intentionally change app features, database schema semantics, routes, or release artifact names beyond aligning existing documented policy.

## Toolchain Strategy

Use Flutter `3.41.9` as the authoritative baseline because it is already recorded in Trellis specs, CI, `.flutter-plugins-dependencies`, and the current lockfile SDK constraints. The default shell PATH currently points at Flutter `3.24.5`; validation commands should invoke:

```bash
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter
```

The repository should gain a lightweight local marker so future developers and agents do not accidentally use the older PATH Flutter. Prefer a marker such as `.fvmrc` plus README/spec notes over vendoring an SDK.

## Dependency Strategy

Apply dependency updates in tiers:

1. Pin existing git dependencies to the exact `resolved-ref` already in `pubspec.lock`.
2. Run dependency resolution with Flutter `3.41.9`.
3. Upgrade dev/build-time packages first when they remove discontinued transitive packages and generated-code warnings.
4. Upgrade direct runtime packages where constraints are compatible and API fallout is bounded.
5. Avoid package jumps that demand a Flutter/Dart version newer than `3.41.9`.

For Drift, keep `drift` and `drift_dev` aligned and regenerate `lib/src/database/database.g.dart` through `build_runner` instead of hand-editing generated output.

## Analyzer Strategy

Fix safe, localized analyzer issues first:

- stale unused imports and dead locals
- invalid `catchError` return handling
- duplicate map keys in l10n files when the duplicate value is clearly redundant
- deprecations with direct replacements, such as `Color.withOpacity` and `Color.value`, when mechanical

Do not rename public constants or localization class files merely to satisfy style lints; that can create a large behavioral and import churn. If style-only issues remain, record them rather than forcing a risky sweep.

## Platform and CI Strategy

CI remains the release source of truth. Update GitHub Actions major versions where compatible with existing workflow syntax. Android toolchain updates should be conservative: stay within the Flutter `3.41.9` supported range and avoid an AGP 9 migration unless the current build requires it.

Align platform metadata:

- `ios/Flutter/AppFrameworkInfo.plist` should match the iOS `13.0` target already set in Podfile/Xcode.
- `altsource/AltSource.json` should match the current app version/build metadata when safe, but no release is published.

Local scripts should mirror CI release commands and output layout for supported artifacts. Scripts that are legacy or unsupported should either be aligned or left clearly non-authoritative.

## Rollback

Dependency and generated-file changes are the primary rollback point. If an upgrade produces broad API breakage or build failure, roll back that package tier and keep the safer baseline changes: toolchain marker, SDK constraint, git ref pinning, metadata alignment, and CI action updates.
