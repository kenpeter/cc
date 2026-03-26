# /special-2 — Doubled Pipeline (2 Agents Per Stage)

Run the full pipeline with TWO agents at each stage, working in parallel.

## Pipeline

```
factseeker(2) → planer(2) → coder(2) → simplifer(2) → tester(2) → done
```

## Execution

Each stage runs twice in parallel. Results are merged or the best is chosen.

### Stage 1: Fact Seeker x2
- Agent A investigates independently
- Agent B investigates independently
- Merge: combine findings, deduplicate, flag contradictions
- Both log to `factseeker_log.md`

### Stage 2: Planner x2
- Agent A creates Plan A from merged Fact Report
- Agent B creates Plan B from merged Fact Report
- Merge: compare plans, take best elements from each, or pick the stronger plan
- Final plan goes to `planer_plan.md`
- Both log to `planer_log.md`

### Stage 3: Coder x2
- Agent A implements from `planer_plan.md`
- Agent B implements from `planer_plan.md` independently
- Merge: compare diffs, pick cleaner implementation, or cherry-pick best parts
- Both log to `coder_log.md`

### Stage 4: Simplifier x2
- Agent A simplifies independently
- Agent B simplifies independently
- Merge: take the simpler result, or combine the best changes from both
- Both log to `simplifer_log.md`

### Stage 5: Tester x2
- Agent A runs full test suite
- Agent B runs full test suite with different edge cases
- Merge: combine test results, any fail = overall fail
- Both log to `tester_log.md`

## Merge Strategy

When two agents produce different results:
1. **Facts**: union all facts, flag contradictions for human review
2. **Plans**: pick the plan with lower risk, fewer steps, clearer verification
3. **Code**: pick the diff with fewer lines, cleaner style, fewer dependencies
4. **Simplified**: pick the version with fewer lines that still passes tests
5. **Tests**: union all tests, any failure = overall failure

## When to Use

- Complex bugs with unclear root cause
- Large features with many moving parts
- High-risk changes where double-checking matters
- When you want creative diversity in approach
- When one agent's approach fails, the other might succeed

## Cost

Doubles token usage per stage. Use sparingly. Default to `/special-1`.
