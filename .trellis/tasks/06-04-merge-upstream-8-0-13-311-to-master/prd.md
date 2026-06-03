# Merge upstream 8.0.13+311 to master

## Goal

Merge reviewed upstream-sync/8.0.13-311 integration branch back to stable master, verify repository state, and record the result.

## Confirmed Facts

- `master` is the stable fork branch.
- Integration branch `upstream-sync/8.0.13-311` exists in `/home/ubuntu/workspace/jhentai-upstream-8.0.13-311`.
- Integration commit is `8e1f3aff2c459964f31dd6af268a9cec54b16dd2`.
- Integration worktree is clean.
- Review found no analyzer errors or warnings.
- Android debug build failed due external Gradle dependency download TLS handshake failures, not Dart compilation errors.

## Requirements

- Merge `upstream-sync/8.0.13-311` into `master`.
- Preserve the integration branch merge boundary in history.
- Verify `master` worktree state after merge.
- Do not push remote branches or tags.
- Do not clean up the integration or dry-run worktrees unless explicitly requested.

## Acceptance Criteria

- [x] `master` contains integration commit `8e1f3aff2c459964f31dd6af268a9cec54b16dd2`.
- [x] Merge is committed on `master`.
- [x] `master` worktree is clean after merge and task bookkeeping.
- [x] Validation and remaining risk are recorded.

## Notes

- Keep `prd.md` focused on requirements, constraints, and acceptance criteria.
- Lightweight tasks can remain PRD-only.
- For complex tasks, add `design.md` for technical design and `implement.md` for execution planning before `task.py start`.
