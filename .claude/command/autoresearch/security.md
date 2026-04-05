---
name: autoresearch:security
description: Autonomous security audit: STRIDE threat model + OWASP Top 10 + red-team
argument-hint: "[Scope: <glob>] [Focus: <text>] [--diff] [--fix] [--fail-on severity]"
---

EXECUTE IMMEDIATELY — do not deliberate, do not ask clarifying questions before reading the protocol.

## Argument Parsing (do this FIRST)

Extract from $ARGUMENTS:
- `Scope:` — file globs to audit
- `Focus:` — specific areas to concentrate on
- `--diff` — delta mode (only changed files)
- `--fix` — auto-fix Critical/High findings
- `--fail-on {severity}` — exit non-zero threshold
- `Iterations:` or `--iterations N` — bounded mode

## Execution

1. Read the security workflow: `.claude/skills/autoresearch/references/security-workflow.md`
2. Execute the security audit protocol

Stream all output live — never run in background.
