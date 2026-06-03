## Problem Statement

当前 JHenTai fork 需要持续吸收原仓库的 release 和 hotfix，同时还要继续承载本地产品定制、构建链调整、Flutter/Dart 工具链策略，以及本地协作层。现在这些事情没有被清晰分层，导致每次上游升级都像一次大手术：上游发布节奏、本地功能开发、发布脚本和兼容性修补都混在同一条主线里，冲突难以预测、回归难以控制、历史边界也不清楚。

## Solution

建立一套长期可执行的 upstream integration workflow，把 fork 经营成“上游集成层 + 本地产品定制层”的双层结构。通过明确分支模型、定制分层、冲突策略、验证流程和定制清单，让每次上游 release 都成为一次受控集成任务，而不是临时性的手工 merge。目标不是消除所有分叉，而是让分叉具名、可重放、可审计、可维护。

## User Stories

1. As a fork maintainer, I want a dedicated upstream-sync workflow, so that upstream release integration is isolated from normal feature work.
2. As a fork maintainer, I want to merge upstream releases on a dedicated branch, so that I can review conflicts before they affect the stable branch.
3. As a fork maintainer, I want the stable branch to remain releasable, so that custom development and upstream integration do not block each other.
4. As a fork maintainer, I want to classify local changes into product customizations, release/packaging customizations, and local workflow layers, so that I know which changes must always be preserved.
5. As a fork maintainer, I want a documented rule for when to prefer upstream over local code in a conflicting file, so that conflict resolution is consistent across releases.
6. As a fork maintainer, I want a documented rule for when to preserve local code and manually port upstream behavior, so that heavily customized modules do not regress.
7. As a fork maintainer, I want a documented rule for protocol-layer upgrades, so that external service integrations can evolve with upstream without breaking local behavior.
8. As a fork maintainer, I want release metadata updates to follow a clear policy, so that version numbers, AltSource data, and packaged artifacts stay internally consistent.
9. As a fork maintainer, I want dependency and toolchain changes to be treated separately from feature merges, so that SDK migrations do not get hidden inside unrelated upstream integrations.
10. As a fork maintainer, I want to know which modules are high-risk during upstream upgrades, so that I can spend review time where it matters.
11. As a fork maintainer, I want to know which modules are low-risk and can usually accept upstream changes directly, so that I do not over-review safe areas.
12. As a fork maintainer, I want a repeatable validation checklist after each upstream merge, so that the integrated fork is verified before it reaches the stable branch.
13. As a fork maintainer, I want localization changes to follow a key-completeness rule, so that upstream feature strings do not silently disappear in local releases.
14. As a fork maintainer, I want generated artifacts and migration-heavy modules to have explicit handling rules, so that schema or generated-code changes are not merged mechanically.
15. As a fork maintainer, I want release workflow changes from upstream to be reviewed against local CI behavior, so that distribution does not break when upstream modifies publishing logic.
16. As a fork maintainer, I want archive-bot and archive-at-home protocol work to have a clear integration policy, so that upstream service evolution can be adopted without rewriting unrelated local customizations.
17. As a fork maintainer, I want local blocking behavior and upstream blocking features to converge under one model, so that new upstream capabilities are not lost.
18. As a fork maintainer, I want to keep local workflow tooling such as Trellis, agent config, and journals separate from product merge work, so that upstream application changes do not interfere with local development infrastructure.
19. As a fork maintainer, I want a lightweight customization inventory, so that I can quickly audit whether upstream has replaced or superseded one of my local patches.
20. As a fork maintainer, I want a clean historical boundary around each upstream integration, so that I can later understand which commit introduced a release merge.
21. As a fork maintainer, I want to continue building new fork-specific features between upstream releases, so that adopting upstream does not freeze local product evolution.
22. As a fork maintainer, I want feature branches to start from the stable fork branch instead of an upstream-sync branch, so that ongoing development stays independent from integration work.
23. As a fork maintainer, I want upstream release integration to be driven by tags or release baselines instead of arbitrary head state, so that upgrades target known published behavior.
24. As a fork maintainer, I want a standard fallback path for large conflicts, so that I can rebuild a change as a patch on top of a newer upstream base when a direct merge becomes too expensive.
25. As a fork maintainer, I want the integration workflow to identify deep modules worth preserving behind stable interfaces, so that future upstream merges touch fewer call sites.
26. As a fork maintainer, I want conflict-prone modules such as details, downloads, release packaging, archive-bot integration, and block rules to have documented merge posture, so that future upgrades are faster.
27. As a fork maintainer, I want the workflow to preserve external behavior rather than matching either side mechanically, so that users keep both upstream fixes and local value.
28. As a fork maintainer, I want to verify that release assets and runtime behavior match after an integration, so that an apparently successful merge does not hide broken packaging or regressions.
29. As a fork maintainer, I want the fork to remain operational even when upstream and local changes diverge in the same feature area, so that the project can evolve without giving up maintainability.
30. As a future maintainer of the fork, I want a documented upstream integration operating model, so that the process does not depend on tribal memory.

## Implementation Decisions

- Introduce a branch model with three clear responsibilities: a stable fork branch for releasable state, upstream-sync branches for release integration, and feature branches for fork-specific development.
- Treat upstream release integration as a distinct maintenance workflow rather than ordinary feature development.
- Use upstream release tags or release baselines as the preferred integration source instead of continuously merging arbitrary upstream head state.
- Define a customization inventory that groups local changes into at least three layers: product/runtime customizations, release/packaging customizations, and local workflow/tooling overlays.
- Preserve local workflow/tooling overlays independently from upstream application code. These include Trellis artifacts, local agent configuration, and other developer-process files that are not part of the upstream product.
- Establish file-level merge posture categories:
  - upstream-first for protocol and service-contract upgrades where upstream introduces a new canonical interaction model.
  - local-first for deeply customized runtime modules where upstream contributes a small feature or bugfix that should be manually ported.
  - field-by-field merge for files that mix release metadata, SDK constraints, and local policy.
  - key-completeness merge for localization tables.
- Treat release packaging and distribution metadata as a dedicated subsystem with its own review policy. Runtime code and publishing mechanics should not be merged as if they were one concern.
- Prefer manual semantic porting over whole-file replacement in heavily customized modules such as details behavior, download behavior, and local blocking behavior.
- Treat archive-bot / archive-at-home support as a protocol-layer concern that may require adopting upstream abstractions even when local UI and workflow customizations are preserved.
- Treat local block rules as a fork-owned deep module that should absorb upstream capabilities such as gid-based blocking without surrendering local model shape.
- Maintain a repeatable post-merge verification workflow covering dependency resolution, static analysis, tests, and at least one packaging-oriented smoke check.
- Keep each upstream integration represented by explicit, reviewable commits so that future debugging and audits can trace the adoption of a specific release.
- Support an escape hatch for difficult upgrades: rebuild local customizations as a patch stack on top of a new upstream baseline when direct merge complexity becomes too high.

## Testing Decisions

- Good tests should validate observable fork behavior and release workflow outcomes, not implementation details such as specific private helpers or internal merge mechanics.
- The workflow itself should be verified through repeatable operational checks: dependency resolution, analyzer output, existing test suite execution, and release-path smoke validation.
- Runtime modules with high merge risk should have behavior-focused regression tests where practical, especially download behavior, details-page actions, blocking behavior, and archive integration behavior.
- Release metadata and packaging changes should be checked with artifact-oriented validation rather than unit-level assertions alone.
- Localization validation should focus on key completeness and absence of missing required keys for newly integrated features.
- Deep modules that encapsulate customization logic should be the preferred unit-test targets, because they provide stable interfaces and reduce future merge risk.
- Prior art in the codebase includes the existing smoke-style Flutter tests and behavior already centralized in long-lived services, settings, request clients, and page logic layers.

## Out of Scope

- Implementing the full upstream integration workflow in this PRD.
- Performing the actual merge to a specific upstream release.
- Resolving all current analyzer info-level findings.
- Redesigning the entire application architecture beyond what is needed to support maintainable upstream integration.
- Replacing the existing local development workflow stack unless a future implementation task explicitly decides to do so.

## Further Notes

- Current repository analysis already shows both `origin` and `upstream` remotes configured, so the raw Git connectivity needed for this workflow exists.
- The highest-risk integration surfaces identified so far are release packaging, details behavior, download behavior, archive-bot/archive-at-home integration, and local blocking rules.
- The repository currently also contains a substantial local workflow/tooling overlay that should be treated as fork-local infrastructure, not as part of upstream product integration.
- The purpose of this PRD is not to minimize all divergence. The purpose is to make divergence intentional, layered, and maintainable over time.

## Post-Merge Android Build Environment Notes

- The `8.0.13+311` upstream integration was validated on the stable fork branch with `flutter build apk --debug -t lib/src/main.dart`.
- The effective WSL proxy endpoint during validation was `127.0.0.1:7897`, exported through `http_proxy`, `https_proxy`, `HTTP_PROXY`, `HTTPS_PROXY`, `all_proxy`, and `ALL_PROXY`.
- Gradle dependency resolution also used user-level JVM proxy settings in `~/.gradle/gradle.properties`:
  - `systemProp.http.proxyHost=127.0.0.1`
  - `systemProp.http.proxyPort=7897`
  - `systemProp.https.proxyHost=127.0.0.1`
  - `systemProp.https.proxyPort=7897`
- Repository Gradle files and the user-level `~/.gradle/init.d/jhentai-maven-mirrors.gradle` script put Maven mirrors ahead of official Maven repositories for this environment. This matters because older dependency chains can still touch Maven/JCenter-era artifacts.
- A debug APK is only a validation artifact for dependency and build-chain checks. Release packaging must still follow the repository release workflow and use `lib/src/main.dart` as the entrypoint.
- Machine-local proxy and user-home Gradle init files are environment prerequisites for this workstation, not product behavior. Future upstream integrations should re-verify the current network path instead of assuming these values are portable.
