# Logging Guidelines

> Logging conventions around `LogService`.

---

## Overview

Logging is centralized in `lib/src/service/log.dart`.

The app uses the `logger` package through a top-level singleton:

```dart
LogService log = LogService();
```

`LogService` initializes console and file loggers lazily. It writes verbose logs and, when verbose logging is enabled, warning/error and download-specific files under the app visible directory's `logs` folder.

---

## Log Levels

Use the wrapper methods instead of instantiating `Logger` directly:

- `log.trace(...)`: parameter-heavy actions and very low-level diagnostics.
- `log.debug(...)`: invisible internal state changes and successful lifecycle/config operations.
- `log.info(...)`: user-visible actions and important flow changes.
- `log.warning(...)`: recoverable unusual states, migration/index compatibility issues, and degraded network conditions.
- `log.error(...)`: failed operations, caught exceptions, and global errors.
- `log.download(...)`: download engine progress/details that belong in the download log.

Examples:

- `JHLifeCircleBeanErrorCatch` logs lifecycle init success with `debug` and failures with `error`.
- `database.dart` logs schema version changes with `info`/`warning`.
- `EHRequest` logs unavailable domain-fronting host/IP pairs with `info`.

---

## Structured Logging

Most project logs are message-based, not structured JSON. When extra context matters, include it in the message or pass it through `uploadError(extraInfos: ...)`.

Examples:

- Migration errors include `{'from': from, 'to': to}`.
- `callWithParamsUploadIfErrorOccurs()` sends `{'params': params}` to `uploadError`.
- Settings save methods log the setting name and new value, for example `saveThemeMode:${themeMode.name}`.

---

## What to Log

Log:

- Lifecycle initialization failures and important lifecycle success points.
- Network and parser failures that affect user workflows.
- Database migration version changes and migration errors.
- User-visible operations that are helpful for troubleshooting, such as page jumps or setting changes.
- Download-specific events through `log.download()`.

Use localized messages for UI feedback, but logs can include developer-oriented details.

---

## What NOT to Log

Avoid logging secrets or sensitive account/session data:

- Passwords
- Cookies
- API keys or signatures
- Proxy passwords
- Full request headers when they may include credentials

The current `NetworkSetting.saveProxy()` logs proxy username and password values. Treat this as existing behavior, not a pattern to copy; new code should avoid logging credential values.
