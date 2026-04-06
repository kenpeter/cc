#!/usr/bin/env bash
# Coordinate System Tests
# Verifies the coordinate.md system for directing agents is correctly implemented

set -euo pipefail

TEAM_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COORD_FILE="$TEAM_DIR/coordinate.md"
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

echo "=== Coordinate System Tests ==="

# --- File Existence ---
echo ""
echo "[Coordinate File]"
assert "coordinate.md exists" test -f "$COORD_FILE"

# --- Core Sections ---
echo ""
echo "[Core Sections]"
assert_grep "Coordinate System title" "# Coordinate System for Work/CC Agent Direction" "$COORD_FILE"
assert_grep "Coordinator Role section" "## Coordinator Role" "$COORD_FILE"
assert_grep "Agent Direction Principles section" "## Agent Direction Principles" "$COORD_FILE"
assert_grep "Worker Context Rules section" "### 3. Worker Context Rules" "$COORD_FILE"
assert_grep "Continue vs. Spawn Decision section" "### 4. Continue vs. Spawn Decision" "$COORD_FILE"
assert_grep "Workflow Coordination section" "### 5. Workflow Coordination" "$COORD_FILE"
assert_grep "Example Session Structure section" "### 6. Example Session Structure" "$COORD_FILE"
assert_grep "Quality Gates section" "### 7. Quality Gates" "$COORD_FILE"
assert_grep "Lesson Extraction section" "### Lesson Extraction" "$COORD_FILE"

# --- Coordinator Role Content ---
echo ""
echo "[Coordinator Role Content]"
assert_grep "Direct agents to research" "Direct agents to research, implement, and verify" "$COORD_FILE"
assert_grep "Synthesize results" "Synthesize results and make decisions" "$COORD_FILE"

# --- Agent Types ---
echo ""
echo "[Agent Types Documentation]"
assert_grep "Fact Seeker agent" "Fact Seeker.*Research.*evidence gathering" "$COORD_FILE"
assert_grep "Planner agent" "Planner.*Strategy.*step-by-step plans" "$COORD_FILE"
assert_grep "Coder agent" "Coder.*Implementation" "$COORD_FILE"
assert_grep "Simplifier agent" "Simplifier.*Cleanup.*simplification" "$COORD_FILE"
assert_grep "Tester agent" "Tester.*Testing.*verification" "$COORD_FILE"
assert_grep "Reviewer agent" "Reviewer.*Final quality gate.*approval" "$COORD_FILE"

# --- Direction Syntax ---
echo ""
echo "[Direction Syntax]"
assert_grep "Direction Syntax section" "### 2. Direction Syntax" "$COORD_FILE"
assert_grep "Agent direction format" "\[AGENT_TYPE\].*{" "$COORD_FILE"
assert_grep "Self-contained prompt requirement" "Every prompt must be self-contained" "$COORD_FILE"
assert_grep "No lazy delegation warning" "Never write.*based on your findings" "$COORD_FILE"

# --- Continue vs. Spawn ---
echo ""
echo "[Continue vs. Spawn Framework]"
assert_grep "Continue when conditions" "Continue when:" "$COORD_FILE"
assert_grep "Spawn fresh when conditions" "Spawn fresh when:" "$COORD_FILE"
assert_grep "Continue when context overlap is high" "Continue when:" "$COORD_FILE"
assert_grep "Spawn fresh when context overlap is low" "Spawn fresh when:" "$COORD_FILE"

# --- Workflow Coordination ---
echo ""
echo "[Workflow Coordination]"
assert_grep "Standard workflow reference" "6-agent pipeline" "$COORD_FILE"
assert_grep "Pipeline visualization" "factseeker → planer → \[coder → simplifier → eval\] (inner loop)" "$COORD_FILE"
assert_grep "Overseer coordination" "overseer.*coordinator" "$COORD_FILE"

# --- Example Session ---
echo ""
echo "[Example Session Structure]"
assert_grep "Initial Direction example" "Initial Direction:" "$COORD_FILE"
assert_grep "Fact Seeker example" "Fact Seeker" "$COORD_FILE"
assert_grep "Planner example" "Planner" "$COORD_FILE"
assert_grep "Coder example" "Coder" "$COORD_FILE"
assert_grep "Tester example" "Tester" "$COORD_FILE"

# --- Quality Gates ---
echo ""
echo "[Quality Gates]"
assert_grep "Fact Seeker exit criteria" "Fact Seeker: Complete evidence collection" "$COORD_FILE"
assert_grep "Planner exit criteria" "Planner: Clear, actionable step-by-step plan" "$COORD_FILE"
assert_grep "Coder exit criteria" "Coder: Working implementation that compiles/runs" "$COORD_FILE"
assert_grep "Simplifier exit criteria" "Simplifier: Clean, simplified code that passes tests" "$COORD_FILE"
assert_grep "Tester exit criteria" "Tester: All tests pass with no regressions" "$COORD_FILE"
assert_grep "Reviewer exit criteria" "Reviewer: Final quality check approves the work" "$COORD_FILE"

# --- Ground Rules and Lesson Extraction ---
echo ""
echo "[Ground Rules Section]"
assert_grep "Ground Rules for Agent Direction" "## Ground Rules for Agent Direction" "$COORD_FILE"
assert_grep "Evidence-Based Direction subsection" "### Evidence-Based Direction" "$COORD_FILE"
assert_grep "Precision and Actionability subsection" "### Precision and Actionability" "$COORD_FILE"
assert_grep "Anti-Lazy Direction subsection" "### Anti-Lazy Direction" "$COORD_FILE"

echo ""
echo "[Lesson Extraction Section]"
assert_grep "Lesson extraction process" "After reviewer approval, the coordinator:" "$COORD_FILE"
assert_grep "Read all agent logs" "Reads all agent logs from this run" "$COORD_FILE"
assert_grep "Extract abstract lessons" "Extracts abstract, cross-cutting lessons" "$COORD_FILE"
assert_grep "Inject lessons into AGENTS.md" "Injects lessons into AGENTS.md" "$COORD_FILE"
assert_grep "Loop/Done determination" "Determines if more work is needed.*LOOP.*or if goal is met.*DONE" "$COORD_FILE"

# --- Integration with Existing Files ---
echo ""
echo "[Integration Checks]"
assert_grep "References AGENTS.md" "AGENTS.md" "$COORD_FILE"
assert_grep "References .kilo directory" "\.kilo/" "$COORD_FILE"
assert_grep "Does not contradict workflow concept" "6-agent pipeline\|factseeker.*planer.*coder.*simplifer.*tester.*reviewer" "$COORD_FILE"

echo ""
echo "=== Coordinate Tests: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
