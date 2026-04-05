#!/usr/bin/env bash
# Pipeline Regression Tests
# Verifies the pipeline structure, order, flow, and self-evolution are correct

set -euo pipefail

TEAM_DIR="$(cd "$(dirname "$0")/.." && pwd)"
KIL="$TEAM_DIR/.kilo"
PASS=0
FAIL=0

assert() {
    local desc="$1"
    shift
    if "$@"; then
        echo "  ✅ $desc"
        PASS=$((PASS+1))
    else
        echo "  ❌ $desc"
        FAIL=$((FAIL+1))
    fi
}

assert_grep() {
    local desc="$1"
    local pattern="$2"
    local file="$3"
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo "  ✅ $desc"
        PASS=$((PASS+1))
    else
        echo "  ❌ $desc"
        FAIL=$((FAIL+1))
    fi
}

assert_not_grep() {
    local desc="$1"
    local pattern="$2"
    local file="$3"
    if ! grep -q "$pattern" "$file" 2>/dev/null; then
        echo "  ✅ $desc"
        PASS=$((PASS+1))
    else
        echo "  ❌ $desc"
        FAIL=$((FAIL+1))
    fi
}

echo "=== Pipeline Regression Tests ==="

# --- Canonical pipeline file ---
echo ""
echo "[Canonical Pipeline: special-1.md]"
assert "special-1.md exists" test -f "$KIL/command/special-1.md"
assert_grep "pipeline references factseeker" "factseeker" "$KIL/command/special-1.md"
assert_grep "pipeline references planer" "planer" "$KIL/command/special-1.md"
assert_grep "pipeline references coder" "coder" "$KIL/command/special-1.md"
assert_grep "pipeline references simplifer" "simplifer" "$KIL/command/special-1.md"
assert_grep "pipeline references tester" "tester" "$KIL/command/special-1.md"
assert_grep "pipeline references reviewer" "reviewer" "$KIL/command/special-1.md"
assert_grep "simplifer comes before tester" "simplifer.*tester" "$KIL/command/special-1.md"
assert_not_grep "NOT old order (tester before simplifer)" "tester.*simplifer" "$KIL/command/special-1.md"

# --- Pipeline Stages ---
echo ""
echo "[Pipeline Stages]"
assert_grep "Fact Seeker stage exists" "Fact Seeker" "$KIL/command/special-1.md"
assert_grep "Planner stage exists" "Planner\|planer" "$KIL/command/special-1.md"
assert_grep "Coder stage exists" "Coder\|coder" "$KIL/command/special-1.md"
assert_grep "Simplifier stage exists" "Simplif" "$KIL/command/special-1.md"
assert_grep "Tester stage exists" "Tester\|tester" "$KIL/command/special-1.md"
assert_grep "Reviewer stage exists" "Reviewer\|reviewer" "$KIL/command/special-1.md"
assert_grep "Overseer stage exists (chat window)" "Overseer\|overseer\|chat window" "$KIL/command/special-1.md"

# --- Loop Rules ---
echo ""
echo "[Loop Rules]"
assert_grep "Tester FAIL goes back to Coder" "FAIL.*[Cc]oder\|[Cc]oder.*FAIL\|back to.*[Cc]oder" "$KIL/command/special-1.md"
assert_grep "Reviewer REJECT goes back to a stage" "REJECT.*back\|back to.*stage\|back to" "$KIL/command/special-1.md"
assert_grep "pipeline can LOOP to next iteration" "LOOP\|loop\|next loop\|repeat" "$KIL/command/special-1.md"
assert_grep "pipeline can be DONE" "DONE\|done\|complete" "$KIL/command/special-1.md"

# --- Self-Evolution ---
echo ""
echo "[Self-Evolution via Overseer]"
assert_grep "overseer reads log files after run" "reads.*log\|log.*files\|all.*log" "$KIL/command/special-1.md"
assert_grep "overseer injects lessons into AGENTS.md" "AGENTS.md" "$KIL/command/special-1.md"
assert_grep "overseer extracts abstract lessons" "abstract\|lessons\|lesson" "$KIL/command/special-1.md"
assert_not_grep "no separate reflector agent in pipeline" "reflector agent\|Reflector Agent" "$KIL/command/special-1.md"
assert_grep "next loop starts with Fact Seeker reading updated AGENTS.md" "Fact Seeker.*updated\|updated.*AGENTS\|reads.*AGENTS" "$KIL/command/special-1.md"

# --- Model Config ---
echo ""
echo "[Model Config]"
assert_grep "factseeker uses cheap model" "cheapest\|cheap" "$KIL/agent/factseeker.md"
assert_grep "planer uses cheap model" "cheapest\|cheap" "$KIL/agent/planer.md"
assert_grep "coder uses cheap model" "cheapest\|cheap" "$KIL/agent/coder.md"
assert_grep "simplifer uses cheap model" "cheapest\|cheap" "$KIL/agent/simplifer.md"
assert_grep "tester uses cheap model" "cheapest\|cheap" "$KIL/agent/tester.md"
assert_grep "reviewer uses cheap model" "cheapest\|cheap" "$KIL/agent/reviewer.md"

# --- Special Commands ---
echo ""
echo "[Special Commands]"
assert "special-1 command exists" test -f "$KIL/command/special-1.md"
assert "special-2 command exists" test -f "$KIL/command/special-2.md"
assert_grep "special-1 has 1 agent per stage" "1 Agent Per Stage\|1 agent\|x1\|single agent\|Standard Pipeline" "$KIL/command/special-1.md"
assert_grep "special-2 has 2 agents per stage" "2 Agent\|2 agents\|x2\|Doubled" "$KIL/command/special-2.md"
assert_grep "special-2 has merge strategy" "merge" "$KIL/command/special-2.md"

# --- workflow.md is gone or deprecated ---
echo ""
echo "[workflow.md Absent or Deprecated]"
if [ -f "$KIL/command/workflow.md" ]; then
    assert_not_grep "workflow.md does NOT define a pipeline (deprecated)" "Stage 1.*Fact\|## Pipeline.*factseeker" "$KIL/command/workflow.md"
else
    assert "workflow.md is absent (removed, special-1 is canonical)" test ! -f "$KIL/command/workflow.md"
fi

echo ""
echo "=== Pipeline Tests: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
