# Implementation Plan

## Checklist

- [x] Inspect all current tracked, untracked, and ignored Trellis update files.
- [x] Confirm whether each change is official Trellis template sync, project spec, release packaging, Gradle policy, or temporary output.
- [x] Update task artifacts with final research notes.
- [x] Start the Trellis task before making execution changes.
- [x] Preserve `.trellis/.gitignore` local ignore additions unless evidence proves they are wrong.
- [x] Stage and commit changes in semantic groups.
- [x] Run validation commands and capture outcomes.
- [x] Finish/archive the Trellis task and leave final working tree state explainable.

## Risk Points

- Release workflow changes can affect publish artifacts on tags; review matrix target names and artifact paths before committing.
- Gradle mirror changes affect all Android dependency resolution; keep repository ordering and content filters consistent between `settings.gradle` and `build.gradle`.
- Trellis template files should not be overwritten with generated candidates unless dry-run identifies a required update.
- Task artifacts may be archived during finish; commit them according to the resulting Trellis state.

## Validation Commands

```bash
rtk trellis update --dry-run
rtk python3 ./.trellis/scripts/get_context.py --mode phase
rtk python3 ./.trellis/scripts/task.py current --source
rtk flutter pub get
rtk flutter build apk --debug -t lib/src/main.dart
```
