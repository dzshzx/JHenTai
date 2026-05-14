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

- Flutter `3.24.5`
- Dart `3.5.4`
- Android SDK platform/build-tools `34`
- Java `17`

This project currently resolves with the locked `path 1.9.0` dependency. Newer Flutter SDKs may pin a newer `flutter_test` dependency set and fail `flutter pub get`; verify dependency resolution before changing the Flutter version.

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
