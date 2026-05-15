# Flutter Dart latest upgrade impact and safe upgrade

## Goal

Research whether upgrading this Flutter project to the latest stable Flutter and Dart versions would introduce breaking changes or high-risk incompatibilities, then execute the upgrade using an isolated, low-risk workflow after the implementation plan is reviewed.

## Requirements

- Keep research and planning in the primary worktree; perform application source changes only after plan review and task activation.
- Use an isolated upgrade worktree and isolated dependency/build caches where practical, so Flutter, pub, and Gradle side effects do not contaminate the primary workspace.
- Upgrade to latest stable Flutter found during research: Flutter 3.41.9 with bundled Dart 3.11.5.
- Make the minimum dependency changes required to resolve and build on Flutter 3.41.9 before broad package modernization.
- Preserve existing app behavior unless a platform floor change is required by latest Flutter support policy.
- Identify the project's current Flutter/Dart SDK constraints, locked package versions, platform build tool versions, and generated Flutter metadata.
- Verify the latest stable Flutter and Dart versions from official sources at research time.
- Compare the project against likely breaking surfaces: Dart language/SDK constraints, Flutter framework/API usage, package compatibility, Android Gradle/Kotlin/Java requirements, iOS/macOS CocoaPods/Xcode requirements, desktop platform files, analyzer/lint behavior, and generated project template drift.
- Apply only targeted compatibility fixes in this task; defer unrelated major package upgrades unless they are required for the SDK upgrade.
- Produce a practical risk assessment with recommended next steps and validation commands, then use those commands as the implementation quality gate.

## Acceptance Criteria

- [x] Report current local Flutter/Dart version if installed, plus project-declared SDK and dependency constraints.
- [x] Report the latest stable Flutter/Dart versions with source references.
- [x] List concrete compatibility risks found in this repository, with file references or command evidence.
- [x] Distinguish definite blockers from probable risks and low-risk items.
- [x] Provide a recommended upgrade path and minimum verification checklist.
- [x] State clearly whether upgrading directly to latest is likely safe, risky but manageable, or likely breaking.
- [x] Create implementation design and execution plan for the safe upgrade.
- [x] User reviews and approves the plan before the task moves from planning to in_progress.
- [x] Upgrade branch/worktree resolves dependencies with Flutter 3.41.9.
- [x] Upgrade branch/worktree passes `flutter analyze` or records accepted residual analyzer findings.
- [x] Upgrade branch/worktree builds Android debug APK with `-t lib/src/main.dart`.
- [x] Any platform minimum-version changes are explicit and documented.

## Notes

- Keep `prd.md` focused on requirements, constraints, and acceptance criteria.
- Lightweight tasks can remain PRD-only.
- For complex tasks, add `design.md` for technical design and `implement.md` for execution planning before `task.py start`.
- Research report: `.trellis/tasks/05-15-flutter-dart-latest-upgrade-impact/research/upgrade-impact.md`.
- Conclusion: direct upgrade to Flutter 3.41.9 / bundled Dart 3.11.5 is breaking, but manageable with dependency, API, platform, and Android build configuration updates.
- README files describe broad platform support for Android, iOS, Windows, macOS, and Linux, but do not document a minimum Android API level, iOS version, or macOS version commitment.

## Open Questions

- Platform support floor decision: accepted latest Flutter floors of Android API 24+, iOS 13+, and macOS 10.15+.
