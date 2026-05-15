# Database Guidelines

> Drift/SQLite conventions for local app persistence.

---

## Overview

The app uses Drift (`drift` and `drift_dev`) with SQLite. The database root is `lib/src/database/database.dart`:

- `AppDb extends _$AppDb`
- `schemaVersion => 23`
- `@DriftDatabase(tables: [...])` lists every active and migration table
- `AppDb appDb = AppDb();` is the global database singleton
- `database.g.dart` is generated and should not be edited manually

Tables live under `lib/src/database/table/`; DAOs live under `lib/src/database/dao/`. Services and page logic should call DAO/service methods instead of embedding ad hoc SQL in UI code.

---

## Query Patterns

Use Drift query APIs and the existing global `appDb`.

Examples:

- `GalleryGroupDao.selectGalleryGroups()` uses `appDb.select(appDb.galleryGroup)..orderBy(...)`.
- `GalleryGroupDao.insertGalleryGroup()` uses `appDb.into(...).insert(..., mode: InsertMode.insertOrIgnore)`.
- `LocalConfigService.write()` uses the Drift manager API with `InsertMode.insertOrReplace`.
- Batch writes use Drift bulk APIs, as in `LocalConfigService.batchWrite()`.

Keep database access asynchronous and return `Future<T>` from DAO/service methods. If a multi-step change must be atomic, wrap it in `appDb.transaction(() async { ... })`, as migration helpers do in `database.dart`.

---

## Migrations

All schema migrations belong in `AppDb.migration` in `lib/src/database/database.dart`.

When changing tables:

1. Update or add the table file in `lib/src/database/table/`.
2. Register the table in `@DriftDatabase(tables: [...])`.
3. Increment `schemaVersion`.
4. Add guarded migration code under `onUpgrade`, using `if (from < N)` checks.
5. Run `dart run build_runner build` to update `database.g.dart`.

With `build_runner` 2.15+, do not add `--delete-conflicting-outputs`; the option has been removed and is ignored. If generated outputs conflict, inspect why the tracked generated file is stale before deleting or regenerating it.

Migration helpers should be private methods on `AppDb` when logic is non-trivial, following `_migrateDownloadedInfo`, `_migrateSuperResolutionInfo`, and `_createGroupTable`.

Use `transaction()` for data migrations that read old rows and write replacement rows. Log and rethrow migration failures; when an error should not be uploaded, wrap it with `NotUploadException` following the existing `onUpgrade` pattern.

---

## Naming Conventions

- Table classes use PascalCase (`GalleryGroup`, `LocalConfig`).
- Explicit table names use the current database naming style. Some tables use snake case (`gallery_group`), while older columns may preserve existing camelCase names (`groupName`, `sortOrder`). Preserve existing names for compatibility.
- DAO files are named `<feature>_dao.dart`; DAO classes are named `<Feature>Dao`.
- Generated Drift data/companion classes (`GalleryGroupData`, `GalleryGroupCompanion`) are used directly at DAO boundaries.
- Index names are declared near their table definitions and created during migration, then protected with `.ignoreDuplicateIndex()` where needed.

---

## Common Mistakes

- Do not edit `lib/src/database/database.g.dart` manually.
- Do not add a table file without registering it in `@DriftDatabase`.
- Do not change `schemaVersion` without an `onUpgrade` path for existing users.
- Do not create database calls inside widgets; route them through logic, services, or DAOs.
- Do not silently swallow migration errors. Log context such as `from` and `to`, then rethrow or wrap intentionally.
- Do not rename existing table/column names for style consistency; app installs depend on the historical schema.
