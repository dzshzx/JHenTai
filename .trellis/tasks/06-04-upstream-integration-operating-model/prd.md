# Plan upstream integration operating model

## Goal

Turn docs/upstream-integration-prd.md into a concrete upstream integration operating model, including branch model, customization inventory, merge posture, validation checklist, and first integration dry-run plan.

## Source Request

Use `docs/upstream-integration-prd.md`, prior source-repo/fork discussion, `/grill-with-docs`, and other planning skills to decide the concrete next steps for maintaining this fork against upstream releases.

## Confirmed Facts

- Current branch is `master`.
- There is no active Trellis task before this task was created.
- The working tree already contains unrelated documentation edits:
  - `docs/agents/domain.md`
  - `docs/agents/issue-tracker.md`
  - `docs/agents/triage-labels.md`
- `docs/upstream-integration-prd.md` is currently untracked and is the source PRD for this task.
- `origin` points to `https://github.com/dzshzx/JHenTai.git`.
- `upstream` points to `https://github.com/jiangtian616/JHenTai.git`.
- After `git fetch --all --tags --prune`, `upstream/master` is at `77cd957e` and includes the `v8.0.13` / `8.0.13+311` release line.
- The merge base between local `master` and `upstream/master` is `f092e7e6`, described as `v8.0.12-5-gf092e7e6`.
- Local `master` is ahead of `origin/master` and includes Trellis/agent workflow overlay commits, maintenance baseline work, Flutter 3.41.9 tooling work, release packaging policy, Android repository fallback work, and spec refresh work.
- A separate worktree exists at `~/upgrade-sandbox/jhentai/worktree` on branch `chore/flutter-3.41`.
- Upstream changes from local `master` to `upstream/master` are currently concentrated in archive-bot/archive-at-home support, `AltSource`/changelog metadata, iOS metadata, localization, workflow, and `pubspec.yaml`.
- Local changes from `upstream/master` to local `master` are broad and include Trellis/agent files, release workflow and packaging scripts, Flutter/Android/iOS metadata, dependency manifests, generated database output, details-page behavior, download behavior, archive download behavior, local block rules, localization, settings, and services.
- Existing Trellis frontend spec defines `.github/workflows/build_publish.yml` as the release packaging source of truth and `lib/src/main.dart` as the release entrypoint.
- Decision: local `master` is the stable fork branch for upstream integration. Upstream-sync and fork-specific feature branches should start from `master` unless a future task explicitly changes the branch model.
- Decision: the first execution after this planning task is a dry-run upstream integration, not a real integration intended to merge back immediately.
- Decision: the first dry-run target baseline is fixed commit `upstream/master@77cd957e`, because it is the post-`v8.0.13` release metadata commit that updates `AltSource.json` for `8.0.13+311`.
- Decision: the dry-run should use a disposable worktree outside the current checkout to protect existing documentation WIP and avoid changing the current branch state.
- The branch and dry-run operating-model decision is recorded in `docs/adr/0001-upstream-integration-operating-model.md`.

## Requirements

- Define the branch model for long-term upstream integration, including stable fork branch, upstream integration branches, and fork-specific feature branches.
- Define whether local workflow/tooling overlays are part of the product merge surface or a fork-local infrastructure layer that must be preserved independently.
- Produce a lightweight customization inventory covering at least:
  - product/runtime customizations
  - release/packaging customizations
  - dependency/toolchain customizations
  - local workflow/tooling overlays
- Define merge posture categories and assign them to the first high-risk surfaces:
  - archive-bot/archive-at-home protocol
  - details behavior
  - download behavior
  - local block rules
  - release packaging and distribution metadata
  - localization tables
  - generated artifacts and migration-heavy files
  - Trellis/agent/local workflow files
- Define how release tags or release baselines should be selected for integration instead of merging arbitrary upstream head state.
- Define the standard fallback path for expensive conflicts, including when to abandon direct merge and rebuild local customizations as a patch stack on top of a newer upstream baseline.
- Define a validation checklist for an upstream integration, covering dependency resolution, static analysis, relevant tests, localization completeness, release metadata consistency, and a packaging-oriented smoke check.
- Define the concrete first execution task after planning, including whether it is only a dry-run integration or a real integration toward `master`.
- Keep this task in planning scope. Do not perform the actual upstream merge in this task unless the user explicitly expands scope after reviewing planning artifacts.

## Acceptance Criteria

- [x] `prd.md` records confirmed repository facts, requirements, out-of-scope items, acceptance criteria, and remaining user decisions.
- [x] `design.md` defines the upstream integration operating model and maps high-risk surfaces to merge posture categories.
- [x] `implement.md` defines the ordered next steps for the first upstream integration task, including branch naming, review order, validation commands, rollback points, and task split recommendations.
- [x] The plan explicitly protects existing dirty documentation work and avoids staging or rewriting unrelated files.
- [x] The plan names the first target upstream baseline or identifies the user decision needed to choose it.
- [x] The plan states whether the next execution should be a dry-run integration, a real integration, or a two-step dry-run then real integration.
- [x] Remaining open questions are limited to user intent, risk tolerance, or scope decisions that repository inspection cannot answer.
- [x] Long-lived branch-model and dry-run rationale are recorded outside task-local planning in `docs/adr/`.

## Out of Scope

- Performing the actual merge from `upstream/master`, `v8.0.13`, or any other upstream baseline.
- Resolving merge conflicts.
- Changing application runtime behavior.
- Refactoring details, download, archive, block-rule, database, localization, or release packaging code.
- Publishing a release, creating a tag, or uploading release assets.
- Replacing Trellis, `.agents`, `.codex`, or local workflow infrastructure.

## Open Questions

- None blocking. Remaining changes should be made by editing planning artifacts if review finds a gap.

## Notes

- Keep `prd.md` focused on requirements, constraints, and acceptance criteria.
- Lightweight tasks can remain PRD-only.
- For complex tasks, add `design.md` for technical design and `implement.md` for execution planning before `task.py start`.
