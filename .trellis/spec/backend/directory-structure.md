# Directory Structure

> Non-UI application code in this Flutter app: services, settings, network, database, models, parsers, utilities, and platform helpers.

---

## Overview

JHenTai is a single Flutter/Dart app. There is no separate server backend in this repository; "backend" guidelines refer to the non-UI application layer under `lib/src/`.

Use existing layer directories before adding new ones:

- `lib/src/service/` contains long-lived singleton feature services and app lifecycle beans.
- `lib/src/setting/` contains persisted singleton setting modules.
- `lib/src/network/` contains Dio request clients, cookie/cache managers, and request interceptors.
- `lib/src/database/` contains Drift tables, DAOs, migrations, and generated database code.
- `lib/src/model/` contains domain/value models and JSON conversion logic.
- `lib/src/consts/`, `lib/src/enum/`, `lib/src/exception/`, `lib/src/utils/`, and `lib/src/extension/` contain shared constants, enums, errors, helpers, and Dart extensions.

---

## Directory Layout

```text
lib/src/
├── consts/       # EH/JH/archive/locale constants
├── database/     # Drift AppDb, table definitions, DAOs, generated database.g.dart
├── enum/         # App enum definitions used across layers
├── exception/    # Domain exception types
├── extension/    # Dart/Flutter/GetX extension helpers
├── model/        # Domain models and response value objects
├── network/      # Dio request clients, interceptors, cookie/cache/ip helpers
├── service/      # Singleton application services
├── setting/      # Singleton persisted settings
└── utils/        # Parsers, file/proxy/date/cookie/string utility functions
```

Platform host code lives in Flutter platform directories (`android/`, `ios/`, `linux/`, `macos/`, `windows/`). Do not place Dart application logic in those directories unless it is platform integration code.

---

## Module Organization

New long-lived services must follow the `JHLifeCircleBean` pattern from `lib/src/service/jh_service.dart`.

- Declare a top-level singleton, for example `LogService log = LogService();`.
- Implement `JHLifeCircleBean` and provide `initDependencies`, `initBean()`/`doInitBean()`, and `afterBeanReady()`/`doAfterBeanReady()`.
- Add the singleton to `lifeCircleBeans` in `lib/src/main.dart`; startup order is handled by `topologicalSort()`.
- Put persisted app settings in `lib/src/setting/`, not in page state.

Network calls are centralized in request clients:

- E-Hentai/EXHentai calls go through `EHRequest` in `lib/src/network/eh_request.dart`.
- JHenTai backend calls go through `JHRequest` in `lib/src/network/jh_request.dart`.
- Archive bot calls go through `ArchiveBotRequest`.
- HTML parsing belongs in parser utilities such as `lib/src/utils/eh_spider_parser.dart`, not in widgets.

Database additions are split by Drift responsibility:

- Tables: `lib/src/database/table/<feature>.dart`
- DAOs: `lib/src/database/dao/<feature>_dao.dart`
- Schema registration and migrations: `lib/src/database/database.dart`
- Generated code: `lib/src/database/database.g.dart` from `dart run build_runner build`

---

## Naming Conventions

- Dart files use `snake_case.dart`.
- Singleton service files use `<feature>_service.dart`; the exported singleton uses lower camel case, for example `localConfigService`.
- Setting files use `<feature>_setting.dart`; the exported singleton uses lower camel case, for example `networkSetting`.
- Request clients use `<domain>_request.dart`, for example `eh_request.dart` and `jh_request.dart`.
- Drift table classes use PascalCase (`GalleryGroup`), while explicit table names use the existing database naming style (`gallery_group`).
- DAO classes use PascalCase plus `Dao` and expose static methods around `appDb`.

---

## Examples

- `lib/src/service/jh_service.dart` defines `JHLifeCircleBean`, error-catching lifecycle mixins, and config-backed lifecycle mixins.
- `lib/src/main.dart` registers all lifecycle beans in `lifeCircleBeans` and initializes them before `runApp`.
- `lib/src/network/eh_request.dart` owns Dio configuration, cookie/cache interceptors, domain fronting, request wrappers, and parser isolation.
- `lib/src/database/database.dart` owns `AppDb`, schema version `23`, migrations, `appDb`, and SQLite connection setup.
- `lib/src/database/dao/gallery_group_dao.dart` is a compact DAO example using Drift query builders against `appDb`.
