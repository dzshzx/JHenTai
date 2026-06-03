# Frontend Development Guidelines

> Flutter UI-layer guidance for JHenTai.

---

## What "Frontend" Means Here

This repository is a single Flutter app. In this Trellis layer, `frontend` means the user-facing Dart/UI surface:

- routed pages and layout shells
- reusable widgets and app wrappers
- route registration and side metadata
- page-local state wiring and GetX view updates
- localization and UI-facing config
- release packaging details that UI/platform work must respect

Primary source directories:

- `lib/src/pages/`
- `lib/src/widget/`
- `lib/src/routes/`
- `lib/src/l18n/`
- `lib/src/config/`
- `assets/`

Use this layer when the task changes page composition, widgets, layout behavior, route wiring, visible text, or platform packaging expectations.

---

## Pre-Development Checklist

- Read [Directory Structure](./directory-structure.md) to place page, widget, route, and layout work correctly.
- Read [State Management](./state-management.md) before changing `GetBuilder`, `Obx`, controller ownership, or page/global state boundaries.
- Read [Component Guidelines](./component-guidelines.md) before adding or reshaping widgets.
- Read [Hook Guidelines](./hook-guidelines.md) when you are about to extract reusable page behavior or add stateful helpers.
- Read [Quality Guidelines](./quality-guidelines.md) for validation commands, route rules, and UI review constraints.
- Read [Type Safety](./type-safety.md) if the UI touches JSON/model conversion or typed callback contracts.
- Read [Release Packaging](./release-packaging.md) when the task touches entrypoints, platform assets, or release build outputs.

Also read shared guides under `.trellis/spec/guides/` when a UI change spans routes, services, settings, and persistence together.

---

## Guidelines Index

| Guide | Use it when | Main files it explains |
|-------|-------------|------------------------|
| [Directory Structure](./directory-structure.md) | You need to place pages, widgets, routes, or layout code | `lib/src/pages/`, `widget/`, `routes/`, `config/`, `l18n/` |
| [Component Guidelines](./component-guidelines.md) | You are building or refactoring widgets | feature pages, reusable widgets, dialog/card helpers |
| [Hook Guidelines](./hook-guidelines.md) | You want reusable stateful behavior without React-style hooks | `lib/src/mixin/`, feature-local mixins, extensions, services |
| [State Management](./state-management.md) | You are deciding between page state, global settings, and services | `GetBuilder`, `Obx`, `Get.put`, `Get.find`, settings/services |
| [Quality Guidelines](./quality-guidelines.md) | You need the default UI constraints and verification commands | routed pages, layouts, widgets, settings screens |
| [Release Packaging](./release-packaging.md) | You touch app entrypoints, assets, or release packaging outputs | `.github/workflows/build_publish.yml`, `pubspec.yaml`, packaging scripts |
| [Type Safety](./type-safety.md) | You add typed models, callbacks, or conversion rules used by UI | `lib/src/model/`, enums, widget APIs, parser outputs |

---

## Working Rules

- Keep the UI mental model Flutter-native: pages, widgets, controllers, mixins, services, and settings. Do not translate the repo into React concepts.
- Route metadata in `lib/src/routes/routes.dart` is part of the UI contract, especially `EHPage.side` for tablet/desktop split behavior.
- Packaging guidance belongs here only when it affects the app entrypoint, assets, or published UI artifacts.
- Keep docs in English to match the rest of `.trellis/spec/`.
