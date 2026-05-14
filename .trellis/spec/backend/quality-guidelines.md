# Quality Guidelines

> Quality standards for non-UI Dart code.

---

## Overview

The project uses Flutter lints from `analysis_options.yaml` plus two explicit rules:

- `always_put_control_body_on_new_line`
- `unnecessary_lambdas`

Expected validation commands:

```bash
flutter analyze
flutter test
```

`CLAUDE.md` notes that no test directory files are currently present, so `flutter test` is mainly relevant when tests are added. Code generation uses:

```bash
dart run build_runner build
```

---

## Forbidden Patterns

- Do not bypass `JHLifeCircleBean` for singleton services/settings that need startup initialization.
- Do not instantiate duplicate long-lived services when a top-level singleton already exists.
- Do not embed network calls or database mutations directly in widgets.
- Do not manually edit generated files such as `lib/src/database/database.g.dart`.
- Do not add E-Hentai HTML parsing into request callers or UI code; use parser utilities.
- Do not call GetX `update()` directly from controllers where disposal is possible; use `updateSafely()`.
- Do not introduce a new dependency or fork when existing utilities/services cover the need.

---

## Required Patterns

- Register new lifecycle beans in `lifeCircleBeans` in `lib/src/main.dart`.
- Declare lifecycle dependencies via `initDependencies`; let `topologicalSort()` order startup.
- Use `JHLifeCircleBeanErrorCatch` for services that should log init/ready failures.
- Use `JHLifeCircleBeanWithConfigStorage` for persisted settings stored in the `local_config` table.
- Keep request timeout/cache/proxy behavior centralized in request clients and settings.
- Use translation keys with `.tr` for user-visible text generated from non-UI workflows.
- Prefer existing helpers in `lib/src/utils/` and `lib/src/extension/` before adding new utilities.

---

## Testing Requirements

For backend-layer changes, run the smallest relevant validation:

- Pure Dart/service/network/database changes: `flutter analyze`.
- Drift schema/table changes: `dart run build_runner build`, then `flutter analyze`.
- New or changed tests: `flutter test`.

When validation cannot run because Flutter/Dart tooling is unavailable, document the exact command attempted and the failure.

---

## Code Review Checklist

- Does the change fit an existing layer (`service`, `setting`, `network`, `database`, `model`, `utils`)?
- Are lifecycle dependencies complete and registered?
- Are errors converted/logged at the right layer and surfaced to users at the UI/logic layer?
- Are database schema changes migrated and generated code updated?
- Are user-visible strings localized through `.tr` or l10n files?
- Are credentials, cookies, and API secrets kept out of logs?
- Are parser-heavy or CPU-heavy response transformations kept out of the UI thread where existing code uses `isolateService`?
