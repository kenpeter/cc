# /special-1 — Standard Pipeline (1 Agent Per Stage)

Run the full pipeline with a single agent at each stage.

## Pipeline

```
factseeker(1) → planer(1) → coder(1) → simplifer(1) → tester(1) → done
```

## Execution

Each stage runs once, sequentially. This is the default mode.

### Stage 1: Fact Seeker x1
- One agent investigates
- Produces one Fact Report
- Logs to `factseeker_log.md`

### Stage 2: Planner x1
- One agent reads Fact Report
- Writes plan to `planer_plan.md`
- Logs to `planer_log.md`

### Stage 3: Coder x1
- One agent reads `planer_plan.md`
- Implements all steps
- Logs to `coder_log.md`

### Stage 4: Simplifier x1
- One agent cleans code
- Runs tests before handoff
- Logs to `simplifer_log.md`

### Stage 5: Tester x1
- One agent runs all tests
- Produces Test Report
- Logs to `tester_log.md`

## When to Use

- Default mode for all tasks
- Simple bugs, small features, refactors
- When speed matters more than thoroughness
