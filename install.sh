#!/usr/bin/env bash
# Install agent team into a project
# Usage: ./install.sh <project-name> [team-dir]

set -euo pipefail

PROJECT_NAME="${1:?Usage: ./install.sh <project-name> [team-dir]}"
TEAM_DIR="${2:-$(cd "$(dirname "$0")" && pwd)}"
TARGET_DIR="$(pwd)"

echo "Installing agent team for: $PROJECT_NAME"
echo "Team dir: $TEAM_DIR"
echo "Target dir: $TARGET_DIR"
echo ""

# 1. Create project state directory
mkdir -p "$TEAM_DIR/projects/$PROJECT_NAME"

# 2. Copy agent log templates (no lesson files — overseer handles team knowledge via AGENTS.md)
for agent in factseeker planer coder simplifer tester reviewer; do
    if [ ! -f "$TEAM_DIR/projects/$PROJECT_NAME/${agent}_log.md" ]; then
        cp "$TEAM_DIR/.kilo/agent/${agent}_log.md" \
           "$TEAM_DIR/projects/$PROJECT_NAME/${agent}_log.md"
        echo "  Created ${agent}_log.md"
    fi
done
if [ ! -f "$TEAM_DIR/projects/$PROJECT_NAME/planer_plan.md" ]; then
    cp "$TEAM_DIR/.kilo/agent/planer_plan.md" \
       "$TEAM_DIR/projects/$PROJECT_NAME/planer_plan.md"
    echo "  Created planer_plan.md"
fi

# 3. Create .kilo symlink
if [ ! -e "$TARGET_DIR/.kilo" ]; then
    ln -s "$TEAM_DIR/.kilo" "$TARGET_DIR/.kilo"
    echo "  Linked .kilo"
fi

# 4. Create .opencode
mkdir -p "$TARGET_DIR/.opencode"
if [ ! -e "$TARGET_DIR/.opencode/agent" ]; then
    ln -s "$TEAM_DIR/.kilo/agent" "$TARGET_DIR/.opencode/agent"
fi
if [ ! -e "$TARGET_DIR/.opencode/command" ]; then
    ln -s "$TEAM_DIR/.kilo/command" "$TARGET_DIR/.opencode/command"
fi
if [ ! -f "$TARGET_DIR/.opencode/AGENTS.md" ]; then
    cat > "$TARGET_DIR/.opencode/AGENTS.md" << EOF
# Agent Team — $PROJECT_NAME

## Pipeline: factseeker → planer → loop[ coder → simplifer → eval ] → tester → reviewer → overseer → AGENTS.md → repeat

Project state: \`$TEAM_DIR/projects/$PROJECT_NAME/\`

Read \`.kilo/command/special-1.md\` for full pipeline details.
EOF
fi

# 5. Create .claude
mkdir -p "$TARGET_DIR/.claude"
if [ ! -e "$TARGET_DIR/.claude/agent" ]; then
    ln -s "$TEAM_DIR/.kilo/agent" "$TARGET_DIR/.claude/agent"
fi
if [ ! -e "$TARGET_DIR/.claude/command" ]; then
    ln -s "$TEAM_DIR/.kilo/command" "$TARGET_DIR/.claude/command"
fi
if [ ! -f "$TARGET_DIR/.claude/AGENTS.md" ]; then
    cat > "$TARGET_DIR/.claude/AGENTS.md" << EOF
# Agent Team — $PROJECT_NAME

## Pipeline: factseeker → planer → loop[ coder → simplifer → eval ] → tester → reviewer → overseer → AGENTS.md → repeat

Project state: \`$TEAM_DIR/projects/$PROJECT_NAME/\`

Read \`.kilo/command/special-1.md\` for full pipeline details.

---

## How to Read This File

Every agent reads this file at startup. It contains:
1. **Project context** — where things are, how the project works
2. **Team Lessons** — abstract lessons injected by the overseer (chat window agent) after each full pipeline run

---

## Team Lessons

> Written by the overseer (chat window agent) after reading all *_log.md files from a completed run.
> Format: \`### [YYYY-MM-DD] [Title]\` / \`**Pattern**: ...\` / \`**Applies to**: [agent names]\`

*No lessons yet.*

---
EOF
fi

# 6. Create .cursorrules
if [ ! -f "$TARGET_DIR/.cursorrules" ]; then
    cat > "$TARGET_DIR/.cursorrules" << 'EOF'
# Agent Team — 6-stage pipeline with self-evolution
## Pipeline: factseeker → planer → coder → simplifer → tester → reviewer → overseer → AGENTS.md → repeat
Read AGENTS.md and .kilo/ for full instructions.
EOF
    echo "  Created .cursorrules"
fi

# 7. Create .clinerules
if [ ! -f "$TARGET_DIR/.clinerules" ]; then
    cat > "$TARGET_DIR/.clinerules" << 'EOF'
# Agent Team — 6-stage pipeline with self-evolution
## Pipeline: factseeker → planer → coder → simplifer → tester → reviewer → overseer → AGENTS.md → repeat
Read AGENTS.md and .kilo/ for full instructions.
EOF
    echo "  Created .clinerules"
fi

# 8. Create root AGENTS.md
if [ ! -f "$TARGET_DIR/AGENTS.md" ]; then
    cat > "$TARGET_DIR/AGENTS.md" << EOF
# Agent Team — $PROJECT_NAME

## Pipeline
factseeker → planer → loop[ coder → simplifer → eval ] → tester → reviewer → overseer → AGENTS.md → repeat

## Project State
All agent logs and plans live in:
\`$TEAM_DIR/projects/$PROJECT_NAME/\`

## Agents
| Agent | Role | State Files |
|-------|------|-------------|
| Fact Seeker | Investigates codebase | \`factseeker_log.md\` |
| Planner | Writes execution plan | \`planer_plan.md\`, \`planer_log.md\` |
| Coder | Implements plan | \`coder_log.md\` |
| Simplifier | Cleans code | \`simplifer_log.md\` |
| Tester | Runs full test suite | \`tester_log.md\` |
| Reviewer | Final quality gate | \`reviewer_log.md\` |

## Overseer
The chat window (Claude Code session) monitors the full flow, reads all logs after reviewer approves, extracts abstract lessons, and injects them into \`AGENTS.md\` before the next loop.

## Commands
- \`/special-1\` — 1 agent per stage (default)
- \`/special-2\` — 2 agents per stage (high-risk tasks)
EOF
    echo "  Created AGENTS.md"
fi

echo ""
echo "✅ Agent team installed for project: $PROJECT_NAME"
echo "   Project state: $TEAM_DIR/projects/$PROJECT_NAME/"
