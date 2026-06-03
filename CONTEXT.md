# JHenTai Fork Maintenance

This context describes the language used to maintain this fork while integrating selected upstream JHenTai releases and preserving fork-owned behavior.

## Language

**Stable fork branch**:
The branch that represents the fork's releasable state and the base for normal fork-specific work. In this repository, `master` is the stable fork branch.
_Avoid_: stable, mainline, release branch

**Upstream integration branch**:
A temporary branch used to integrate a selected upstream release baseline before the result is allowed to affect the stable fork branch.
_Avoid_: merge branch, sync branch

**Fork-specific feature branch**:
A branch for new behavior owned by this fork, created from the stable fork branch rather than from an upstream integration branch.
_Avoid_: local feature branch, product branch

**Upstream release baseline**:
A pinned upstream tag or commit chosen as the integration target for a controlled upstream update.
_Avoid_: upstream head, latest upstream

**Fork-local workflow overlay**:
Developer-process files and task history that belong to this fork's maintenance workflow rather than to upstream application behavior.
_Avoid_: local tooling, agent files, workflow files

**Customization inventory**:
A lightweight record of fork-owned changes grouped by maintenance layer so upstream updates can be reviewed against known local intent.
_Avoid_: patch list, diff inventory

**Merge posture**:
The default conflict-resolution stance for a maintenance surface, such as upstream-first, local-first, field-by-field, key-completeness, regenerate-only, or fork-local preserve.
_Avoid_: merge strategy, conflict rule
