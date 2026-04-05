# Universal Skill System (OpenCode, KiloCode, Claude Code)

## Overview

This is a universal skill system design that works across OpenCode, KiloCode, and Claude Code. Each platform has its own conventions but the core concept is the same: skills are reusable prompts with metadata.

---

## Platform Paths

| Platform | Path | Config File |
|----------|------|------------|
| **OpenCode** | `.opencode/skills/` | `SKILL.md` |
| **KiloCode** | `.kilo/skills/` | `SKILL.md` |
| **Claude Code** | `.claude/skills/` | `SKILL.md` |
| **Legacy** | `.claude/commands/` | `*.md` |

## Universal Frontmatter Fields

```yaml
---
name: skill-name
description: What this skill does
version: 1.0.0
user-invocable: true  # Can user invoke via /skill-name
allowed-tools: [BashTool, FileReadTool]
argument-hint: Optional <args> description
arguments: arg1, arg2
when_to_use: When to use this skill
model: sonnet  # Model to use (optional)
disable-model-invocation: false
context: fork  # Run in fork (separate context)
agent: agent-name  # Delegate to another agent
effort: medium  # low, medium, high
paths:  # Conditional skill - only active when these paths are touched
  - src/**/*.ts
  - src/**/*.js
shell: inline  # inline, fork - how to execute shell commands
---

# Skill prompt body
```

---

## Skill Loading Hierarchy

| Source | Path | Priority |
|--------|------|----------|
| Policy | `~/.claude/managed/.claude/skills/` | Highest |
| User | `~/.claude/skills/` | |
| Project | `.claude/skills/` | |
| Additional | `--add-dir` paths | Lowest |

---

## Dynamic Skill Discovery

Skills can be discovered dynamically when matching files are touched:

```yaml
paths:
  - src/auth/**/*.ts
```

When a file matching `src/auth/**/*.ts` is edited, the skill becomes active.

---

## Skill Types

| Type | Description |
|------|-------------|
| `prompt` | LLM prompt skill (this format) |
| `command` | Legacy format |

---

## Bundled Skills

Claude Code has built-in skills compiled into the binary:
- `autoresearch` - Autonomous iteration loop
- `batch` - Batch processing
- `debug` - Debugging helper
- `verify` - Verification helper
- `simplify` - Code simplification
- `remember` - Memory/notes

---

## Skill Command Structure

```typescript
type Command = {
  type: 'prompt' | 'command'
  name: string
  description: string
  hasUserSpecifiedDescription: boolean
  allowedTools: string[]
  argumentHint?: string
  whenToUse?: string
  model?: string
  disableModelInvocation: boolean
  userInvocable: boolean
  context?: 'inline' | 'fork'
  agent?: string
  effort?: 'low' | 'medium' | 'high'
  paths?: string[]
  hooks?: HooksSettings
  skillRoot?: string
  source: 'user' | 'project' | 'plugin' | 'bundled' | 'mcp'
  loadedFrom: string
  isHidden: boolean
  progressMessage: string
  getPromptForCommand: (args: string, context: ToolUseContext) => Promise<ContentBlockParam[]>
}
```

---

## Integration with Team Pipeline

Ideas to adopt:

1. **Conditional Skills** - Skills activate only when relevant files are touched
2. **Effort Levels** - Specify low/medium/high effort for skills
3. **Agent Delegation** - Skills can delegate to specific agents
4. **Shell Integration** - Inline vs fork shell execution modes
5. **Path-Based Activation** - Skills for auth, api, db specific areas
6. **Version Tracking** - Skills can specify version for compatibility
