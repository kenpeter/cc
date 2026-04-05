---
name: autoresearch:debug
description: Autonomous bug-hunting loop: scientific method + iterative investigation
argument-hint: "[Issue: <text>] [Scope: <glob>] [Symptom: <text>] [--iterations N]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS:
- `Issue:` or `Symptom:` — description of the bug
- `Scope:` — file globs to investigate
- `Iterations:` or `--iterations N` — bounded mode

## Execution

1. Read the debug workflow: `.claude/skills/autoresearch/references/debug-workflow.md`
2. Execute the autonomous bug-hunting loop

Stream all output live — never run in background.
