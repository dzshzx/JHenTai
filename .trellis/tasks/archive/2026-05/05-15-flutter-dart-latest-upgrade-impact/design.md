# Safe Flutter/Dart Upgrade Design

## Target

Upgrade the project to Flutter 3.41.9 stable with bundled Dart 3.11.5 using the smallest dependency and source changes needed to restore dependency resolution, analysis, and Android debug build.

## Isolation Model

Use a separate upgrade worktree as the implementation surface:

- Worktree path: `~/upgrade-sandbox/jhentai/worktree`
- Branch: `chore/flutter-3.41`
- Flutter SDK path: `~/upgrade-sandbox/jhentai/flutter` or reuse `/tmp/flutter_3_41_9/flutter` only if the user accepts a temporary SDK location
- `PUB_CACHE`: `~/upgrade-sandbox/jhentai/pub-cache`
- `GRADLE_USER_HOME`: `~/upgrade-sandbox/jhentai/gradle`
- Optional isolated Android SDK: `~/upgrade-sandbox/jhentai/android-sdk`

The primary worktree remains available for normal work and keeps planning artifacts. Application changes happen in the upgrade worktree after approval.

## Upgrade Boundaries

### In Scope

- SDK compatibility dependency updates proven by research:
  - `path: 1.9.1`
  - `intl: 0.20.2`
  - `template_expressions: 3.3.1+2` unless replacement is required by tests
  - `syncfusion_flutter_charts: 33.2.6` or another compatible version that supports `intl 0.20.2`
- Review and reduce unsafe `dependency_overrides`, especially `test_api`, `matcher`, and `collection`.
- Flutter API compatibility fix:
  - `DialogTheme(...)` to `DialogThemeData(...)` in `lib/src/config/theme_config.dart`.
- Platform minimums required by latest Flutter:
  - Android minSdk 24
  - iOS deployment target 13.0+
  - macOS deployment target 10.15+
- Android build stability:
  - Raise Gradle heap to avoid Jetifier `Java heap space`.
  - Update Gradle / Android Gradle Plugin / Kotlin Gradle Plugin toward Flutter 3.41.9 template guidance if needed for a warning-free supported build.
- Regenerate lockfile with the target Flutter SDK.

### Out of Scope

- Broad modernization of all outdated packages.
- Replacing every git fork with hosted packages.
- Large UI refactors for deprecations such as `RadioGroup` and `Color.withValues`, unless they become compile errors.
- Database schema redesign.

## Dependency Strategy

The dependency update should proceed in layers:

1. SDK-pinned package conflicts first.
2. Overrides cleanup second.
3. Platform plugin and Gradle compatibility third.
4. Optional package modernization only when required by a build failure.

This keeps failures attributable. A package should not be upgraded merely because a newer version exists.

## Platform Strategy

Android API 21 support conflicts with latest Flutter support floors. The clean path is to accept API 24 as the new minimum. If Android 21-23 support must be retained, the project cannot safely target latest Flutter and should instead pin an older Flutter version.

iOS 12 support also conflicts with latest Flutter support floors. The clean path is iOS 13+.

macOS must be normalized to 10.15+ because the Podfile already uses 10.15 but the Xcode project still contains 10.14 entries.

## Rollback

Rollback is straightforward because code changes happen in a separate worktree/branch. If dependency resolution or platform build becomes unstable, remove the worktree and branch after preserving logs:

```bash
git worktree remove ~/upgrade-sandbox/jhentai/worktree
git branch -D chore/flutter-3.41
```

Do not delete shared global caches as part of rollback; isolated caches can be deleted under `~/upgrade-sandbox/jhentai/`.

## Risk Notes

- `template_expressions` remains discontinued even at 3.3.1+2. This is acceptable as a short-term compatibility step only if the app paths using it still work.
- `syncfusion_flutter_charts` jumps from 27.x to 33.x and needs focused chart regression testing.
- Android plugin forks with old compileSdk/Kotlin metadata may become the next failure point when Gradle/AGP/Kotlin are raised.
- The current codebase already has analyzer warnings on Flutter 3.24.5; success should distinguish pre-existing warnings from new compile errors.
