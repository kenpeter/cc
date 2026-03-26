# Team Workflow

The agent pipeline runs in a strict sequence. Each agent hands off to the next. If any agent fails, the cycle restarts from the beginning.

## Pipeline

```
factseeker → planer → coder → simplifer → tester → [repeat for next problem]
```

## Model

All agents use the **cheapest, fastest model** available. Speed over power. Save tokens.

## How to Run

Invoke the full workflow on any problem:

```
/workflow <problem description>
```

Or run individual stages:

```
/factseeker <topic>
/planer <fact_report>
/coder <execution_plan>
/simplifer <code_changes>
/tester <simplified_code>
```

Special modes:

```
/special-1    — run pipeline with 1 agent per stage (standard)
/special-2    — run pipeline with 2 agents per stage (doubled up)
```

## Stage Details

### Stage 1: Fact Seeker
**Agent**: `factseeker.md`
**Files**: `factseeker_log.md`, `factseeker_lesson.md`
**Input**: Problem description or question
**Output**: Fact Report with evidence, confirmed facts, risks, relevant files
**Gate**: Cannot proceed without complete fact report

### Stage 2: Planner
**Agent**: `planer.md`
**Files**: `planer_plan.md`, `planer_log.md`, `planer_lesson.md`
**Input**: Fact Report from Stage 1
**Output**: Execution Plan written to `planer_plan.md`
**Gate**: Cannot proceed without actionable step-by-step plan

### Stage 3: Coder
**Agent**: `coder.md`
**Files**: `coder_log.md`, `coder_lesson.md`
**Input**: Plan from `planer_plan.md`
**Output**: Implemented code changes, one step at a time, verified after each
**Gate**: All plan steps complete, no deviations without justification

### Stage 4: Simplifier
**Agent**: `simplifer.md`
**Files**: `simplifer_log.md`, `simplifer_lesson.md`
**Input**: Code from Coder
**Output**: Simplified, cleaned code. Run tests before handing to Tester
**Gate**: Code is cleaner, smaller, tests pass, lint/types clean

### Stage 5: Tester
**Agent**: `tester.md`
**Files**: `tester_log.md`, `tester_lesson.md`
**Input**: Simplified code from Stage 4
**Output**: Test report with pass/fail, coverage, regression results
**Gate**: ALL tests must pass. Fail = back to Coder with specific issues

## Loop Rules

- **Tester PASS**: Workflow complete for this problem
- **Tester FAIL**: Go back to Coder with specific failures
- **Simplifier breaks tests**: Go back to Coder to fix
- **Ambiguity at any stage**: Go back to Fact Seeker for more investigation
- **New problem**: Start fresh from Fact Seeker

## Principles

1. **No skipping stages** — each builds on the last
2. **Gates are hard** — no green light, no go
3. **Iterate until clean** — run the full cycle as many times as needed
4. **Small changes** — each cycle should be a small, safe improvement
5. **Evidence over opinion** — Fact Seeker's data drives all decisions
6. **Cheap models** — all agents use fast/cheap models, save tokens
7. **Log everything** — every agent reads/writes its log and lesson files
