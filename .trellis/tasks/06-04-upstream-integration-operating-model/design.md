# Design

## Scope

This task defines the operating model for integrating upstream JHenTai releases into this fork. It does not perform the upstream merge. The output should be stable enough that a later execution task can follow it without relying on chat history.

## Branch Model

Proposed default:

- Stable fork branch: `master`
- Upstream integration branches: `upstream-sync/<baseline>`
- Fork-specific feature branches: `codex/<topic>` or existing repo-specific feature branch names, created from the stable fork branch

Rationale:

- Current local history and `origin/master` already treat `master` as the primary fork branch.
- The repository has substantial fork-local history that is not upstream product code, especially Trellis/agent workflow files and maintenance baseline commits.
- Feature branches should not start from an upstream-sync branch, because integration conflicts should not block normal fork work.

Decision: keep `master` as the stable fork branch. Do not introduce a separate `stable` branch for this operating model.

ADR: `docs/adr/0001-upstream-integration-operating-model.md`

## Layer Model

### Product/runtime customizations

Runtime behavior owned or intentionally changed by the fork. Candidate surfaces include details-page behavior, download behavior, local archive handling, local block rules, settings, services, and UI/page logic.

Default posture: local-first with semantic porting of upstream fixes.

### Release/packaging customizations

Build workflows, packaging scripts, release metadata, platform metadata, AltSource data, and artifact layout.

Default posture: field-by-field merge against the existing release packaging spec. CI remains the source of truth for release packaging.

### Dependency/toolchain customizations

Flutter/Dart baseline, pinned git dependencies, Android Gradle repository strategy, generated plugin metadata, lockfiles, and platform toolchain metadata.

Default posture: separate from feature merges. Dependency/toolchain changes require explicit compatibility review and should not be hidden inside unrelated upstream integration.

### Local workflow/tooling overlays

Trellis files, `.agents`, `.codex`, local task archives, journals, and agent-facing docs.

Default posture: fork-local infrastructure. Preserve independently from upstream application integration. Upstream product changes should not delete or rewrite this layer.

## Merge Posture Categories

- Upstream-first: use when upstream introduces a canonical protocol or service-contract model that the fork should adopt.
- Local-first: use when the fork owns substantial behavior and upstream contributes a small feature or bugfix that should be manually ported.
- Field-by-field merge: use for files that mix release metadata, SDK/toolchain constraints, local policy, and upstream version data.
- Key-completeness merge: use for localization tables; preserve all required keys and add upstream keys needed by newly adopted features.
- Regenerate-only: use for generated artifacts and migration-heavy output; do not manually merge generated code unless no generator path exists.
- Fork-local preserve: use for Trellis/agent/local workflow files.

## Initial Surface Mapping

| Surface | Examples | Proposed posture |
| --- | --- | --- |
| Archive bot / archive-at-home protocol | `lib/src/network/archive_bot_request.dart`, `lib/src/model/archive_bot_response/`, `lib/src/setting/archive_bot_setting.dart` | upstream-first for protocol contracts, local-first for UI/workflow |
| Details behavior | `lib/src/pages/details/details_page_logic.dart`, `lib/src/pages/details/details_page.dart` | local-first, semantic port |
| Download behavior | `lib/src/pages/download/`, `lib/src/service/gallery_download_service.dart`, `lib/src/service/archive_download_service.dart` | local-first, semantic port |
| Local block rules | `lib/src/service/local_block_rule_service.dart`, preference block-rule pages | local-first, absorb upstream capabilities without surrendering model shape |
| Release packaging | `.github/workflows/build_publish.yml`, `apk.sh`, `ipa.sh`, `linux.sh`, `windows.sh`, `thin-payload.sh`, `altsource/AltSource.json` | field-by-field, check against release packaging spec |
| Localization | `lib/src/l18n/*.dart` | key-completeness |
| Generated/migration-heavy artifacts | `lib/src/database/database.g.dart`, generated plugin files, lockfiles | regenerate-only or field-by-field depending on generator/source |
| Local workflow overlays | `.trellis/`, `.agents/`, `.codex/`, `docs/agents/`, `AGENTS.md`, `CLAUDE.md` | fork-local preserve |

## Baseline Selection

Preferred integration source should be a release tag or explicit release baseline, not arbitrary moving upstream state.

Current candidate baselines after fetch:

- `v8.0.13`
- `v8.0.13+311`
- `upstream/master@77cd957e`

Decision: use fixed baseline `upstream/master@77cd957e` for the first dry-run. This is not a moving-head integration; it is a pinned post-release baseline that includes the `AltSource.json` update for `8.0.13+311`.

## First Integration Shape

Recommended first execution after this planning task:

1. Create a disposable worktree and throwaway branch from `master`.
2. Attempt integration of `77cd957e`.
3. Record conflict inventory and posture decisions.
4. Abort or reset the throwaway branch after capturing findings, unless the user explicitly approves turning it into a real integration branch.
5. Create a separate execution task for the real integration using the captured conflict inventory.

This reduces risk because the current fork has broad local changes while upstream's latest delta is narrow but concentrated in archive protocol and release metadata.

## Rollback

- Planning task rollback: revert only files under `.trellis/tasks/06-04-upstream-integration-operating-model/`.
- Dry-run integration rollback: delete the throwaway branch/worktree after saving conflict notes.
- Real integration rollback: reset only the integration branch before merge to stable; do not touch `master` until validation passes and the user approves.
