# Implementation Plan

## Checklist

- [x] Validate current checkout is clean before creating the worktree.
- [x] Fetch all remotes and tags.
- [x] Create disposable worktree from `master`.
- [x] Run the pinned merge with `--no-commit --no-ff`.
- [x] Capture `git status --short` in the dry-run worktree.
- [x] Capture conflict files and classify by merge posture.
- [x] Write `dry-run-results.md`.
- [x] Verify current checkout remains clean except expected task artifacts.

## Commands

```bash
rtk git status --short
rtk git fetch --all --tags --prune
rtk git worktree add ../jhentai-upstream-dry-run-8.0.13-311 -b upstream-sync/dry-run-8.0.13-311 master
cd ../jhentai-upstream-dry-run-8.0.13-311
rtk git merge --no-commit --no-ff 77cd957ef9a515ff3e7f1eb83744f0688fea9587
rtk git status --short
```

## Stop Conditions

- If worktree creation fails because the path or branch already exists, inspect and report instead of deleting automatically.
- If merge produces conflicts, do not resolve them for production in this task.
- If merge applies cleanly, do not commit; record the staged/uncommitted change list and reset/cleanup only after user direction.
