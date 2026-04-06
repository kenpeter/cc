# Universal Modes, Personas & Effort System (OpenCode, KiloCode, Claude Code)

## Overview

Claude Code has sophisticated mode/persona/effort systems that can be adapted universally.

---

## Modes Across Platforms

| Mode | OpenCode | KiloCode | Claude Code | Description |
|------|----------|----------|-------------|-------------|
| **fastMode** | - | - | ✅ | Quick responses, less thinking |
| **briefMode** | - | - | ✅ | Concise output |
| **planMode** | plan command | plan command | ✅ | Plan before implementing |
| **ultraplan** | - | - | ✅ | Remote Opus planning |
| **undercover** | - | - | ✅ | Hide internal info |

---

## Effort Levels

Claude Code uses effort levels that control how much thinking the model does:

| Effort | OpenCode | KiloCode | Claude Code | Use Case |
|--------|----------|----------|-------------|----------|
| **low** | - | - | ✅ | Quick simple tasks |
| **medium** | ✅ | ✅ | ✅ | Default for most tasks |
| **high** | - | - | ✅ (`ultrathink`) | Complex reasoning |
| **custom** | - | - | ✅ | Model-specific |

### Ultrathink Keyword

Users can trigger high effort with the `ultrathink` keyword:

```
# In prompt
+2M
Goal: Design a new architecture
ultrathink
```

---

## Fast Mode

```python
# Python-style concept
class FastMode:
    enabled: bool
    price_tier: str = "reduced"
    thinking_budget: int = None  # Less thinking
    
# Fast mode pricing (Claude Code)
def get_opus_cost_tier(fast_mode: bool) -> ModelCosts:
    if fast_mode:
        return REDUCED_TIER
    return STANDARD_TIER
```

---

## Plan Mode

### Workflow
1. User requests planning → enters plan mode
2. Model writes plan to file
3. User reviews and approves/rejects
4. If approved → exits plan mode, implements

### Plan Mode Variations

| Type | Description |
|------|-------------|
| `plan` | Interactive plan writing |
| `ultraplan` | Offload to remote Opus session |
| `planModeRequired` | Teammates must get approval |

### Plan Mode Attachment Types

```python
PLAN_MODE_ATTACHMENTS = [
    'plan_mode',        # Initial plan
    'plan_mode_reentry', # Returning to existing plan
    'plan_mode_exit',   # Exited plan mode
    'ultrathink_effort', # High effort mode
]
```

---

## Teammate System

### Teammate Types

| Type | OpenCode | KiloCode | Claude Code |
|------|----------|----------|-------------|
| **In-process** | - | - | ✅ AsyncLocalStorage |
| **Tmux-based** | - | - | ✅ CLI spawned |
| **Remote** | - | - | ✅ WebSocket |

### Teammate Features

```python
class Teammate:
    id: str           # Unique agent ID
    name: str        # Display name
    color: str       # UI color
    team_name: str   # Parent team
    plan_mode_required: bool  # Must get approval
    model: str       # Assigned model
    
# Teammate communication via mailbox
class TeammateMailbox:
    inbox_path: str  # .claude/teams/{team}/inboxes/{agent}.json
```

### Teammate States

| State | Description |
|-------|-------------|
| `running` | Actively working |
| `idle` | Waiting for tasks |
| `terminated` | Stopped |

---

## Swarm / Multi-Agent

### Agent Types

| Type | OpenCode | KiloCode | Claude Code |
|------|----------|----------|-------------|
| **Leader** | task | task | ✅ Coordinates |
| **Worker** | - | - | ✅ Executes tasks |
| **Teammate** | - | - | ✅ In swarm |

### Spawn Options

```python
SPAWN_OPTIONS = {
    'name': str,           # Agent name
    'prompt': str,        # System prompt
    'model': str,         # Model to use
    'color': str,         # UI color
    'team_name': str,     # Team identifier
    'plan_mode_required': bool,  # Approval required
    'backend': str,       # tmux, iterm2, in-process
}
```

---

## Persona Concepts

### Built-in Personas

| Persona | Description | Use Case |
|---------|-------------|----------|
| **Architect** | System design | High-level planning |
| **Security Analyst** | Security review | Auditing |
| **Performance Engineer** | Optimization | Performance tuning |
| **Devil's Advocate** | Critique | Adversarial testing |

### Custom Persona Creation

```yaml
---
name: persona-name
description: What this persona does
model: sonnet
allowed-tools: [BashTool, FileReadTool]
effort: medium
---

# Persona prompt
You are an expert in...
```

---

## Universal Ideas

1. **Effort Levels** - low/medium/high with keyword triggers
2. **Mode System** - fast/brief/plan/ultra modes
3. **Teammate Architecture** - spawn, coordinate, communicate
4. **Plan Mode Workflow** - plan → review → approve → implement
5. **Persona Templates** - reusable expert configurations

---

## Platform Mapping

| Concept | OpenCode | KiloCode | Claude Code |
|---------|----------|----------|-------------|
| Task model | `task` | `task` | TaskCreateTool |
| Agent spawn | - | - | spawnMultiAgent |
| Plan workflow | /plan | /plan | plan mode |
| Effort config | - | - | effort settings |
| Team concept | - | - | teammate system |
