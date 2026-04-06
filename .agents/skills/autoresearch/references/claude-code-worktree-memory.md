# Universal Worktree & Memory System (OpenCode, KiloCode, Claude Code)

## Overview

Claude Code uses worktrees for session isolation and automatic memory consolidation.

---

## Worktree Management

### What is a Worktree?

A Git worktree allows checking out multiple branches simultaneously. Claude Code uses this to:
- Isolate each agent session in its own directory
- Prevent agents from interfering with each other
- Enable safe parallel execution

### Worktree Types

| Type | OpenCode | KiloCode | Claude Code |
|------|----------|----------|-------------|
| **Git-based** | - | - | ✅ `git worktree add` |
| **Hook-based** | - | - | ✅ Custom VCS hooks |
| **In-memory** | - | - | ✅ Ephemeral |

### Worktree Creation

```python
# Pseudo-code for worktree creation
def create_worktree(branch: str, path: str):
    """Create isolated worktree for session"""
    
    # 1. Git-based (preferred)
    if has_git_repo():
        run("git worktree add", path, branch)
    
    # 2. Hook-based (fallback)
    elif has_worktree_create_hook():
        run_hook("WorktreeCreate", path, branch)
    
    # 3. In-memory (last resort)
    else:
        use_ephemeral_mode()
```

### Worktree Features

- **Path isolation** - Each agent works in its own directory
- **Git integration** - Automatic branch management
- **Hook support** - Custom VCS (not just Git)
- **Cleanup** - Automatic removal on session end

---

## Dream / Memory Consolidation

### Concept

The "Dream" system automatically consolidates memory from past sessions:
- Runs as a background subagent
- Triggered by time and session thresholds
- Reads session transcripts
- Updates persistent memory files

### Dream Triggers

| Gate | Description |
|------|-------------|
| **Time** | Hours since last consolidation >= minHours (default: 24) |
| **Sessions** | New sessions >= minSessions (default: 5) |
| **Lock** | No other process mid-consolidation |

### Dream Process

```
1. Check gates (time, sessions, lock)
2. If open:
   a. Register dream task
   b. Build consolidation prompt
   c. Run forked agent (read-only)
   d. Collect file paths touched
   e. Complete task + inline summary
3. If locked/closed: skip
```

### Memory Files

| File | Purpose |
|------|---------|
| `MEMORY.md` | Primary memory file |
| `memory/*.md` | Extracted memories |
| `.claude/memdir/` | Memory directory |

### Dream Task Status

```python
class DreamTask:
    status: 'pending' | 'running' | 'completed' | 'failed' | 'killed'
    sessionsReviewing: int
    filesTouched: string[]
    priorMtime: number
```

---

## Universal Ideas

### 1. Worktree Isolation

```python
# For any platform
class WorktreeManager:
    def create(self, session_id: str) -> str:
        """Create isolated directory for session"""
        
    def remove(self, path: str):
        """Clean up worktree"""
        
    def exists(self, path: str) -> bool:
        """Check if worktree exists"""
```

### 2. Memory Consolidation

```python
# Background memory consolidation
class DreamConfig:
    min_hours: int = 24      # Time threshold
    min_sessions: int = 5    # Session threshold
    
def should_dream(config: DreamConfig) -> bool:
    """Check if consolidation should run"""
    return hours_since_last() >= config.min_hours
       and sessions_since_last() >= config.min_sessions
```

### 3. Session Isolation

| Platform | Isolation Method |
|----------|-----------------|
| OpenCode | Via project directories |
| KiloCode | Via project directories |
| Claude Code | Git worktrees + hooks |

### 4. Memory Types

| Type | Description |
|------|-------------|
| **Session Memory** | Current session context |
| **Project Memory** | Project-specific knowledge |
| **User Memory** | User preferences |

---

## Platform Mapping

| Concept | OpenCode | KiloCode | Claude Code |
|---------|----------|----------|-------------|
| Session isolation | - | - | worktree |
| Memory consolidation | - | - | Dream |
| Auto-memory | - | - | autoDream |
| Memory directory | - | - | .claude/memdir |
| Background tasks | task | task | DreamTask |
