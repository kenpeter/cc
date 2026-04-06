---
name: autoresearch:reason
description: Adversarial refinement for subjective domains: isolated multi-agent generate→critique→synthesize→blind judge loop
argument-hint: "[Task: <text>] [Domain: <type>] [--mode mode] [--chain targets]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS:
- `Task:` — decision or question to refine
- `Domain:` — domain type (software, product, business, security, research, content)
- `--mode {mode}` — convergent, creative, debate
- `--chain {targets}` — chain to downstream tools
- `--judges N` — judge count (3-7, odd preferred)
- `Iterations:` or `--iterations N` — bounded mode

## Execution

1. Read the reason workflow: `.claude/skills/autoresearch/references/reason-workflow.md`
2. Execute the adversarial refinement loop

Stream all output live — never run in background.
