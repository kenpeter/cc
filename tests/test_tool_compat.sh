#!/usr/bin/env bash
# Tool Compatibility Tests
# Verifies kilocode, opencode, and claude code all work with the agent team setup

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

echo "=== Tool Compatibility Tests ==="

# --- KiloCode ---
echo ""
echo "[KiloCode (.kilo)]"
assert ".kilo directory exists" test -d "$KIL"
assert ".kilo/agent/ exists" test -d "$KIL/agent"
assert ".kilo/command/ exists" test -d "$KIL/command"
assert "special-1.md in .kilo/command" test -f "$KIL/command/special-1.md"
assert "special-2.md in .kilo/command" test -f "$KIL/command/special-2.md"
assert "factseeker.md exists" test -f "$KIL/agent/factseeker.md"
assert "planer.md exists" test -f "$KIL/agent/planer.md"
assert "coder.md exists" test -f "$KIL/agent/coder.md"
assert "simplifer.md exists" test -f "$KIL/agent/simplifer.md"
assert "tester.md exists" test -f "$KIL/agent/tester.md"
assert "reviewer.md exists" test -f "$KIL/agent/reviewer.md"

# --- OpenCode ---
echo ""
echo "[OpenCode (.opencode)]"
assert ".opencode directory exists" test -d "$TEAM_DIR/.opencode"
assert ".opencode/AGENTS.md exists" test -f "$TEAM_DIR/.opencode/AGENTS.md"
assert ".opencode/agent symlink exists" test -L "$TEAM_DIR/.opencode/agent"
assert ".opencode/command symlink exists" test -L "$TEAM_DIR/.opencode/command"
assert "opencode agent symlink resolves" test -f "$TEAM_DIR/.opencode/agent/factseeker.md"
assert "opencode can read special-1" test -f "$TEAM_DIR/.opencode/command/special-1.md"
assert "opencode can read special-2" test -f "$TEAM_DIR/.opencode/command/special-2.md"
assert "opencode can read log files" test -f "$TEAM_DIR/.opencode/agent/factseeker_log.md"
assert "opencode can read plan.md" test -f "$TEAM_DIR/.opencode/agent/planer_plan.md"
assert "opencode can read reviewer.md" test -f "$TEAM_DIR/.opencode/agent/reviewer.md"

# --- Claude Code ---
echo ""
echo "[Claude Code (.claude)]"
assert ".claude directory exists" test -d "$TEAM_DIR/.claude"
assert ".claude/AGENTS.md exists" test -f "$TEAM_DIR/.claude/AGENTS.md"
assert ".claude/agent symlink exists" test -L "$TEAM_DIR/.claude/agent"
assert ".claude/command symlink exists" test -L "$TEAM_DIR/.claude/command"
assert "claude agent symlink resolves" test -f "$TEAM_DIR/.claude/agent/factseeker.md"
assert "claude can read special-1" test -f "$TEAM_DIR/.claude/command/special-1.md"
assert "claude can read special-2" test -f "$TEAM_DIR/.claude/command/special-2.md"
assert "claude can read log files" test -f "$TEAM_DIR/.claude/agent/factseeker_log.md"
assert "claude can read plan.md" test -f "$TEAM_DIR/.claude/agent/planer_plan.md"
assert "claude can read reviewer.md" test -f "$TEAM_DIR/.claude/agent/reviewer.md"
assert_grep "claude AGENTS.md has Team Lessons section" "Team Lessons" "$TEAM_DIR/.claude/AGENTS.md"
assert_grep "claude AGENTS.md references overseer" "overseer\|chat window" "$TEAM_DIR/.claude/AGENTS.md"

# --- Cursor / Cline ---
echo ""
echo "[Cursor / Cline]"
assert ".cursorrules exists" test -f "$TEAM_DIR/.cursorrules"
assert ".clinerules exists" test -f "$TEAM_DIR/.clinerules"
assert_grep ".cursorrules references agents" "factseeker" "$TEAM_DIR/.cursorrules"
assert_grep ".clinerules references agents" "factseeker" "$TEAM_DIR/.clinerules"

# --- Root AGENTS.md ---
echo ""
echo "[Root Config]"
assert "root AGENTS.md exists" test -f "$TEAM_DIR/AGENTS.md"
assert_grep "root lists Fact Seeker" "Fact Seeker" "$TEAM_DIR/AGENTS.md"
assert_grep "root lists Planner" "Planner" "$TEAM_DIR/AGENTS.md"
assert_grep "root lists Coder" "Coder" "$TEAM_DIR/AGENTS.md"
assert_grep "root lists Tester" "Tester" "$TEAM_DIR/AGENTS.md"
assert_grep "root lists Simplifier" "Simplifier" "$TEAM_DIR/AGENTS.md"

# --- Symlink Integrity ---
echo ""
echo "[Symlink Integrity]"
assert "opencode agent symlink not broken" ls "$TEAM_DIR/.opencode/agent/" > /dev/null 2>&1
assert "opencode command symlink not broken" ls "$TEAM_DIR/.opencode/command/" > /dev/null 2>&1
assert "claude agent symlink not broken" ls "$TEAM_DIR/.claude/agent/" > /dev/null 2>&1
assert "claude command symlink not broken" ls "$TEAM_DIR/.claude/command/" > /dev/null 2>&1

# --- File Parity ---
echo ""
echo "[File Parity — all tools see same agent files]"
KILO_FILES=$(find "$KIL/agent" -maxdepth 1 -name "*.md" | wc -l)
OPENCODE_FILES=$(find -L "$TEAM_DIR/.opencode/agent" -maxdepth 1 -name "*.md" | wc -l)
CLAUDE_FILES=$(find -L "$TEAM_DIR/.claude/agent" -maxdepth 1 -name "*.md" | wc -l)
assert "opencode sees same agent files as kilo" test "$KILO_FILES" -eq "$OPENCODE_FILES"
assert "claude sees same agent files as kilo" test "$KILO_FILES" -eq "$CLAUDE_FILES"

# --- No lesson files anywhere ---
echo ""
echo "[No Lesson Files]"
KILO_LESSONS=$(find "$KIL/agent" -name "*_lesson.md" -maxdepth 1 | wc -l)
assert "no lesson files in .kilo/agent" test "$KILO_LESSONS" -eq 0

# --- install.md ---
echo ""
echo "[Install Guide]"
assert "install.md exists" test -f "$TEAM_DIR/install.md"

echo ""
echo "=== Tool Tests: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
