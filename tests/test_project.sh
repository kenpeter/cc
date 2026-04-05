#!/usr/bin/env bash
# Project Structure Tests
# Verifies multi-project setup and install script work

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

echo "=== Project Structure Tests ==="

# --- install.md ---
echo ""
echo "[install.md]"
assert "install.md exists" test -f "$TEAM_DIR/install.md"
assert_grep "install.md has quick install" "Quick Install" "$TEAM_DIR/install.md"
assert_grep "install.md has project name" "PROJECT_NAME\|project-name\|my-project" "$TEAM_DIR/install.md"
assert_grep "install.md has symlink step" "symlink\|ln -s" "$TEAM_DIR/install.md"
assert_grep "install.md shows directory structure" "Directory Structure" "$TEAM_DIR/install.md"
assert_grep "install.md has multi-project example" "Multi-Project\|project-alpha\|project-beta" "$TEAM_DIR/install.md"
assert_grep "install.md has uninstall" "Uninstall" "$TEAM_DIR/install.md"

# --- install.sh ---
echo ""
echo "[install.sh]"
assert "install.sh exists" test -f "$TEAM_DIR/install.sh"
assert "install.sh is executable" test -x "$TEAM_DIR/install.sh"
assert_grep "install.sh takes project name arg" "PROJECT_NAME\|project-name" "$TEAM_DIR/install.sh"
assert_grep "install.sh creates projects dir" "projects" "$TEAM_DIR/install.sh"
assert_grep "install.sh copies log templates" "_log.md" "$TEAM_DIR/install.sh"
assert_not_grep "install.sh does NOT copy lesson templates (removed)" "_lesson\.md\|lesson_" "$TEAM_DIR/install.sh"
assert_grep "install.sh includes reviewer agent" "reviewer" "$TEAM_DIR/install.sh"
assert_grep "install.sh creates .kilo symlink" ".kilo" "$TEAM_DIR/install.sh"
assert_grep "install.sh creates .opencode" ".opencode" "$TEAM_DIR/install.sh"
assert_grep "install.sh creates .claude" ".claude" "$TEAM_DIR/install.sh"
assert_grep "install.sh AGENTS.md references special-1" "special-1" "$TEAM_DIR/install.sh"
assert_grep "install.sh AGENTS.md references overseer" "overseer" "$TEAM_DIR/install.sh"

# --- projects directory ---
echo ""
echo "[Projects Directory]"
assert "projects/ directory exists" test -d "$TEAM_DIR/projects"

# --- Agent references project state ---
echo ""
echo "[Agent State References]"
assert_grep "factseeker reads AGENTS.md for state path" "AGENTS.md" "$KIL/agent/factseeker.md"
assert_grep "planer reads AGENTS.md for state path" "AGENTS.md" "$KIL/agent/planer.md"
assert_grep "coder reads AGENTS.md for state path" "AGENTS.md" "$KIL/agent/coder.md"
assert_grep "simplifer reads AGENTS.md for state path" "AGENTS.md" "$KIL/agent/simplifer.md"
assert_grep "tester reads AGENTS.md for state path" "AGENTS.md" "$KIL/agent/tester.md"
assert_grep "reviewer reads AGENTS.md for state path" "AGENTS.md" "$KIL/agent/reviewer.md"
assert_grep "factseeker references project-state log" "project-state" "$KIL/agent/factseeker.md"
assert_grep "planer references project-state plan" "project-state.*planer_plan\|planer_plan" "$KIL/agent/planer.md"
assert_grep "coder references project-state plan" "project-state.*planer_plan\|planer_plan" "$KIL/agent/coder.md"

# --- Install dry run ---
echo ""
echo "[Install Dry Run]"
# Clean up any leftover test project first
rm -rf "$TEAM_DIR/projects/test-install-$$"
bash "$TEAM_DIR/install.sh" "test-install-$$" "$TEAM_DIR" > /dev/null 2>&1 || true
PROJECT_DIR="$TEAM_DIR/projects/test-install-$$"
if [ -d "$PROJECT_DIR" ]; then
    echo "  ✅ install.sh creates project state dir"
    PASS=$((PASS+1))
    assert "project has factseeker_log.md" test -f "$PROJECT_DIR/factseeker_log.md"
    assert "project has planer_log.md" test -f "$PROJECT_DIR/planer_log.md"
    assert "project has planer_plan.md" test -f "$PROJECT_DIR/planer_plan.md"
    assert "project has coder_log.md" test -f "$PROJECT_DIR/coder_log.md"
    assert "project has simplifer_log.md" test -f "$PROJECT_DIR/simplifer_log.md"
    assert "project has tester_log.md" test -f "$PROJECT_DIR/tester_log.md"
    assert "project has reviewer_log.md" test -f "$PROJECT_DIR/reviewer_log.md"
    LESSON_COUNT=$(find "$PROJECT_DIR" -name "*_lesson.md" | wc -l)
    assert "project has NO lesson files (removed)" test "$LESSON_COUNT" -eq 0
    LOG_COUNT=$(find "$PROJECT_DIR" -name "*_log.md" | wc -l)
    assert "project has 6 log files (all agents)" test "$LOG_COUNT" -eq 6
    # cleanup
    rm -rf "$PROJECT_DIR"
else
    echo "  ❌ install.sh creates project state dir"
    FAIL=$((FAIL+1))
fi

echo ""
echo "=== Project Tests: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
