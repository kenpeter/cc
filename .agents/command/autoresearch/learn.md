---
name: autoresearch:learn
description: Autonomous codebase documentation engine: scout, learn, generate/update docs
argument-hint: "[--mode mode] [--scope glob] [--depth level] [--scan]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS:
- `--mode {mode}` — operation: init, update, check, summarize
- `--scope {glob}` — limit learning to specific dirs
- `--depth {level}` — doc comprehensiveness: quick, standard, deep
- `--scan` — force fresh scout in summarize mode
- `Iterations:` or `--iterations N` — bounded mode

## Execution

1. Read the learn workflow: `.claude/skills/autoresearch/references/learn-workflow.md`
2. Execute the codebase documentation protocol

Stream all output live — never run in background.
