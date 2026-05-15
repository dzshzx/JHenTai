# Quality Guidelines

> UI code quality standards.

---

## Overview

Use the existing Flutter/GetX patterns and validate with:

```bash
flutter analyze
flutter test
```

The active lint configuration is `package:flutter_lints/flutter.yaml` plus `always_put_control_body_on_new_line` and `unnecessary_lambdas`.

## Toolchain

Use the Flutter toolchain version that matches the checked-in dependency lock:

- Flutter `3.41.9`
- Dart `3.11.5`
- Android SDK platform `36` for compilation; target SDK follows `flutter.targetSdkVersion`
- Android minimum SDK follows `flutter.minSdkVersion` (API 24 for Flutter 3.41.9)
- Java `17`

This project currently resolves with the locked `path 1.9.1`, `intl 0.20.2`, `test_api 0.7.10`, and `matcher 0.12.19` dependency set from Flutter 3.41.9. Verify dependency resolution before changing the Flutter version.

## Dependency Maintenance

- Keep git dependencies on immutable refs when the checked-in lock depends on the Flutter `3.41.9` / Dart `3.11.5` toolchain. Floating branches can move to a newer SDK constraint and make `flutter pub get`, `flutter pub upgrade`, and `flutter pub outdated` fail even though the lockfile previously resolved.
- When a git dependency is intentionally kept at the lockfile revision, copy `resolved-ref` from `pubspec.lock` into the dependency's `ref` in `pubspec.yaml`.
- After running `flutter pub upgrade`, run `flutter build apk --debug -t lib/src/main.dart`. The app entrypoint is `lib/src/main.dart`, not the Flutter default `lib/main.dart`.
- For release artifacts, follow `release-packaging.md`; debug APKs are validation artifacts and must not be published as platform release packages.
- Prefer proxy transport for dependency downloads and future build-network requests. In this WSL environment, Gradle user config uses `127.0.0.1:7897`; if an official endpoint fails through that proxy, switch that repository path to a mirror and prefer university mirrors before commercial mirrors. The current Gradle order keeps Flutter's official Maven repository first, then the NJU Flutter mirror, the Flutter China mirror, official `google()`, NJU Maven, and Aliyun Maven mirrors. Flutter Maven repositories must be content-filtered to `io.flutter` so Kotlin/AGP dependencies do not waste time probing Flutter storage. Keep `google()` before NJU Maven, and restrict NJU Maven to JetBrains/Kotlin and Android tools groups, because some Android AAR modules can resolve metadata from NJU while their AAR artifacts are unavailable there. It intentionally avoids `mavenCentral()` / `gradlePluginPortal()` because Maven Central returns HTTP 403 through the proxy. Mirror hosts may be added to Gradle `nonProxyHosts` after proxy validation fails or stalls; use short Gradle HTTP timeouts so a slow university mirror can fall through to commercial fallback mirrors instead of blocking the build. Keep `android/settings.gradle`, `android/build.gradle`, and the user-level `~/.gradle/init.d/jhentai-maven-mirrors.gradle` script in sync so app, plugin, and Flutter included Gradle builds resolve dependencies the same way.

---

## Forbidden Patterns

- Do not put business logic, HTTP calls, or database writes in widget `build()` methods.
- Do not duplicate shared page behavior from `BasePage`, download mixins, read layout bases, or existing widgets.
- Do not hard-code route strings; use `Routes`.
- Do not hard-code shared colors, dimensions, or scroll behavior when `UIConfig` already owns them.
- Do not add user-visible strings without checking l10n keys and `.tr` usage.
- Do not rebuild large UI regions with untargeted updates when an update ID exists.
- Do not introduce another state management package for ordinary app state.

---

## Required Patterns

- Follow the `*_page.dart`, `*_logic.dart`, `*_state.dart` structure for new routed pages unless the feature is clearly tiny.
- Register new routes in `lib/src/routes/routes.dart` as `Routes` constants and `EHPage` entries.
- Set the correct `EHPage.side` for tablet/desktop split behavior.
- Use `GetBuilder` and `updateSafely()` for page-local state.
- Use `Obx` for global reactive settings that need cross-view rebuilds.
- Use `LoadingStateIndicator` or existing loading/error/no-data patterns for async UI.
- Use `withEscOrFifthButton2BackRightRoute()` for right-side detail/settings routes that should close with Escape or the fifth mouse button.

---

## Testing Requirements

For frontend changes:

- Run `flutter analyze` for any Dart UI change.
- Run `flutter test` when tests exist or when adding tests.
- Manually inspect layout behavior for mobile/tablet/desktop when changing shared layout, route side metadata, card dimensions, read layouts, or settings pages.

If Flutter tooling is unavailable in the environment, record the failed command and reason.

---

## Code Review Checklist

- Does the page fit the existing page/logic/state split?
- Is state local or global for a clear reason?
- Are async states represented with `LoadingState` and user feedback?
- Are routes centralized and assigned to the correct `Side`?
- Are UI constants pulled from `UIConfig` or an existing local convention?
- Are translated strings used for visible text?
- Are desktop interactions and scroll behaviors preserved?
- Are new widgets typed, const-friendly, and free of workflow side effects in `build()`?
