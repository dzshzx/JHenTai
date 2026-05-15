# Research Flutter Dart latest upgrade impact

## Goal

Research whether upgrading this Flutter project to the latest stable Flutter and Dart versions would introduce breaking changes or high-risk incompatibilities.

## Requirements

- Keep the work read-only for application source unless the user later asks for implementation.
- Identify the project's current Flutter/Dart SDK constraints, locked package versions, platform build tool versions, and generated Flutter metadata.
- Verify the latest stable Flutter and Dart versions from official sources at research time.
- Compare the project against likely breaking surfaces: Dart language/SDK constraints, Flutter framework/API usage, package compatibility, Android Gradle/Kotlin/Java requirements, iOS/macOS CocoaPods/Xcode requirements, desktop platform files, analyzer/lint behavior, and generated project template drift.
- Use local commands where available to gather evidence, but do not perform a real upgrade or dependency rewrite.
- Produce a practical risk assessment with recommended next steps and validation commands for an eventual upgrade attempt.

## Acceptance Criteria

- [x] Report current local Flutter/Dart version if installed, plus project-declared SDK and dependency constraints.
- [x] Report the latest stable Flutter/Dart versions with source references.
- [x] List concrete compatibility risks found in this repository, with file references or command evidence.
- [x] Distinguish definite blockers from probable risks and low-risk items.
- [x] Provide a recommended upgrade path and minimum verification checklist.
- [x] State clearly whether upgrading directly to latest is likely safe, risky but manageable, or likely breaking.

## Notes

- Keep `prd.md` focused on requirements, constraints, and acceptance criteria.
- Lightweight tasks can remain PRD-only.
- For complex tasks, add `design.md` for technical design and `implement.md` for execution planning before `task.py start`.
- Research report: `.trellis/tasks/05-15-flutter-dart-latest-upgrade-impact/research/upgrade-impact.md`.
- Conclusion: direct upgrade to Flutter 3.41.9 / bundled Dart 3.11.5 is breaking, but manageable with dependency, API, platform, and Android build configuration updates.
