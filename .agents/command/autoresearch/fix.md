---
name: autoresearch:fix
description: Autonomous fix loop: iteratively repair errors until zero remain
argument-hint: "[Target: <text>] [Scope: <glob>] [--from-debug] [--guard cmd]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS:
- `Target:` — what to fix (tests, types, lint, build)
- `Scope:` — file globs to modify
- `--from-debug` — consume debug handoff
- `--guard {cmd}` — regression prevention command
- `Iterations:` or `--iterations N` — bounded mode

## Execution

1. Read the fix workflow: `.claude/skills/autoresearch/references/fix-workflow.md`
2. Execute the autonomous fix loop

Stream all output live — never run in background.
