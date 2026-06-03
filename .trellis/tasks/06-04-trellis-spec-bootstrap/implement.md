# Implement: Refresh Trellis specs for JHenTai

## Execution Plan

1. Inspect the current spec tree and identify template leftovers, inaccurate claims, and already-good sections.
2. Read representative source files for:
   - app bootstrap and lifecycle
   - routing
   - page/logic/state patterns
   - services and settings
   - database and migrations
   - release packaging
   - tests
3. Update `.trellis/spec/` files with source-backed rules, examples, and anti-patterns.
4. Remove template wording and align both index files with the final spec set.
5. Verify no placeholder text remains and review the final diff for drift or generic advice.

## Validation

- `rg -n "placeholder|TBD|TODO: fill|Fill in each file|generic" .trellis/spec`
- Manual read-through of touched spec files

## Review Gates

- Before `task.py start`: planning artifacts describe the actual repo and intended spec changes.
- Before completion: spec docs contain local patterns, not boilerplate.

## Rollback

- Spec-only task. Revert the touched `.trellis/spec/` files if the new wording proves less accurate than the prior version.
