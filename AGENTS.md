# Agent Team Configuration

This project uses a 5-agent pipeline for all development work.

## Agents

| Agent | Role | File |
|-------|------|------|
| Fact Seeker | Research & evidence gathering | `.kilo/agent/factseeker.md` |
| Planner | Strategy & step-by-step plans | `.kilo/agent/planer.md` |
| Coder | Implementation | `.kilo/agent/coder.md` |
| Simplifier | Cleanup & simplification | `.kilo/agent/simplifer.md` |
| Tester | Testing & verification | `.kilo/agent/tester.md` |

## Workflow

See `.kilo/command/workflow.md` for the full pipeline.

```
factseeker → planer → coder → simplifer → tester → done
```

## Rules

1. Always start with Fact Seeker — never guess, always investigate
2. Plan before coding — no cowboy coding
3. Test everything — no green light, no ship
4. Simplify after testing — clean code is maintainable code
5. Loop until done — iterate the full pipeline as needed
