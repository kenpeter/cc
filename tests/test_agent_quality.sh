#!/usr/bin/env bash
# Agent Quality Check Tests
# Verifies each agent has all required files and proper structure

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
    if grep -qi "$pattern" "$file" 2>/dev/null; then
        echo "  ✅ $desc"
        PASS=$((PASS+1))
    else
        echo "  ❌ $desc"
        FAIL=$((FAIL+1))
    fi
}

check_agent() {
    local agent="$1"
    echo ""
    echo "[Agent: $agent]"

    assert "agent definition exists" test -f "$KIL/agent/$agent.md"
    assert "log file exists" test -f "$KIL/agent/${agent}_log.md"
    assert "lesson file exists" test -f "$KIL/agent/${agent}_lesson.md"

    assert_grep "agent references log" "log" "$KIL/agent/$agent.md"
    assert_grep "agent references lesson" "lesson" "$KIL/agent/$agent.md"
    assert_grep "agent has Startup section" "startup\|before every task\|before each task" "$KIL/agent/$agent.md"
    assert_grep "agent has Rules section" "## Rules" "$KIL/agent/$agent.md"
    assert_grep "agent has Output section" "output format\|output\|report" "$KIL/agent/$agent.md"

    assert_grep "log has entry format" "format\|status\|date" "$KIL/agent/${agent}_log.md"
    assert_grep "lesson has pattern sections" "pattern" "$KIL/agent/${agent}_lesson.md"
}

echo "=== Agent Quality Check Tests ==="

check_agent "factseeker"
check_agent "planer"
check_agent "coder"
check_agent "simplifer"
check_agent "tester"

# --- Planner Special: plan.md ---
echo ""
echo "[Planner Special Files]"
assert "planer_plan.md exists" test -f "$KIL/agent/planer_plan.md"
assert_grep "planer references plan.md" "planer_plan\|plan.md" "$KIL/agent/planer.md"
assert_grep "planer writes to plan.md" "write.*plan\|plan.*write" "$KIL/agent/planer.md"

# --- Agent Count ---
echo ""
echo "[Agent Count]"
AGENT_COUNT=$(find "$KIL/agent" -name "*_log.md" -maxdepth 1 | wc -l)
assert "5 agents have log files" test "$AGENT_COUNT" -eq 5
LESSON_COUNT=$(find "$KIL/agent" -name "*_lesson.md" -maxdepth 1 | wc -l)
assert "5 agents have lesson files" test "$LESSON_COUNT" -eq 5

# --- Cross-References ---
echo ""
echo "[Cross-References]"
assert_grep "coder reads planer_plan.md" "planer_plan" "$KIL/agent/coder.md"
assert_grep "workflow refs factseeker" "factseeker" "$KIL/command/workflow.md"
assert_grep "workflow refs planer" "planer" "$KIL/command/workflow.md"
assert_grep "workflow refs coder" "coder" "$KIL/command/workflow.md"
assert_grep "workflow refs simplifer" "simplifer" "$KIL/command/workflow.md"
assert_grep "workflow refs tester" "tester" "$KIL/command/workflow.md"

echo ""
echo "=== Quality Tests: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
