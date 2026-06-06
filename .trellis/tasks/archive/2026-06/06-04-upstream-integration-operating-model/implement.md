# Implementation Plan

## Planning Checklist

- [x] Create Trellis planning task after user consent.
- [x] Capture source request and repository facts in `prd.md`.
- [x] Draft upstream integration operating model in `design.md`.
- [x] Draft first execution plan in `implement.md`.
- [x] Resolve whether `master` remains the stable fork branch.
- [x] Resolve whether the first execution is dry-run only or a real integration branch.
- [x] Resolve the first upstream baseline target.
- [x] Resolve where the dry-run should happen.
- [x] Update `prd.md`, `design.md`, and this file after each user decision.
- [x] Review final planning artifacts with the user before `task.py start`.

## Recommended Next Execution Task

Create a separate task after planning:

Title: `Dry-run upstream integration to 77cd957e`

Purpose:

- Test the branch model and merge posture without touching stable `master`.
- Produce a conflict inventory and exact real-integration checklist.

Proposed commands for the execution task, subject to final decisions:

```bash
git fetch --all --tags --prune
git worktree add ../jhentai-upstream-dry-run-8.0.13-311 -b upstream-sync/dry-run-8.0.13-311 master
cd ../jhentai-upstream-dry-run-8.0.13-311
git merge --no-commit --no-ff 77cd957ef9a515ff3e7f1eb83744f0688fea9587
```

This branch is a dry-run branch. Do not merge it back to `master`; capture conflict findings and either abort/reset or convert the findings into a separate real integration task.

## Review Order For First Integration

1. Local workflow overlays: ensure `.trellis/`, `.agents/`, `.codex/`, `docs/agents/`, `AGENTS.md`, and `CLAUDE.md` are preserved unless the change is intentionally fork-local.
2. Release metadata and packaging: check `pubspec.yaml`, `altsource/AltSource.json`, `.github/workflows/build_publish.yml`, platform metadata, and packaging scripts against `.trellis/spec/frontend/release-packaging.md`.
3. Archive protocol: inspect upstream archive-at-home changes and decide which protocol abstractions must be adopted.
4. Archive UI/settings: port upstream behavior without losing local workflow settings.
5. Details/download/block-rule surfaces: prefer local behavior, port upstream fixes semantically.
6. Localization: add required keys for adopted upstream features across all locale files.
7. Generated artifacts: regenerate from source where practical; avoid manual generated-code conflict resolution.

## Validation Commands For Real Integration

Use the project Flutter baseline rather than the older PATH default:

```bash
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter pub get
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter analyze --no-pub
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter test
/home/ubuntu/upgrade-sandbox/jhentai/flutter/bin/flutter build apk --debug -t lib/src/main.dart
```

Packaging smoke checks should be chosen based on the files changed by the integration. If release workflow or platform packaging files change, include a targeted packaging-oriented smoke check or at least script syntax checks for touched shell scripts.

## Rollback Points

- Before merge: clean integration branch/worktree.
- After merge conflicts appear: capture `git status --short`, conflict files, and conflict categories before resolving.
- After conflict resolution but before validation: keep a checkpoint commit on the integration branch.
- Before merge to stable: require validation evidence and user approval.
