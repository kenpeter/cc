# Install Guide

Install the agent team pipeline into any project.

## Quick Install

```bash
# From your project root
TEAM_DIR="/path/to/team"  # path to this repo
PROJECT_NAME="my-project" # your project name

# 1. Create project state directory
mkdir -p "$TEAM_DIR/projects/$PROJECT_NAME"

# 2. Copy agent state templates (logs, lessons, plans)
for agent in factseeker planer coder simplifer tester; do
    cp "$TEAM_DIR/.kilo/agent/${agent}_log.md" \
       "$TEAM_DIR/projects/$PROJECT_NAME/${agent}_log.md"
    cp "$TEAM_DIR/.kilo/agent/${agent}_lesson.md" \
       "$TEAM_DIR/projects/$PROJECT_NAME/${agent}_lesson.md"
done
cp "$TEAM_DIR/.kilo/agent/planer_plan.md" \
   "$TEAM_DIR/projects/$PROJECT_NAME/planer_plan.md"

# 3. Create .kilo symlink (or copy)
ln -s "$TEAM_DIR/.kilo" .kilo

# 4. Create .opencode symlink
mkdir -p .opencode
ln -s "$TEAM_DIR/.kilo/agent" .opencode/agent
ln -s "$TEAM_DIR/.kilo/command" .opencode/command
echo "# Agent Team — $PROJECT_NAME" > .opencode/AGENTS.md

# 5. Create .claude symlink
mkdir -p .claude
ln -s "$TEAM_DIR/.kilo/agent" .claude/agent
ln -s "$TEAM_DIR/.kilo/command" .claude/command
echo "# Agent Team — $PROJECT_NAME" > .claude/AGENTS.md

# 6. Create .cursorrules and .clinerules
cat > .cursorrules << 'EOF'
# Agent Team — 5-stage pipeline
## Pipeline: factseeker → planer → coder → simplifer → tester → repeat
Read AGENTS.md and .kilo/ for full instructions.
EOF

cat > .clinerules << 'EOF'
# Agent Team — 5-stage pipeline
## Pipeline: factseeker → planer → coder → simplifer → tester → repeat
Read AGENTS.md and .kilo/ for full instructions.
EOF

# 7. Create root AGENTS.md with project name
cat > AGENTS.md << EOF
# Agent Team — $PROJECT_NAME

## Pipeline
factseeker → planer → coder → simplifer → tester → repeat

## Project State
All agent logs, lessons, and plans live in:
\`$TEAM_DIR/projects/$PROJECT_NAME/\`

## Agents
| Agent | State Files |
|-------|-------------|
| Fact Seeker | \`${PROJECT_NAME}/factseeker_log.md\`, \`${PROJECT_NAME}/factseeker_lesson.md\` |
| Planner | \`${PROJECT_NAME}/planer_plan.md\`, \`${PROJECT_NAME}/planer_log.md\`, \`${PROJECT_NAME}/planer_lesson.md\` |
| Coder | \`${PROJECT_NAME}/coder_log.md\`, \`${PROJECT_NAME}/coder_lesson.md\` |
| Simplifier | \`${PROJECT_NAME}/simplifer_log.md\`, \`${PROJECT_NAME}/simplifer_lesson.md\` |
| Tester | \`${PROJECT_NAME}/tester_log.md\`, \`${PROJECT_NAME}/tester_lesson.md\` |

## Commands
- \`/workflow <problem>\` — run full pipeline
- \`/special-1\` — 1 agent per stage
- \`/special-2\` — 2 agents per stage (doubled up)

See \`.kilo/command/workflow.md\` for details.
EOF

echo "✅ Agent team installed for project: $PROJECT_NAME"
echo "   Project state: $TEAM_DIR/projects/$PROJECT_NAME/"
```

## Directory Structure After Install

```
your-project/
├── .kilo → symlink to team repo .kilo
├── .opencode/
│   ├── AGENTS.md
│   ├── agent → symlink to .kilo/agent
│   └── command → symlink to .kilo/command
├── .claude/
│   ├── AGENTS.md
│   ├── agent → symlink to .kilo/agent
│   └── command → symlink to .kilo/command
├── .cursorrules
├── .clinerules
└── AGENTS.md

team-repo/
├── .kilo/
│   ├── agent/        ← shared agent definitions
│   └── command/      ← shared commands
└── projects/
    └── my-project/   ← your project state
        ├── factseeker_log.md
        ├── factseeker_lesson.md
        ├── planer_plan.md
        ├── planer_log.md
        ├── planer_lesson.md
        ├── coder_log.md
        ├── coder_lesson.md
        ├── simplifer_log.md
        ├── simplifer_lesson.md
        ├── tester_log.md
        └── tester_lesson.md
```

## Multi-Project Example

```bash
# Project A
./install.sh project-alpha /home/team

# Project B
./install.sh project-beta /home/team

# Each gets its own state:
# /home/team/projects/project-alpha/  — logs, lessons, plans for alpha
# /home/team/projects/project-beta/   — logs, lessons, plans for beta
```

## How Agents Know Which Project

When agents start, they read state from:
- `projects/<project-name>/factseeker_log.md`
- `projects/<project-name>/planer_plan.md`
- etc.

The project name is set in your project's `AGENTS.md`. Agents read that file first to know which project state to use.

## Uninstall

```bash
rm -rf .kilo .opencode .claude .cursorrules .clinerules AGENTS.md
```
