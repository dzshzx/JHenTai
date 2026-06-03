# Design

## Integration Boundary

The integration happens outside the current checkout in:

```text
../jhentai-upstream-8.0.13-311
```

Branch:

```text
upstream-sync/8.0.13-311
```

This branch is the reviewable integration branch. It should not be merged to `master` until validation and user review are complete.

## Conflict Strategy

### `altsource/AltSource.json`

Use field-by-field merge. The upstream side should provide the `8.0.13+311` release metadata because this task is adopting upstream release baseline `77cd957e`. Verify consistency with `pubspec.yaml`.

### `lib/src/widget/eh_archive_bot_setting_dialog.dart`

Use combined posture:

- upstream-first for the new `ArchiveBotType` protocol selector and Archive-at-Home support
- local-first for local proxy behavior

Expected shape:

- constructor accepts `botType`, `apiAddress`, `apiKey`, and `useProxy`
- state tracks `_botType`, `_apiAddressController`, `_apiKeyController`, and `_useProxy`
- content includes protocol selector, address field, key field, and `useProxyServer` switch
- address field remains disabled when `_useProxy` is true
- confirm writes the selected protocol plus address/key/proxy settings through `archiveBotSetting`

## Validation

Run from integration worktree:

```bash
rtk /home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter pub get
rtk /home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter analyze --no-pub
rtk /home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter test
```

If analyzer/test output exposes pre-existing noise, record exact failures and decide whether they block this integration.
