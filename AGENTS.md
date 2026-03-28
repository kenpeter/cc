# Agent Team Configuration

This project uses a 6-agent pipeline for all development work.

## Agents

| Agent | Role | File |
|-------|------|------|
| Fact Seeker | Research & evidence gathering | `.kilo/agent/factseeker.md` |
| Planner | Strategy & step-by-step plans | `.kilo/agent/planer.md` |
| Coder | Implementation | `.kilo/agent/coder.md` |
| Simplifier | Cleanup & simplification | `.kilo/agent/simplifer.md` |
| Tester | Testing & verification | `.kilo/agent/tester.md` |
| Reviewer | Final quality gate & approval | `.kilo/agent/reviewer.md` |

## Workflow

See `.kilo/command/special-1.md` for the full pipeline.

```
factseeker → planer → loop[ coder → simplifer → eval ] → tester → factseeker (next problem)
```

## Rules

1. Always start with Fact Seeker — never guess, always investigate
2. Plan before coding — no cowboy coding
3. Inner loop: coder → simplifier → eval until it passes (max 5 iterations)
4. Eval failure goes back to Coder with specific failures listed
5. Tester is the final gate — fail goes back into the inner loop
6. Loop until done — iterate the full pipeline as needed
