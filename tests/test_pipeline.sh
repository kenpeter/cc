#!/usr/bin/env bash
# Pipeline Regression Tests
# Verifies the pipeline structure, order, and flow are correct

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
echo ""

# --- Pipeline Order ---
echo "[Pipeline Order]"
assert "workflow.md exists" test -f "$KIL/command/workflow.md"
assert_grep "pipeline order is factseeker → planer → coder → simplifer → tester" \
    "factseeker → planer → coder → simplifer → tester" "$KIL/command/workflow.md"
assert_grep "simplifer comes before tester" \
    "simplifer → tester" "$KIL/command/workflow.md"
assert_not_grep "NOT old order (tester before simplifer)" \
    "tester → simplifer" "$KIL/command/workflow.md"

# --- Pipeline Stage Definitions ---
echo ""
echo "[Pipeline Stages]"
assert_grep "Stage 1 is Fact Seeker" "Stage 1: Fact Seeker" "$KIL/command/workflow.md"
assert_grep "Stage 2 is Planner" "Stage 2: Planner" "$KIL/command/workflow.md"
assert_grep "Stage 3 is Coder" "Stage 3: Coder" "$KIL/command/workflow.md"
assert_grep "Stage 4 is Simplifier" "Stage 4: Simplifier" "$KIL/command/workflow.md"
assert_grep "Stage 5 is Tester" "Stage 5: Tester" "$KIL/command/workflow.md"

# --- Loop Rules ---
echo ""
echo "[Loop Rules]"
assert_grep "Tester fail goes back to Coder" "Tester FAIL" "$KIL/command/workflow.md"
assert_grep "Tester pass means done" "Tester PASS.*complete" "$KIL/command/workflow.md" || \
assert_grep "Tester pass means done" "PASS.*Workflow complete" "$KIL/command/workflow.md"
assert_grep "Ambiguity goes back to Fact Seeker" "Fact Seeker" "$KIL/command/workflow.md"

# --- Model Config ---
echo ""
echo "[Model Config]"
assert_grep "Cheap model in workflow" "cheapest\|cheap\|fast.*model" "$KIL/command/workflow.md"
assert_grep "factseeker has cheap model" "cheapest\|cheap" "$KIL/agent/factseeker.md"
assert_grep "planer has cheap model" "cheapest\|cheap" "$KIL/agent/planer.md"
assert_grep "coder has cheap model" "cheapest\|cheap" "$KIL/agent/coder.md"
assert_grep "simplifer has cheap model" "cheapest\|cheap" "$KIL/agent/simplifer.md"
assert_grep "tester has cheap model" "cheapest\|cheap" "$KIL/agent/tester.md"

# --- Special Commands ---
echo ""
echo "[Special Commands]"
assert "special-1 command exists" test -f "$KIL/command/special-1.md"
assert "special-2 command exists" test -f "$KIL/command/special-2.md"
assert_grep "special-1 has 1 agent per stage" "1 Agent Per Stage\|1 agent\|x1" "$KIL/command/special-1.md"
assert_grep "special-2 has 2 agents per stage" "2 Agent\|2 agents\|x2\|Doubled" "$KIL/command/special-2.md"
assert_grep "special-2 has merge strategy" "merge" "$KIL/command/special-2.md"
assert_grep "workflow references special-1" "special-1" "$KIL/command/workflow.md"
assert_grep "workflow references special-2" "special-2" "$KIL/command/workflow.md"

echo ""
echo "=== Pipeline Tests: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
