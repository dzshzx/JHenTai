# Implementation Plan

## Checklist

- [x] Create `../jhentai-upstream-8.0.13-311` from `master` on `upstream-sync/8.0.13-311`.
- [x] Merge `77cd957ef9a515ff3e7f1eb83744f0688fea9587`.
- [x] Resolve `altsource/AltSource.json`.
- [x] Resolve `lib/src/widget/eh_archive_bot_setting_dialog.dart`.
- [x] Review archive bot setting/request call sites.
- [x] Run `flutter pub get`.
- [x] Run `flutter analyze --no-pub`.
- [x] Run `flutter test`.
- [x] Record results.
- [x] Commit integration branch.

## Commands

```bash
git worktree add ../jhentai-upstream-8.0.13-311 -b upstream-sync/8.0.13-311 master
cd ../jhentai-upstream-8.0.13-311
git merge --no-ff 77cd957ef9a515ff3e7f1eb83744f0688fea9587
```

If conflicts occur, resolve them in the integration worktree and commit the merge there.
