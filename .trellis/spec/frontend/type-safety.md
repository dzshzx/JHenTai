# Type Safety

> Dart type usage and runtime conversion conventions.

---

## Overview

The project uses Dart 3 with null safety (`sdk: '>=3.11.5 <4.0.0'`) and Flutter `>=3.41.9`.

Prefer explicit models, enums, typed callbacks, and typed `Future<T>` APIs. The codebase uses generated Drift data types for database rows and hand-written model classes for domain objects.

---

## Type Organization

- Domain models live in `lib/src/model/`.
- Response value objects are grouped under domain subdirectories when needed, such as `model/jh_response/` and `model/archive_bot_response/`.
- Enums live in `lib/src/enum/` or near the feature when tightly scoped.
- Drift table row/companion types are generated from `lib/src/database/table/` definitions.
- Widget callback typedefs live near the widget when local, such as `ErrorTapCallback` and `NoDataTapCallback` in `loading_state_indicator.dart`.

---

## Validation

There is no dedicated runtime schema validation library.

Runtime conversion patterns are hand-written:

- Models expose `toJson()` and `factory fromJson(Map<String, dynamic> map)` where persisted or serialized.
- `Gallery.fromJson()` reconstructs nested values such as `GalleryUrl`, `GalleryImage`, and `LinkedHashMap<String, List<GalleryTag>>`.
- Settings parse persisted JSON maps in `applyBeanConfig()` and use defaults for missing fields.
- Request clients accept parser functions (`HtmlParser<T>`) and return typed `Future<T>`.

When adding parsing code, keep conversion close to the model or parser utility and handle missing legacy fields when persisted config/history may come from older versions.

---

## Common Patterns

- Use required named parameters for model/widget constructors when values must exist.
- Use nullable fields for genuinely absent E-Hentai fields. Examples in `Gallery` include `pageCount`, `favoriteTagIndex`, `language`, and `uploader`.
- Use enums plus indexes for persisted settings where existing settings already do so.
- Use generic request methods (`Future<T>`) when callers can supply a parser.
- Use Dart records for lightweight typed request payload groups where existing code uses them, such as `List<({int gid, String token})>`.

---

## Forbidden Patterns

- Do not pass raw `dynamic` maps through multiple layers when a model or typed record would make the contract explicit.
- Do not force-null (`!`) on data from network/persisted JSON unless the surrounding code has already validated it.
- Do not replace existing model classes with loosely typed maps in UI code.
- Do not edit generated Drift types manually.
- Do not ignore nullability differences from E-Hentai page modes; many model fields are intentionally nullable.
