#!/usr/bin/env bash
# Universal System Tests
# Verifies skill, tool, task, and keybinding systems work across platforms

set -euo pipefail

TEAM_DIR="$(cd "$(dirname "$0")/.." && pwd)"
KIL="$TEAM_DIR/.kilo"
OPENCODE="$TEAM_DIR/.opencode"
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

echo "=== Universal System Tests ==="

# --- Skill System Tests ---
echo ""
echo "[Skill System - Universal]"

# Skill docs exist
assert "skill-system doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert "skill-system doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-skill-system.md"

# Universal frontmatter fields documented
assert_grep "name field documented" "name:" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "description field documented" "description:" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "version field documented" "version:" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "user-invocable field documented" "user-invocable:" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "allowed-tools field documented" "allowed-tools:" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "paths field documented (conditional)" "paths:" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"

# Platform paths documented
assert_grep "OpenCode path documented" ".opencode/skills" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "KiloCode path documented" ".kilo/skills" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "Claude Code path documented" ".claude/skills" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"

# Skill types documented
assert_grep "prompt type documented" "'prompt'" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "command type documented" "'command'" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"

# --- Tool System Tests ---
echo ""
echo "[Tool System - Universal]"

# Tool docs exist
assert "tool-system doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert "tool-system doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-tool-system.md"

# Universal tool concepts documented
assert_grep "File tools documented" "File" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "Shell tools documented" "Shell\|bash" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "Agent tools documented" "Agent\|agent" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "Search tools documented" "Search\|search" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"

# Platform tool mapping documented
assert_grep "OpenCode tools mapped" "OpenCode" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "KiloCode tools mapped" "KiloCode" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "Claude Code tools mapped" "Claude Code" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"

# Universal tool ideas
assert_grep "Tool presets idea documented" "Tool Presets" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "Feature flags idea documented" "Feature Flags" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "Simple mode idea documented" "Simple Mode" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "MCP support idea documented" "MCP" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"

# --- Task System Tests ---
echo ""
echo "[Task System - Universal]"

# Task docs exist
assert "task-system doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert "task-system doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-task-system.md"

# Task types documented across platforms
assert_grep "bash task documented" "bash" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_grep "agent task documented" "agent" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_grep "workflow task documented" "workflow" "$KIL/skills/autoresearch/references/claude-code-task-system.md"

# Platform task mapping
assert_grep "OpenCode task mapping" "OpenCode" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_grep "KiloCode task mapping" "KiloCode" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_grep "Claude Code task mapping" "Claude Code" "$KIL/skills/autoresearch/references/claude-code-task-system.md"

# Task status documented
assert_grep "pending status documented" "pending" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_grep "running status documented" "running" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_grep "completed status documented" "completed" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_grep "failed status documented" "failed" "$KIL/skills/autoresearch/references/claude-code-task-system.md"

# --- Keybinding System Tests ---
echo ""
echo "[Keybinding System - Universal]"

# Keybinding docs exist
assert "keybinding doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"
assert "keybinding doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-keybinding-system.md"

# Contexts documented
assert_grep "Global context documented" "Global" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"
assert_grep "Chat context documented" "Chat" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"
assert_grep "Task context documented" "Task" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"
assert_grep "Select context documented" "Select" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"

# Platform keybinding mapping
assert_grep "OpenCode in keybinding doc" "OpenCode" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"
assert_grep "KiloCode in keybinding doc" "KiloCode" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"
assert_grep "Claude Code in keybinding doc" "Claude Code" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"

# Keybinding ideas
assert_grep "Feature-gated bindings idea" "Feature-Gated" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"
assert_grep "Platform-specific bindings idea" "Platform" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"
assert_grep "Context-aware bindings idea" "Context-Aware" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"

# --- Cross-Reference Tests ---
echo ""
echo "[Cross-References]"

# All docs reference all 3 platforms
assert_grep "skill doc references OpenCode" "OpenCode" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "skill doc references KiloCode" "KiloCode" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "skill doc references Claude Code" "Claude Code" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"

assert_grep "tool doc references OpenCode" "OpenCode" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "tool doc references KiloCode" "KiloCode" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "tool doc references Claude Code" "Claude Code" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"

# --- Content Quality Tests ---
echo ""
echo "[Content Quality]"

# Not just Claude Code specific
assert_not_grep "skill doc not Claude Code only" "Claude Code ONLY\|only for Claude" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_not_grep "tool doc not Claude Code only" "Claude Code ONLY\|only for Claude" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_not_grep "task doc not Claude Code only" "Claude Code ONLY\|only for Claude" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_not_grep "keybinding doc not Claude Code only" "Claude Code ONLY\|only for Claude" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"

# Has practical ideas (not just theory)
assert_grep "skill doc has implementation detail" "type:" "$KIL/skills/autoresearch/references/claude-code-skill-system.md"
assert_grep "tool doc has implementation detail" "Tools" "$KIL/skills/autoresearch/references/claude-code-tool-system.md"
assert_grep "task doc has implementation detail" "TaskType\|task" "$KIL/skills/autoresearch/references/claude-code-task-system.md"
assert_grep "keybinding doc has implementation detail" "bindings:" "$KIL/skills/autoresearch/references/claude-code-keybinding-system.md"

# --- Token Efficiency Tests ---
echo ""
echo "[Token Efficiency]"

# Token efficiency doc exists
assert "token-efficiency doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"
assert "token-efficiency doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-token-efficiency.md"

# Token budget syntax documented
assert_grep "shorthand start format (+500k)" "\+500k" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"
assert_grep "shorthand end format (500k.)" "500k\." "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"
assert_grep "verbose format (use N tokens)" "use.*tokens\|spend.*tokens" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"

# Token counting documented
assert_grep "token counting method" "token.*count\|count.*token" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"
assert_grep "character-based estimation" "characters.*token\|4.*char" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"

# Platform token mapping
assert_grep "OpenCode token handling" "OpenCode" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"
assert_grep "KiloCode token handling" "KiloCode" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"
assert_grep "Claude Code token handling" "Claude Code" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"

# Token efficiency patterns
assert_grep "minimal prompts pattern" "Minimal\|minimal" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"
assert_grep "token budget pattern" "Budget\|budget" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"
assert_grep "caching pattern" "Cache\|cache" "$KIL/skills/autoresearch/references/claude-code-token-efficiency.md"

# --- Modes & Personas Tests ---
echo ""
echo "[Modes & Personas]"

# Modes/personas doc exists
assert "modes-personas doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert "modes-personas doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-modes-personas.md"

# Modes documented
assert_grep "fastMode documented" "fastMode" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "briefMode documented" "briefMode" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "planMode documented" "planMode\|plan mode" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "ultraplan documented" "ultraplan" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"

# Effort levels documented
assert_grep "effort levels documented" "Effort\|effort" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "low effort documented" "low" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "medium effort documented" "medium" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "high/ultrathink effort documented" "high\|ultrathink" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"

# Teammate system documented
assert_grep "teammate system documented" "Teammate\|teammate" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "swarm/multi-agent documented" "Swarm\|multi-agent" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "persona concept documented" "Persona\|persona" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"

# Platform modes mapping
assert_grep "OpenCode modes" "OpenCode" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "KiloCode modes" "KiloCode" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"
assert_grep "Claude Code modes" "Claude Code" "$KIL/skills/autoresearch/references/claude-code-modes-personas.md"

# --- Hooks & Events Tests ---
echo ""
echo "[Hooks & Events]"

# Hooks doc exists
assert "hooks-events doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert "hooks-events doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-hooks-events.md"

# Hook events documented
assert_grep "PreToolUse event" "PreToolUse" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "PostToolUse event" "PostToolUse" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "Notification event" "Notification" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "Stop event" "Stop" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"

# Hook types documented
assert_grep "command hook type" "type: command\|command hook" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "prompt hook type" "type: prompt\|prompt hook" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "http hook type" "type: http\|http hook" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "agent hook type" "type: agent\|agent hook" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"

# Hook options documented
assert_grep "if condition" "if:" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "matcher option" "matcher:" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "timeout option" "timeout:" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "once option" "once:" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"
assert_grep "async option" "async:" "$KIL/skills/autoresearch/references/claude-code-hooks-events.md"

# --- Worktree & Memory Tests ---
echo ""
echo "[Worktree & Memory]"

# Worktree/memory doc exists
assert "worktree-memory doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert "worktree-memory doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-worktree-memory.md"

# Worktree concepts documented
assert_grep "worktree concept" "Worktree\|worktree" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert_grep "session isolation" "isolation" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert_grep "git-based worktree" "git.*worktree\|Git.*based" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert_grep "hook-based worktree" "Hook.*based\|hook.*based" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"

# Dream/memory concepts documented
assert_grep "Dream system" "Dream\|dream" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert_grep "memory consolidation" "consolidation" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert_grep "autoDream" "autoDream\|auto.dream" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert_grep "MEMORY.md" "MEMORY\.md" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"

# Dream triggers documented
assert_grep "time gate" "Time\|time.*gate" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert_grep "session gate" "Session\|session.*gate" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"
assert_grep "lock gate" "Lock\|lock" "$KIL/skills/autoresearch/references/claude-code-worktree-memory.md"

# --- Analytics & Telemetry Tests ---
echo ""
echo "[Analytics & Telemetry]"

# Analytics doc exists
assert "analytics-telemetry doc exists in kilo" test -f "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"
assert "analytics-telemetry doc exists in opencode" test -f "$OPENCODE/skills/autoresearch/references/claude-code-analytics-telemetry.md"

# Analytics concepts documented
assert_grep "analytics concept" "Analytics\|analytics" "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"
assert_grep "event logging" "logEvent\|event.*log" "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"
assert_grep "error tracking" "error.*track\|Error" "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"

# Telemetry documented
assert_grep "telemetry concept" "Telemetry\|telemetry" "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"
assert_grep "OpenTelemetry" "OpenTelemetry\|OTLP" "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"
assert_grep "tracing" "Tracing\|trace" "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"
assert_grep "metrics" "Metrics\|metric" "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"

# Feature flags documented
assert_grep "feature flags" "Feature.*flag\|GrowthBook" "$KIL/skills/autoresearch/references/claude-code-analytics-telemetry.md"

echo ""
echo "=== Universal System Tests: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
