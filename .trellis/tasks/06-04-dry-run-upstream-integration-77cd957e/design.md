# Design

## Scope

This task is an integration discovery task. It creates a disposable worktree, attempts a pinned upstream merge without committing, and records the conflict inventory needed for a later real integration task.

## Worktree Boundary

The current checkout remains the control workspace on `master`. The dry-run merge happens in:

```text
../jhentai-upstream-dry-run-8.0.13-311
```

The dry-run branch is:

```text
upstream-sync/dry-run-8.0.13-311
```

The branch is intentionally disposable and should not be merged back to `master`.

## Merge Target

Use fixed upstream baseline:

```text
77cd957ef9a515ff3e7f1eb83744f0688fea9587
```

This is the post-`v8.0.13` upstream commit that updates `AltSource.json` for `8.0.13+311`.

## Conflict Classification

Classify conflicts using the merge posture language from `CONTEXT.md`:

- upstream-first
- local-first
- field-by-field
- key-completeness
- regenerate-only
- fork-local preserve

Expected review priority:

1. Fork-local workflow overlays.
2. Release metadata and packaging.
3. Archive protocol.
4. Archive UI/settings.
5. Details/download/block-rule surfaces.
6. Localization.
7. Generated artifacts.

## Result Artifact

Write `dry-run-results.md` under this task directory. It should include:

- commands run
- merge result
- conflict inventory
- non-conflicting upstream changes worth reviewing
- recommended next task
- cleanup recommendation for the disposable worktree
