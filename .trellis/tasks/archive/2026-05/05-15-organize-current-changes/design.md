# Design

## Scope

This task is a repository hygiene and commit-organization task. It does not introduce new product behavior. The work is to classify existing uncommitted changes, make any narrowly necessary cleanup, validate the resulting state, and commit the preserved changes with reviewable boundaries.

## Evidence Sources

- `git status --short` and `git diff` define the active tracked/untracked changes.
- `trellis update --dry-run` distinguishes official Trellis template drift from project-owned data.
- Existing CI workflow and local helper scripts define release artifact behavior.
- Android Gradle files and frontend Trellis specs define dependency resolution policy.
- Recent Git history indicates the repository just moved to Flutter `3.41.9`, so release and dependency changes should be evaluated against that baseline.

## Commit Boundaries

Use separate commits for independent review surfaces:

1. Trellis workflow/template update:
   - `.trellis/.version`
   - `.trellis/workflow.md`
   - `.agents/skills/trellis-meta/references/local-architecture/task-system.md`
   - The current task artifacts if they are part of the Trellis record.
2. Release packaging and CI policy:
   - `.github/workflows/build_publish.yml`
   - platform helper scripts
   - `.gitignore`
   - frontend release packaging specs
3. Gradle repository resolution policy:
   - `android/build.gradle`
   - `android/settings.gradle`
   - related spec notes if not already included with release policy.

If evidence shows a file belongs more strongly to another boundary, prefer semantic cohesion over this initial grouping.

## Cleanup Policy

Ignored files created by `trellis update`, such as `.trellis/.gitignore.new` and `.trellis/.backup-*`, are not commit candidates. Leave them ignored unless they interfere with validation or final status clarity.

Do not overwrite user changes with official templates unless the evidence shows the local file is purely accidental. The only known template conflict is `.trellis/.gitignore`; the local additions are reasonable and should be preserved.

## Validation Strategy

Run lightweight Trellis checks plus project checks that match the changed surfaces:

- `trellis update --dry-run`
- `python3 ./.trellis/scripts/get_context.py --mode phase`
- `python3 ./.trellis/scripts/task.py current --source`
- `flutter pub get`
- `flutter build apk --debug -t lib/src/main.dart`

Use additional static checks when available and cheap. Record any blocked checks with the exact failure.
