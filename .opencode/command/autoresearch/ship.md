---
name: autoresearch:ship
description: Universal shipping workflow: ship code, content, marketing, sales, research, or anything
argument-hint: "[Target: <path>] [--type type] [--dry-run] [--auto] [--force] [--monitor N]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS:
- `Target:` — what to ship
- `--type {type}` — shipment type override
- `--dry-run` — validate without shipping
- `--auto` — auto-approve dry-run gate
- `--force` — skip non-critical checklist items
- `--monitor N` — post-ship monitoring minutes
- `Iterations:` or `--iterations N` — bounded mode

## Execution

1. Read the ship workflow: `.claude/skills/autoresearch/references/ship-workflow.md`
2. Execute the 8-phase shipping protocol

Stream all output live — never run in background.
