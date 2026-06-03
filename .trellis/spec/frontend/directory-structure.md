# Directory Structure

> Flutter UI organization for pages, widgets, layouts, routes, themes, and localization.

---

## Overview

Frontend code lives mainly under:

- `lib/src/pages/` for routed screens and page-specific GetX logic/state.
- `lib/src/widget/` for reusable widgets, dialogs, cards, and app-wide wrappers.
- `lib/src/routes/` for route names and `EHPage` metadata.
- `lib/src/config/` for theme, UI constants, API secret config, and other app-level UI/runtime config files.
- `lib/src/l18n/` for GetX translations.
- `assets/` and platform asset folders for static resources.

The app supports mobile, tablet, and desktop layouts. Layout-specific pages live under `lib/src/pages/layout/`.

---

## Directory Layout

```text
lib/src/
├── pages/
│   ├── base/          # Shared gallery-list page base classes
│   ├── layout/        # mobile_v2, tablet_v2, desktop shells
│   ├── read/          # reader page and reader layouts
│   ├── search/        # mobile/desktop/quick search pages and mixins
│   ├── setting/       # settings screens grouped by settings area
│   └── <feature>/     # feature page, logic, state triplets
├── widget/            # Reusable EH-prefixed widgets and dialogs
├── routes/            # Routes and EHPage metadata
├── config/            # UIConfig, ThemeConfig, app config
└── l18n/              # GetX Translations and locale maps
```

---

## Module Organization

Most feature pages use a three-file pattern:

- `<feature>_page.dart`: widget composition only.
- `<feature>_logic.dart`: `GetxController` subclass with business/UI logic.
- `<feature>_state.dart`: mutable state object.

Example: `lib/src/pages/favorite/` contains `favorite_page.dart`, `favorite_page_logic.dart`, and `favorite_page_state.dart`.

Shared gallery-list behavior belongs in `lib/src/pages/base/`. `BasePageLogic` owns loading, pagination, refresh, search config persistence, tag translation, and local blocking. Feature pages override methods such as `getGalleryPage()` instead of duplicating the list workflow.

Reusable UI belongs in `lib/src/widget/`. Use existing widgets such as `EHGalleryCollection`, `LoadingStateIndicator`, `EHImage`, `EHGalleryWaterFlowCard`, and dialogs before adding new one-off widgets.

---

## Naming Conventions

- Dart files use `snake_case.dart`.
- Page widgets use PascalCase and end in `Page`.
- Logic/controller classes end in `Logic`.
- State classes end in `State`.
- Reusable app widgets usually use an `EH` prefix (`EHImage`, `EHAlertDialog`, `EHGalleryWaterFlowCard`).
- Route constants live on `Routes` in `lib/src/routes/routes.dart`; do not hard-code route strings in pages.
- Settings routes use the existing `/setting_*` or nested `/setting_area/detail` convention.

---

## Examples

- `lib/src/pages/base/base_page.dart` and `base_page_logic.dart` define the shared gallery-list page contract.
- `lib/src/pages/favorite/` is a compact feature-page triplet.
- `lib/src/pages/layout/mobile_v2/`, `tablet_v2/`, and `desktop/` show layout-specific shells.
- `lib/src/routes/routes.dart` centralizes route constants and `EHPage` registration.
- `lib/src/config/ui_config.dart` centralizes UI sizes, colors, scroll behaviors, and component constants.
