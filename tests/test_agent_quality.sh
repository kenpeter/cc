#!/usr/bin/env bash
# Agent Quality Check Tests
# Verifies each agent has required files and proper structure

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

assert_not_grep() {
    local desc="$1"
    local pattern="$2"
    local file="$3"
    if ! grep -qi "$pattern" "$file" 2>/dev/null; then
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
    assert_not_grep "no _lesson.md file reference (lessons removed)" "_lesson\.md\|lesson file\|lesson_" "$KIL/agent/$agent.md"

    assert_grep "agent reads AGENTS.md at startup" "AGENTS.md" "$KIL/agent/$agent.md"
    assert_grep "agent reads log at startup" "log" "$KIL/agent/$agent.md"
    assert_grep "agent updates log after task" "update.*log\|log.*update" "$KIL/agent/$agent.md"
    assert_grep "agent has Startup section" "startup\|before every task\|before each task" "$KIL/agent/$agent.md"
    assert_grep "agent has Rules section" "## Rules" "$KIL/agent/$agent.md"
    assert_grep "agent has Output section" "output format\|output\|report" "$KIL/agent/$agent.md"
}

echo "=== Agent Quality Check Tests ==="

check_agent "factseeker"
check_agent "planer"
check_agent "coder"
check_agent "simplifer"
check_agent "tester"
check_agent "reviewer"

# --- No lesson files should exist ---
echo ""
echo "[No Lesson Files (removed)]"
LESSON_COUNT=$(find "$KIL/agent" -name "*_lesson.md" -maxdepth 1 | wc -l)
assert "zero lesson files exist" test "$LESSON_COUNT" -eq 0

# --- Planner Special: plan.md ---
echo ""
echo "[Planner Special Files]"
assert "planer_plan.md exists" test -f "$KIL/agent/planer_plan.md"
assert_grep "planer references plan.md" "planer_plan\|plan.md" "$KIL/agent/planer.md"
assert_grep "planer writes to plan.md" "write.*plan\|plan.*write" "$KIL/agent/planer.md"

# --- Agent Count ---
echo ""
echo "[Agent Count]"
LOG_COUNT=$(find "$KIL/agent" -name "*_log.md" -maxdepth 1 | wc -l)
assert "6 agents have log files (factseeker planer coder simplifer tester reviewer)" test "$LOG_COUNT" -eq 6

# --- Cross-References ---
echo ""
echo "[Cross-References]"
assert_grep "coder reads planer_plan.md" "planer_plan" "$KIL/agent/coder.md"
assert_grep "reviewer reads tester_log.md" "tester_log\|tester.*log" "$KIL/agent/reviewer.md"
assert_grep "reviewer reads planer_plan.md" "planer_plan\|plan" "$KIL/agent/reviewer.md"

# --- AGENTS.md: overseer injects lessons ---
echo ""
echo "[AGENTS.md — Overseer Self-Evolution]"
assert_grep "AGENTS.md has Team Lessons section" "Team Lessons" "$TEAM_DIR/.claude/AGENTS.md"
assert_grep "AGENTS.md references overseer" "overseer\|chat window" "$TEAM_DIR/.claude/AGENTS.md"
assert_not_grep "AGENTS.md does NOT reference reflector agent" "reflector" "$TEAM_DIR/.claude/AGENTS.md"

# --- special-1 references overseer ---
echo ""
echo "[special-1 — Overseer Pipeline]"
assert_grep "special-1 has overseer step" "overseer\|chat window" "$KIL/command/special-1.md"
assert_grep "special-1 injects into AGENTS.md" "AGENTS.md" "$KIL/command/special-1.md"
assert_grep "special-1 has reviewer stage" "reviewer\|Reviewer" "$KIL/command/special-1.md"

echo ""
echo "=== Quality Tests: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
