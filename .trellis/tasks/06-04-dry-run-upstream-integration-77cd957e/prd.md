# Dry-run upstream integration to 77cd957e

## Goal

Run a disposable-worktree upstream integration dry-run against fixed upstream baseline 77cd957e, capture conflict inventory, and produce the checklist for the real integration task.

## Source Context

- Source PRD: `docs/upstream-integration-prd.md`
- Operating model: `docs/adr/0001-upstream-integration-operating-model.md`
- Prior planning task: `.trellis/tasks/archive/2026-06/06-04-upstream-integration-operating-model/`

## Confirmed Facts

- `master` is the stable fork branch.
- The working tree was clean before this task was created.
- The first dry-run target is fixed upstream baseline `77cd957ef9a515ff3e7f1eb83744f0688fea9587`.
- The dry-run must happen in a disposable worktree, not in the current checkout.
- The dry-run branch name is `upstream-sync/dry-run-8.0.13-311`.
- The dry-run worktree path is `../jhentai-upstream-dry-run-8.0.13-311` relative to the current repo.
- The dry-run must not be merged back to `master`.

## Requirements

- Fetch current remotes and tags before creating the dry-run worktree.
- Create a disposable worktree from `master` on branch `upstream-sync/dry-run-8.0.13-311`.
- Attempt `git merge --no-commit --no-ff 77cd957ef9a515ff3e7f1eb83744f0688fea9587`.
- Capture whether the merge applies cleanly or produces conflicts.
- If conflicts occur, capture:
  - conflict file list
  - conflict status codes
  - likely merge posture for each conflicted surface
  - recommended real-integration handling order
- Do not resolve conflicts unless resolution is needed only to inspect conflict shape; this task is discovery, not real integration.
- Do not modify or merge `master`.
- Leave the disposable worktree available for inspection unless cleanup becomes necessary and is explicitly recorded.
- Record results in `dry-run-results.md`.
- Produce the next real-integration recommendation in `dry-run-results.md`.

## Acceptance Criteria

- [x] Dry-run worktree and branch are created from `master`.
- [x] Merge attempt against `77cd957ef9a515ff3e7f1eb83744f0688fea9587` is run with `--no-commit --no-ff`.
- [x] `dry-run-results.md` records command results, conflict inventory, and recommended handling order.
- [x] The current checkout remains on `master`.
- [x] `master` is not modified by the dry-run.
- [x] Final status report distinguishes current repo state from disposable worktree state.

## Out of Scope

- Resolving upstream integration conflicts for production.
- Committing the dry-run branch.
- Merging the dry-run branch to `master`.
- Running full Flutter validation after conflict discovery.
- Publishing releases or changing tags.

## Notes

- Keep `prd.md` focused on requirements, constraints, and acceptance criteria.
- Lightweight tasks can remain PRD-only.
- For complex tasks, add `design.md` for technical design and `implement.md` for execution planning before `task.py start`.
