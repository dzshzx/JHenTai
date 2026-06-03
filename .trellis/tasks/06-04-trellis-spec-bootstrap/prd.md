# Refresh Trellis specs for JHenTai

## Goal

Write project-specific `.trellis/spec/` guidance for the JHenTai repository based on the current Flutter/GetX codebase, replacing remaining template language and correcting any rules that do not match the real structure.

## Scope

- Spec directory: `.trellis/spec/`
- Source directories to inspect:
  - `lib/src/`
  - `assets/`
  - platform folders used by packaging: `android/`, `linux/`, `windows/`, `macos/`
  - release helpers and metadata: `pubspec.yaml`, `README.md`, `altsource/`, local packaging scripts
- Tests to inspect:
  - `test/smoke_test.dart`
- Out of scope:
  - Product code changes outside `.trellis/spec/`
  - Trellis workflow or script changes outside task artifacts and spec docs

## Architecture Context

- This is a single Flutter/Dart application, not a multi-package repo and not a frontend/backend split deployment.
- `lib/src/main.dart` initializes a long-lived `lifeCircleBeans` graph before `runApp`, which is the main app bootstrap pattern for services and settings.
- UI code is concentrated under `lib/src/pages/`, `lib/src/widget/`, `lib/src/routes/`, `lib/src/l18n/`, and `lib/src/config/`.
- Non-UI application logic lives under `lib/src/service/`, `lib/src/setting/`, `lib/src/network/`, `lib/src/database/`, `lib/src/model/`, `lib/src/utils/`, `lib/src/extension/`, and related shared directories.
- Routing and page composition use GetX. Page-local state commonly follows `*_page.dart` + `*_logic.dart` + `*_state.dart` triplets, while global behavior is held in singleton services and settings.
- Local persistence uses Drift in `lib/src/database/`; release packaging targets multiple desktop/mobile platforms and uses `lib/src/main.dart` as the entrypoint.
- Existing spec docs already contain useful source-backed content, but both layer index files still contain template boilerplate and at least some guidance needs correction against the current repo.

## Files To Create Or Update

- `.trellis/spec/backend/index.md`
- `.trellis/spec/frontend/index.md`
- Any existing spec file whose guidance is inaccurate, weakly sourced, or still template-shaped
- Additional spec files only if the real repository structure requires them

## Rules

- Keep the spec tree aligned with the actual Trellis layer layout unless the existing split becomes actively misleading.
- Prefer concrete local patterns with file paths and symbols over generic Flutter advice.
- Remove placeholder or template-only prose.
- Preserve accurate existing guidance where it already matches the codebase.
- Do not modify product source code unless a spec claim cannot be verified without a tiny corrective change, in which case stop and reassess first.

## Acceptance Criteria

- [ ] Specs contain concrete examples and anti-patterns from this repository.
- [ ] No placeholder or template wording remains in `.trellis/spec/`.
- [ ] `index.md` files match the final spec file set and describe the real repo shape.
- [ ] Claims about routing, state, persistence, services, and packaging are backed by current source files or project docs.
- [ ] Any retained `backend` / `frontend` terminology is explained in the context of this Flutter monorepo shape.

## Notes

- Keep `prd.md` focused on requirements, constraints, and acceptance criteria.
- Lightweight tasks can remain PRD-only.
- For complex tasks, add `design.md` for technical design and `implement.md` for execution planning before `task.py start`.
