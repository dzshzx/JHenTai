# State Management

> GetX state management conventions.

---

## Overview

GetX is used for routing, dependency injection, state management, and i18n.

The dominant page pattern is:

- `GetBuilder<T>` plus manual `updateSafely()` for page-local controller state.
- `.obs`/`Rx` values for settings and global values that must rebuild multiple views.
- `Get.put()` and `Get.find()` for page logic/controller registration and lookup.

`CLAUDE.md` explicitly notes that widgets use `GetBuilder<T>` rather than broad reactive `.obs` streams for normal page state.

---

## State Categories

Page-local state:

- Lives in `*State` classes.
- Is mutated by `*Logic` controllers.
- Rebuilds through `GetBuilder` IDs and `updateSafely()`.
- Example: `BasePageState` stores `gallerys`, `prevGid`, `nextGid`, `seek`, `totalCount`, and `LoadingState`.

Global settings:

- Live in `lib/src/setting/`.
- Use `Rx`, `RxBool`, `RxInt`, `RxnString`, `RxMap`, etc.
- Persist through `JHLifeCircleBeanWithConfigStorage` and `localConfigService`.
- Example: `StyleSetting` stores theme, list mode, layout, and per-route list mode as reactive values.

Cross-page services:

- Live in `lib/src/service/`.
- May extend `GetxController` when UI listens to service state through `GetBuilder`.
- Follow lifecycle initialization when they are long-lived app services.

---

## When to Use Global State

Use global reactive setting/service state only when:

- The value is user preference/configuration persisted across app launches.
- Multiple unrelated pages need to observe the same value.
- The value drives app shell behavior, theme, layout, download/service progress, or reading behavior.

Keep temporary page workflow state local to the page `State` object. For example, a gallery page's pagination cursors and loading state stay in `BasePageState`; they are not promoted to global settings.

---

## Server State

Server/remote data is fetched through request clients and stored in page state, services, Drift, or caches depending on lifetime:

- Gallery lists are fetched by `BasePageLogic` and kept in page state.
- E-Hentai page cache behavior is managed by `EHCacheManager` inside `EHRequest`.
- Downloaded/local/archive metadata is persisted through Drift tables and DAO/service methods.
- Config/settings sync goes through `JHRequest` and setting/services.

Use `LoadingState` to represent UI fetch state: `idle`, `loading`, `error`, `noData`, `noMore`, and `success`.

---

## Common Mistakes

- Do not convert ordinary page-local fields to `.obs` unless multiple independent widgets must react outside `GetBuilder`.
- Do not mutate global settings without saving through the setting's `save*` method.
- Do not call `Get.put()` repeatedly for permanent singleton-like page controllers unless the existing page pattern does so.
- Do not forget targeted update IDs for large/repeated widgets; rebuilding everything is often unnecessary.
- Do not update state after async work without handling closed controllers.
