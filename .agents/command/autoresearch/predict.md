---
name: autoresearch:predict
description: Multi-persona swarm prediction: pre-analyze code from multiple expert perspectives
argument-hint: "[Goal: <text>] [Scope: <glob>] [--chain targets] [--depth level]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS:
- `Goal:` — analysis objective
- `Scope:` — file globs to analyze
- `--chain {targets}` — chain to downstream tools
- `--depth {level}` — depth preset: shallow, standard, deep
- `--adversarial` — use adversarial persona set
- `Iterations:` or `--iterations N` — bounded mode

## Execution

1. Read the predict workflow: `.claude/skills/autoresearch/references/predict-workflow.md`
2. Execute the multi-persona swarm analysis

Stream all output live — never run in background.
