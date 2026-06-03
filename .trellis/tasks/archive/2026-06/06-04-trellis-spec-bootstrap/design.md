# Design: Refresh Trellis specs for JHenTai

## Goal

Refresh `.trellis/spec/` so future agents see the current JHenTai architecture instead of a generic template or a misleading web-app mental model.

## Constraints

- Keep changes localized to task artifacts and `.trellis/spec/`.
- Respect the existing Trellis layer navigation unless evidence shows it should be replaced.
- Do not invent conventions that are not visible in source, tests, or repository docs.

## Repository Shape

- Single-repo Flutter application.
- UI-heavy layer:
  - `lib/src/pages/`
  - `lib/src/widget/`
  - `lib/src/routes/`
  - `lib/src/l18n/`
  - `lib/src/config/`
- Non-UI application layer:
  - `lib/src/service/`
  - `lib/src/setting/`
  - `lib/src/network/`
  - `lib/src/database/`
  - `lib/src/model/`
  - `lib/src/utils/`
  - `lib/src/extension/`
  - `lib/src/consts/`, `lib/src/enum/`, `lib/src/exception/`

## Key Patterns To Capture

### App bootstrap and lifecycle

- `lib/src/main.dart` owns startup.
- Long-lived services/settings implement `JHLifeCircleBean`.
- Initialization order is declared through `initDependencies` and resolved by `topologicalSort()`.

### Page structure and UI state

- GetX routing and injection are the dominant UI architecture.
- Many feature pages follow page/logic/state triplets.
- Shared behavior is extracted into base page classes, mixins, and reusable widgets instead of ad hoc widget-local state.

### Global settings and services

- Settings under `lib/src/setting/` persist user preferences and frequently expose Rx values.
- Services under `lib/src/service/` hold cross-page workflow and long-lived app behavior.

### Networking and parsing

- Dio clients are centralized in `lib/src/network/`.
- Request parsing is pushed into parser and utility code, sometimes via isolate-backed flows.

### Local persistence

- Drift tables, DAOs, migrations, and generated code are split across `lib/src/database/`.
- `schemaVersion`, migration guards, and generated `database.g.dart` are authoritative.

### Release and platform packaging

- `lib/src/main.dart` is the non-default Flutter entrypoint.
- Packaging spans Android, iOS, Windows, macOS, Linux, release metadata, and helper scripts.

## Spec Structure Decision

- Keep `.trellis/spec/backend/` and `.trellis/spec/frontend/` because the repo is already configured with these Trellis layers.
- Reinterpret them explicitly:
  - `frontend`: Flutter UI, page composition, routing, layout, state wiring, translation, and packaging rules visible to UI-facing work.
  - `backend`: non-UI app layer inside the same Flutter repo, including services, settings, network, database, models, utilities, and error/logging patterns.
- Remove or rewrite any language that implies a separate server backend or React frontend.

## Expected Edits

- Rewrite both layer `index.md` files from template form into repo-specific navigation docs.
- Tighten individual spec files where claims are stale, generic, or contradicted by the codebase.
- Delete or rename a spec file only if it cannot be explained against Flutter/GetX patterns. Current evidence suggests `hook-guidelines.md` can remain if framed as “GetX/mixin alternatives to hooks”.

## Verification

- Search `.trellis/spec/` for placeholder text.
- Read final index files plus touched spec docs for internal consistency.
- Optionally run markdown lint or a simple grep-based consistency pass if a repo-local command exists and is lightweight.
