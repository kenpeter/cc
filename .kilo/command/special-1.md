---
name: special-1
description: Run the standard agent team pipeline with 1 agent per stage. The chat window (overseer agent) runs each stage, reads all logs, injects abstract lessons into AGENTS.md, then loops. Human is out of the loop.
---

# /special-1 — Standard Pipeline (Overseer-Driven Self-Evolution)

The **chat window is the overseer agent**. It runs each pipeline stage, monitors the full flow by reading logs, extracts abstract lessons, writes them to `AGENTS.md`, and triggers the next loop. No human intervention needed.

## Pipeline

```
┌──────────────────────────────────────────────────────────────┐
│                    OVERSEER (chat window)                    │
│                                                              │
│  factseeker → planer → ┌─[ coder → simplifer → eval ]─┐    │
│                         └──────── inner loop ───────────┘    │
│                    → tester → reviewer                       │
│                         │                                    │
│                         ▼                                    │
│         overseer reads all *_log.md files                    │
│         overseer extracts abstract lessons                   │
│         overseer injects lessons → AGENTS.md                 │
│                         │                                    │
│                         └──── next loop ────────────────────►│
└──────────────────────────────────────────────────────────────┘
```

## Execution

### Stage 1: Fact Seeker
- Reads `AGENTS.md` — picks up lessons overseer injected from prior runs
- Investigates codebase, gathers all facts
- Logs to `factseeker_log.md`

### Stage 2: Planner
- Reads Fact Report
- Writes execution plan to `planer_plan.md`
- Logs to `planer_log.md`

### Stage 3: Inner Loop — Coder → Simplifier → Eval
Repeat until tests pass (max 3 iterations):
1. **Coder** — implements from `planer_plan.md`, logs to `coder_log.md`
2. **Simplifier** — cleans code, runs tests, logs to `simplifer_log.md`
3. **Eval** — passing → exit loop; failing → back to Coder with issues

### Stage 4: Tester
- Runs full test suite, logs to `tester_log.md`
- 🔴 FAIL → back to Stage 3
- 🟢 PASS → proceed

### Stage 5: Reviewer
- End-to-end quality check, logs to `reviewer_log.md`
- 🔴 REJECT → back to appropriate stage
- 🟢 APPROVE → overseer takes over

### Stage 6: Overseer (chat window) — Lesson Extraction
After reviewer approves, the overseer:
1. Reads ALL log files from this run:
   - `factseeker_log.md`, `planer_log.md`, `coder_log.md`
   - `simplifer_log.md`, `tester_log.md`, `reviewer_log.md`
2. Extracts **abstract, cross-cutting lessons** — patterns that apply across agents and future runs
3. Injects them into `AGENTS.md` under `## Team Lessons`
4. Declares LOOP (more work) or DONE (goal fully met)

### Stage 7: Repeat or Done
- **LOOP** → Stage 1 restarts; Fact Seeker reads updated `AGENTS.md`
- **DONE** → pipeline complete

## What Makes a Good Lesson (for the overseer)

| Skip (too tactical) | Inject (abstract) |
|---|---|
| "Fixed bug in train.py line 42" | "Always check CUDA memory before launching KD training" |
| "Planner missed a file" | "Fact Seeker must enumerate all config files before planning" |
| "Tests failed on step 3" | "Module X and Y have a known integration fragility — test them together" |

Lessons answer: *what assumption does this team repeatedly get wrong?*

## When to Use

- Default for all tasks
- Use `/special-2` for complex bugs or high-risk changes (2 agents per stage)
