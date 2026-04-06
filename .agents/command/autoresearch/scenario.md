---
name: autoresearch:scenario
description: Scenario-driven use case generator: explore situations, edge cases, derivative scenarios
argument-hint: "[Scenario: <text>] [Domain: <type>] [--depth level] [--focus area]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS:
- `Scenario:` — seed scenario to explore
- `Domain:` — domain type (software, product, business, security, marketing)
- `--depth {level}` — exploration depth: shallow, standard, deep
- `--focus {area}` — prioritize dimension: edge-cases, failures, security, scale
- `Iterations:` or `--iterations N` — bounded mode

## Execution

1. Read the scenario workflow: `.claude/skills/autoresearch/references/scenario-workflow.md`
2. Execute the scenario exploration protocol

Stream all output live — never run in background.
