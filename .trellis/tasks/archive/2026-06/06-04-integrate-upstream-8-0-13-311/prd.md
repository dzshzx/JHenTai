# Integrate upstream 8.0.13+311

## Goal

Integrate fixed upstream baseline 77cd957e into the fork on a real upstream-sync branch, resolve the dry-run conflicts, validate, and prepare the result for review.

## Source Context

- Operating model: `docs/adr/0001-upstream-integration-operating-model.md`
- Dry-run results: `.trellis/tasks/archive/2026-06/06-04-dry-run-upstream-integration-77cd957e/dry-run-results.md`
- Target baseline: `77cd957ef9a515ff3e7f1eb83744f0688fea9587`

## Confirmed Facts

- `master` is clean and is the stable fork branch.
- Dry-run merge produced two conflicts:
  - `altsource/AltSource.json`
  - `lib/src/widget/eh_archive_bot_setting_dialog.dart`
- The real integration branch should be `upstream-sync/8.0.13-311`.
- The real integration worktree should be `../jhentai-upstream-8.0.13-311`.
- The existing dry-run worktree stays untouched for reference.

## Requirements

- Create a real integration worktree from `master` on branch `upstream-sync/8.0.13-311`.
- Merge upstream baseline `77cd957ef9a515ff3e7f1eb83744f0688fea9587`.
- Resolve `altsource/AltSource.json` using field-by-field release metadata policy.
- Resolve `lib/src/widget/eh_archive_bot_setting_dialog.dart` by adopting upstream `ArchiveBotType` protocol selection while preserving local proxy behavior.
- Review auto-merged archive protocol and settings changes for consistency.
- Validate with the project Flutter baseline where feasible.
- Do not merge the integration branch back to `master` in this task.
- Record implementation and validation results in the task artifacts.

## Acceptance Criteria

- [x] Real integration worktree and branch are created from `master`.
- [x] Upstream baseline `77cd957ef9a515ff3e7f1eb83744f0688fea9587` is merged and conflicts are resolved.
- [x] `altsource/AltSource.json` is internally consistent with `pubspec.yaml` and release metadata policy.
- [x] Archive bot settings dialog supports protocol selection and preserves local proxy behavior.
- [x] Archive bot request/settings call sites compile under static analysis or any failures are recorded with exact output.
- [x] Current `master` checkout remains clean except Trellis bookkeeping before commit.
- [x] The integration branch is left ready for review, not merged to `master`.

## Out of Scope

- Pushing the integration branch.
- Merging the integration branch into `master`.
- Publishing release assets.
- Cleaning up the dry-run worktree unless explicitly requested.

## Notes

- Keep `prd.md` focused on requirements, constraints, and acceptance criteria.
- Lightweight tasks can remain PRD-only.
- For complex tasks, add `design.md` for technical design and `implement.md` for execution planning before `task.py start`.
