# Backend Development Guidelines

> Non-UI application-layer guidance for the JHenTai Flutter repository.

---

## How "Backend" Works In This Repo

JHenTai does not contain a separate deployable server backend. In this Trellis layer, `backend` means the non-UI Dart code that powers the Flutter app:

- long-lived services and persisted settings
- request clients and parsing flows
- Drift database schema, migrations, and DAOs
- shared models, enums, exceptions, utilities, and extensions

Primary source directories:

- `lib/src/service/`
- `lib/src/setting/`
- `lib/src/network/`
- `lib/src/database/`
- `lib/src/model/`
- `lib/src/utils/`
- `lib/src/extension/`
- `lib/src/consts/`, `lib/src/enum/`, `lib/src/exception/`

Use this layer when the task touches app lifecycle, persistence, networking, parsing, logging, or cross-page business behavior.

---

## Pre-Development Checklist

- Read [Directory Structure](./directory-structure.md) to place the change in the correct non-UI layer.
- Read [Quality Guidelines](./quality-guidelines.md) for lifecycle, generated-code, validation, and non-UI review rules.
- Read [Database Guidelines](./database-guidelines.md) before touching `lib/src/database/`, tables, DAOs, or migrations.
- Read [Error Handling](./error-handling.md) when adding network flows, migration work, parsing, or user-visible failure handling.
- Read [Logging Guidelines](./logging-guidelines.md) before adding logs or changing error reporting behavior.

Also read shared guides under `.trellis/spec/guides/` when the change crosses UI/service/database boundaries or introduces repeated helpers.

---

## Guidelines Index

| Guide | Use it when | Main files it explains |
|-------|-------------|------------------------|
| [Directory Structure](./directory-structure.md) | You need to decide where new non-UI code belongs | `lib/src/service/`, `setting/`, `network/`, `database/`, `model/`, `utils/` |
| [Database Guidelines](./database-guidelines.md) | You change Drift tables, DAOs, generated code, or migrations | `lib/src/database/database.dart`, `lib/src/database/table/`, `lib/src/database/dao/` |
| [Error Handling](./error-handling.md) | You add failure conversion, catches, user feedback, or retry behavior | `lib/src/network/eh_request.dart`, page logic catch blocks, migration code |
| [Quality Guidelines](./quality-guidelines.md) | You need the default non-UI constraints and verification commands | services, settings, request clients, shared helpers |
| [Logging Guidelines](./logging-guidelines.md) | You add or review logs, upload context, or sensitive data handling | `lib/src/service/log.dart` and callers |

---

## Working Rules

- Prefer the existing lifecycle model centered on `JHLifeCircleBean` and `lifeCircleBeans` in `lib/src/main.dart`.
- Keep non-UI rules source-backed. If a convention is not visible in code, tests, or repo docs, do not invent it here.
- Avoid leaking machine-local shell, proxy, or user-home configuration into this spec layer unless the repository itself requires it.
- Keep docs in English to match the rest of `.trellis/spec/`.
