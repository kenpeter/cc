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

# 2. Copy agent state templates
for agent in factseeker planer coder simplifer tester; do
    if [ ! -f "$TEAM_DIR/projects/$PROJECT_NAME/${agent}_log.md" ]; then
        cp "$TEAM_DIR/.kilo/agent/${agent}_log.md" \
           "$TEAM_DIR/projects/$PROJECT_NAME/${agent}_log.md"
        echo "  Created ${agent}_log.md"
    fi
    if [ ! -f "$TEAM_DIR/projects/$PROJECT_NAME/${agent}_lesson.md" ]; then
        cp "$TEAM_DIR/.kilo/agent/${agent}_lesson.md" \
           "$TEAM_DIR/projects/$PROJECT_NAME/${agent}_lesson.md"
        echo "  Created ${agent}_lesson.md"
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
cat > "$TARGET_DIR/.opencode/AGENTS.md" << EOF
# Agent Team — $PROJECT_NAME

## Pipeline: factseeker → planer → coder → simplifer → tester → repeat

Project state: \`$TEAM_DIR/projects/$PROJECT_NAME/\`

Read \`.kilo/command/workflow.md\` for full pipeline details.
EOF

# 5. Create .claude
mkdir -p "$TARGET_DIR/.claude"
if [ ! -e "$TARGET_DIR/.claude/agent" ]; then
    ln -s "$TEAM_DIR/.kilo/agent" "$TARGET_DIR/.claude/agent"
fi
if [ ! -e "$TARGET_DIR/.claude/command" ]; then
    ln -s "$TEAM_DIR/.kilo/command" "$TARGET_DIR/.claude/command"
fi
cat > "$TARGET_DIR/.claude/AGENTS.md" << EOF
# Agent Team — $PROJECT_NAME

## Pipeline: factseeker → planer → coder → simplifer → tester → repeat

Project state: \`$TEAM_DIR/projects/$PROJECT_NAME/\`

Read \`.kilo/command/workflow.md\` for full pipeline details.
EOF

# 6. Create .cursorrules
if [ ! -f "$TARGET_DIR/.cursorrules" ]; then
    cat > "$TARGET_DIR/.cursorrules" << 'EOF'
# Agent Team — 5-stage pipeline
## Pipeline: factseeker → planer → coder → simplifer → tester → repeat
Read AGENTS.md and .kilo/ for full instructions.
EOF
    echo "  Created .cursorrules"
fi

# 7. Create .clinerules
if [ ! -f "$TARGET_DIR/.clinerules" ]; then
    cat > "$TARGET_DIR/.clinerules" << 'EOF'
# Agent Team — 5-stage pipeline
## Pipeline: factseeker → planer → coder → simplifer → tester → repeat
Read AGENTS.md and .kilo/ for full instructions.
EOF
    echo "  Created .clinerules"
fi

# 8. Create root AGENTS.md
if [ ! -f "$TARGET_DIR/AGENTS.md" ]; then
    cat > "$TARGET_DIR/AGENTS.md" << EOF
# Agent Team — $PROJECT_NAME

## Pipeline
factseeker → planer → coder → simplifer → tester → repeat

## Project State
All agent logs, lessons, and plans live in:
\`$TEAM_DIR/projects/$PROJECT_NAME/\`

## Agents
| Agent | State Files |
|-------|-------------|
| Fact Seeker | \`factseeker_log.md\`, \`factseeker_lesson.md\` |
| Planner | \`planer_plan.md\`, \`planer_log.md\`, \`planer_lesson.md\` |
| Coder | \`coder_log.md\`, \`coder_lesson.md\` |
| Simplifier | \`simplifer_log.md\`, \`simplifer_lesson.md\` |
| Tester | \`tester_log.md\`, \`tester_lesson.md\` |

## Commands
- \`/workflow <problem>\` — run full pipeline
- \`/special-1\` — 1 agent per stage
- \`/special-2\` — 2 agents per stage (doubled up)
EOF
    echo "  Created AGENTS.md"
fi

echo ""
echo "✅ Agent team installed for project: $PROJECT_NAME"
echo "   Project state: $TEAM_DIR/projects/$PROJECT_NAME/"
