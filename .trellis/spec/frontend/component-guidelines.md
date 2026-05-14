# Component Guidelines

> Flutter widget construction patterns in this app.

---

## Overview

Widgets are plain Flutter widgets, usually `StatelessWidget`. They compose Material/Cupertino widgets, GetX builders, and project helpers from `UIConfig`, extensions, and `lib/src/widget/`.

Keep widgets focused on rendering and user interaction wiring. Business logic, network calls, persistence, and complex workflow state belong in `Logic`, services, or settings.

---

## Component Structure

Use the existing style:

- Constructor parameters are `final` fields.
- Prefer `const` constructors where possible.
- Keep `build()` readable by extracting private widget builder methods such as `_buildCover()`, `_buildTitle()`, or `_buildCard()`.
- Use typed callbacks instead of dynamic callback payloads.
- Use GetX `.tr` translation keys for user-visible text.

Examples:

- `LoadingStateIndicator` switches on `LoadingState` and accepts optional builders for state-specific rendering.
- `EHGalleryWaterFlowCard` accepts a `Gallery`, `ListMode`, and typed callbacks, then splits rendering into `_buildSmallCard`, `_buildMediumCard`, and `_buildBigCard`.
- `BasePage` wires shared scaffold/app bar/list/refresh/load-more structure and delegates page behavior to `BasePageLogic`.

---

## Props Conventions

Use explicit Dart types and required named parameters for essential inputs.

Examples:

```dart
const EHGalleryWaterFlowCard({
  Key? key,
  required this.gallery,
  required this.downloaded,
  required this.listMode,
  required this.handleTapCard,
  this.handleLongPressCard,
  this.handleSecondaryTapCard,
}) : super(key: key);
```

Optional behavior should be nullable or have a clear default. Avoid passing untyped `Map` payloads through widgets unless the existing API already does.

---

## Styling Patterns

Centralize shared sizes, colors, text styles, scroll behaviors, and animation durations in `UIConfig`.

Use:

- `Theme.of(context).colorScheme` through `UIConfig` helper methods for theme-aware colors.
- Existing widget extensions such as `.marginOnly()`, `.paddingOnly()`, `.center()`, and `.enableMouseDrag()` where the codebase already uses them.
- Existing list/card widgets before creating new visual variants.
- `styleSetting`/`readSetting` reactive values only where the UI needs to rebuild from global settings.

Do not introduce a separate styling system.

---

## Accessibility

The current code relies mostly on standard Flutter controls (`IconButton`, `ListTile`, dialogs, `Scaffold`, `AppBar`) for semantics. New custom gesture-only controls should prefer standard interactive widgets where practical, or add semantics/tooltips when the interaction is not obvious.

Desktop input patterns matter in this app:

- Preserve keyboard escape/fifth mouse button back behavior via `withEscOrFifthButton2BackRightRoute()` for right-side detail routes.
- Preserve mouse drag/scroll behavior through `UIConfig` scroll behaviors and `.enableMouseDrag()` where lists use horizontal/desktop interaction.

---

## Common Mistakes

- Do not put network or database calls in widget `build()` methods.
- Do not duplicate `BasePage` list behavior for gallery-list pages.
- Do not hard-code route strings or repeated UI constants in components.
- Do not create local text when a translation key already exists.
- Do not use reactive `Obx` for ordinary page-local state that is already controlled by `GetBuilder` and `updateSafely()`.
