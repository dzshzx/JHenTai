# Fix archive bot readiness fallback

## Goal

Make Archive Bot readiness use the same address fallback model as
`resolvedApiAddress`, so a selected bot type with a configured API key is usable
when its explicit API address is blank and a default address exists.

This closes a post-integration inconsistency found during temporary validation:
`resolvedApiAddress` can return the Archive-at-Home default address while
`isReady` still reports false because `apiAddress` is null.

## Requirements

- `ArchiveBotSetting.isReady` must stay false when no API key is configured.
- With an API key configured, `ArchiveBotSetting.isReady` must be true for
  `ehArBot` and `archiveAtHome` when the selected bot type can resolve a default
  API address.
- `ehArBot` with `useProxyServer == true` must continue to resolve to
  `ArchiveBotConsts.proxyServerAddress`.
- `archiveAtHome` must continue to ignore the local proxy endpoint and resolve
  to either its explicit API address or
  `ArchiveBotConsts.defaultArchiveAtHomeServerAddress`.
- Add regression coverage for the readiness/address-resolution invariants.

## Acceptance Criteria

- [x] `ArchiveBotSetting` has a single consistent readiness rule aligned with
  `resolvedApiAddress`.
- [x] Existing Archive Bot settings behavior remains unchanged for configured
  custom addresses.
- [x] Tests cover `ehArBot` proxy routing, `archiveAtHome` proxy-ignore
  behavior, and default-address fallback readiness.
- [x] `flutter test` passes.
- [x] `flutter analyze --no-pub` is run and any failures are classified.

## Validation Record

- `flutter test test/smoke_test.dart` passed.
- `flutter test` passed all smoke tests.
- `flutter analyze --no-pub` returned exit code 1 due to the repository's
  existing 125 info-level lint/deprecation findings.
- `flutter build apk --debug -t lib/src/main.dart` passed.
- `test/smoke_test.dart` is locally ignored by `.git/info/exclude`; this task
  intentionally force-adds it so the regression coverage is versioned.

## Out of Scope

- Redesigning Archive Bot persistence or logging.
- Changing Archive Bot request protocols.
- Resolving unrelated repository-wide analyzer info-level findings.
