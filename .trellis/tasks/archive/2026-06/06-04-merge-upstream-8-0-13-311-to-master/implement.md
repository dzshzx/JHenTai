# Implementation Plan

## Checklist

- [x] Start task.
- [x] Merge `upstream-sync/8.0.13-311` into `master`.
- [x] Verify `git status --short`.
- [x] Verify `git log --oneline --graph -5`.
- [x] Record merge result.
- [x] Commit task record, archive task, and journal.

## Command

```bash
git merge --no-ff upstream-sync/8.0.13-311 -m "Merge upstream 8.0.13+311 into master"
```

## Result

- Merge commit on `master`: `8b1ac790`
- `8e1f3aff2c459964f31dd6af268a9cec54b16dd2` is an ancestor of `HEAD`.
- `flutter pub get`: passed.
- `flutter analyze --no-pub`: no errors or warnings; 125 info-level existing style/deprecation findings.
- Android debug build was not rerun in this merge task; previous integration task recorded external Gradle dependency download TLS failures.
