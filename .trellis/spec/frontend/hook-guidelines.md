# Hook Guidelines

> This is a Flutter/GetX project, so there are no React-style hooks. Shared stateful behavior is implemented with controllers, mixins, services, and widget/state extensions.

---

## Overview

Use the project's existing alternatives to hooks:

- `GetxController` subclasses named `*Logic` for page workflow logic.
- Mutable `*State` classes for page state containers.
- Mixins under `lib/src/mixin/` for reusable logic/state/page behavior.
- Services under `lib/src/service/` for cross-page application behavior.
- Extensions under `lib/src/extension/` for small reusable Flutter/GetX helpers.

---

## Custom Hook Patterns

For reusable page behavior, prefer paired mixins when state and logic are both needed.

Examples:

- `Scroll2TopLogicMixin`, `Scroll2TopStateMixin`, and `Scroll2TopPageMixin` split scroll-to-top behavior across controller, state, and widget.
- Read-page layout classes use base layout logic/state classes and layout-specific files instead of local hook functions.
- Download pages use mixins under `lib/src/pages/download/mixin/` to share grid/list/multi-select behavior.

For one-off controller safety, use extensions:

- `GetLogicExtension.updateSafely()` guards `GetxController.update()` against closed controllers.
- `StateExtension.setStateSafely()` guards Flutter `setState()` against unmounted state objects.

---

## Data Fetching

Data fetching belongs in `Logic` classes and services, not in widgets.

Examples:

- `BasePageLogic.getGalleryPage()` calls `ehRequest.requestGalleryPage(...)`.
- `FavoritePageLogic.handleChangeSortOrder()` handles dialog result, request call, error feedback, state reset, and reload.
- Request clients parse responses through parser functions, often on `isolateService`, before returning typed data.

Controllers should set `LoadingState`, call request/service methods, handle `DioException`/`EHSiteException`, update state, and then call `updateSafely()` with appropriate IDs.

---

## Naming Conventions

- Page controller files use `<feature>_logic.dart`; classes end in `Logic`.
- Page state files use `<feature>_state.dart`; classes end in `State`.
- Reusable mixins live in `lib/src/mixin/` or feature-local `mixin/` directories and end in `Mixin`.
- GetBuilder update IDs are string fields on logic classes (`bodyId`, `loadingStateId`, etc.) or derived strings for repeated items.

---

## Common Mistakes

- Do not add React-style hook libraries or hook naming.
- Do not store page workflow state directly in widgets when a `State` class exists.
- Do not fetch data from widget `build()`.
- Do not duplicate mixin behavior locally without checking `lib/src/mixin/` and feature `mixin/` directories first.
- Do not call `update()` after async work without using `updateSafely()`.
