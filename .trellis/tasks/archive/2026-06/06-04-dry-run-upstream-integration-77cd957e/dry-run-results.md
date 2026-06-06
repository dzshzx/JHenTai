# Dry-run Results

## Summary

Dry-run merge against upstream baseline `77cd957ef9a515ff3e7f1eb83744f0688fea9587` was executed in disposable worktree:

```text
/home/ubuntu/workspace/jhentai-upstream-dry-run-8.0.13-311
```

Branch:

```text
upstream-sync/dry-run-8.0.13-311
```

Result: merge did not apply cleanly. It produced 2 content conflicts and 27 auto-merged changed files.

The current checkout at `/home/ubuntu/workspace/JHenTai` stayed on `master`; the merge was not run there.

## Commands Run

```bash
git fetch --all --tags --prune
git worktree add ../jhentai-upstream-dry-run-8.0.13-311 -b upstream-sync/dry-run-8.0.13-311 master
git merge --no-commit --no-ff 77cd957ef9a515ff3e7f1eb83744f0688fea9587
git status --short
git diff --name-only --diff-filter=U
git ls-files -u
```

## Merge Output

`git merge --no-commit --no-ff 77cd957ef9a515ff3e7f1eb83744f0688fea9587` failed with content conflicts in:

```text
altsource/AltSource.json
lib/src/widget/eh_archive_bot_setting_dialog.dart
```

## Conflict Inventory

| File | Status | Surface | Merge posture | Notes |
| --- | --- | --- | --- | --- |
| `altsource/AltSource.json` | `UU` | Release metadata | field-by-field | Local side has `8.0.12+309`; upstream side has `8.0.13+311`, release date `2026-06-03T13:48:55Z`, Archive-at-Home release notes, IPA URL, and size. Real integration should update metadata consistently with `pubspec.yaml` and release packaging policy. |
| `lib/src/widget/eh_archive_bot_setting_dialog.dart` | `UU` | Archive bot settings UI | upstream-first for protocol selector, local-first for local proxy behavior | Local side carries `useProxy`; upstream side adds `ArchiveBotType`, Archive-at-Home selector, `_onConfirm`, and field extraction helpers. Real integration must preserve local proxy behavior while adopting protocol selection. |

## Auto-merged Files

```text
.github/workflows/build_publish.yml
.gitignore
changelog/v8.0.12+310.md
changelog/v8.0.13.md
ios/Podfile.lock
ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme
ios/Runner/Info-Debug.plist
ios/Runner/Info.plist
lib/src/consts/archive_bot_consts.dart
lib/src/l18n/en_US.dart
lib/src/l18n/ko_KR.dart
lib/src/l18n/pt_BR.dart
lib/src/l18n/ru_RU.dart
lib/src/l18n/zh_CN.dart
lib/src/l18n/zh_TW.dart
lib/src/model/archive_bot_response/archive_bot_response.dart
lib/src/model/archive_bot_response/archive_resolve_vo.dart
lib/src/model/archive_bot_response/balance_vo.dart
lib/src/model/archive_bot_response/check_in_vo.dart
lib/src/network/archive_bot_request.dart
lib/src/pages/details/details_page_logic.dart
lib/src/pages/setting/download/archive_bot/archive_bot_settings_page.dart
lib/src/service/archive_download_service.dart
lib/src/service/schedule_service.dart
lib/src/setting/archive_bot_setting.dart
lib/src/utils/archive_bot_response_parser.dart
pubspec.yaml
```

## Important Auto-merged Changes To Review

- `.github/workflows/build_publish.yml` adds `git pull origin master` before committing generated `AltSource.json`. Review against the local release packaging policy before accepting.
- `.gitignore` removes `lib/generated_plugin_registrant.dart`; verify this does not conflict with local Flutter 3.41.9 generated-file expectations.
- `pubspec.yaml` moves version from `8.0.12+309` to `8.0.13+311`.
- `lib/src/network/archive_bot_request.dart` introduces `ArchiveBotProtocol`, `EhArBotProtocol`, and `ArchiveAtHomeProtocol`.
- `lib/src/setting/archive_bot_setting.dart` introduces `ArchiveBotType` and per-protocol response parsing.
- `lib/src/utils/archive_bot_response_parser.dart` is deleted by upstream; real integration should verify the new parser ownership fully replaces it.
- `lib/src/l18n/*.dart` adds `archiveBotProtocol` key across locales; real integration should keep key-completeness across all locale files.
- iOS metadata and `Podfile.lock` are updated; review as field-by-field platform metadata, not as application behavior.

## Recommended Real Integration Order

1. Start a real `upstream-sync/8.0.13-311` task from `master`.
2. Re-run the merge against the same fixed baseline `77cd957ef9a515ff3e7f1eb83744f0688fea9587`.
3. Resolve `altsource/AltSource.json` with field-by-field metadata policy:
   - accept upstream release version/build/date/notes/download/size where the fork intends to publish the upstream release metadata,
   - verify consistency with `pubspec.yaml` and `.trellis/spec/frontend/release-packaging.md`.
4. Resolve `lib/src/widget/eh_archive_bot_setting_dialog.dart` semantically:
   - adopt upstream `ArchiveBotType` protocol selector and helper extraction,
   - preserve local `useProxy` behavior or deliberately migrate it into the new protocol model,
   - update `archiveBotSetting.saveConfig` / `saveAllConfig` call sites consistently.
5. Review auto-merged archive protocol files as one subsystem before touching details/download/block-rule surfaces.
6. Run key-completeness review across `lib/src/l18n/*.dart`.
7. Run at least:

```bash
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter pub get
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter analyze --no-pub
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter test
```

If release or platform metadata remains changed, also run targeted packaging/script checks selected from touched files.

## Cleanup Recommendation

Keep the disposable worktree for immediate inspection until the user decides whether to proceed to real integration. Do not merge or commit the dry-run branch.

If cleanup is requested later, first abort the merge in the disposable worktree, then remove the worktree and branch:

```bash
cd /home/ubuntu/workspace/jhentai-upstream-dry-run-8.0.13-311
git merge --abort
cd /home/ubuntu/workspace/JHenTai
git worktree remove ../jhentai-upstream-dry-run-8.0.13-311
git branch -D upstream-sync/dry-run-8.0.13-311
```
