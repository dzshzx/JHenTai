# Error Handling

> Error types, propagation, logging, and user-facing failure handling.

---

## Overview

The code separates domain/site failures from generic runtime failures:

- Site and E-Hentai state failures become `EHSiteException`.
- Dio transport failures remain `DioException` unless converted to a domain error.
- Expected non-uploadable failures can be wrapped in `NotUploadException`.
- UI/page logic catches expected errors, logs them, shows translated `snack()`/`toast()` messages, and updates `LoadingState`.

Global Flutter errors are captured in `LogService.doInitBean()` through `PlatformDispatcher.instance.onError` and `FlutterError.onError`.

---

## Error Types

`lib/src/exception/eh_site_exception.dart` defines `EHSiteException` with:

- `type`
- `message`
- optional `referLink`
- `shouldPauseAllDownloadTasks`

The current `EHSiteExceptionType` values are `cloudflare`, `blankBody`, `banned`, `exceedLimit`, `galleryDeleted`, `internalError`, and `ehServerError`.

`lib/src/exception/upload_exception.dart` defines `NotUploadException`, used to avoid treating a known wrapped error as a global upload/reporting candidate.

---

## Error Handling Patterns

Network request wrappers in `EHRequest` centralize E-Hentai failure conversion:

- `_getWithErrorHandler()` and `_postWithErrorHandler()` catch `DioException`.
- `_convertExceptionIfGalleryDeleted()` converts selected `404`/`403` responses into `EHSiteException`.
- `_emitEHExceptionIfFailed()` inspects E-Hentai response bodies for sad-panda/ban/limit/server states.
- Cache entries are removed when cached responses produce `EHSiteException`.

Page logic catches in this order when handling user workflows:

1. `DioException`
2. `EHSiteException`
3. generic `catch (e)`

Then it logs, displays a localized snack/toast, sets the relevant `LoadingState`, and calls `updateSafely([...])`.

Use `rethrow` when a lower-level helper logs context but the caller still owns recovery. Migration helpers in `database.dart` use this pattern.

---

## API Error Responses

This app is a client. It does not define server response schemas in this repository.

For client requests:

- E-Hentai HTML/API responses are parsed through `HtmlParser<T>` helpers, usually in `EHSpiderParser`.
- JHenTai backend requests in `JHRequest` return raw `Response` when no parser is supplied or parse on `isolateService` when a parser is supplied.
- User-visible errors should use translation keys (`'failed'.tr`, `'getGallerysFailed'.tr`, etc.) where existing keys exist.

---

## Common Mistakes

- Do not parse E-Hentai failure pages in widgets. Add conversion to `EHRequest` or parser utilities.
- Do not catch broad errors and do nothing; update `LoadingState` and user feedback consistently.
- Do not call `update()` directly from controllers; use `updateSafely()` to avoid updates after controller disposal.
- Do not upload/report `NotUploadException` as a global error.
- Do not drop `DioException` details. Prefer `e.errorMsg` where available or `e.message` for user feedback.
