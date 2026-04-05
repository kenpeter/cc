# Universal Task System (OpenCode, KiloCode, Claude Code)

## Overview

A universal task system for managing background work, agents, and workflows across all three platforms.

## Task Types Across Platforms

| Type | OpenCode | KiloCode | Claude Code |
|------|----------|----------|-------------|
| Shell command | `task type=bash` | `task type=bash` | `local_bash` |
| Local agent | `task type=agent` | `task type=agent` | `local_agent` |
| Remote agent | - | - | `remote_agent` |
| Workflow | `task type=workflow` | `task type=workflow` | `local_workflow` |
| MCP monitor | - | - | `monitor_mcp` |
| Background | `background: true` | `background: true` | via TaskTool |

---

## Task Status Across Platforms

| Status | OpenCode | KiloCode | Claude Code |
|--------|----------|----------|-------------|
| Pending | `pending` | `pending` | `pending` |
| Running | `running` | `running` | `running` |
| Completed | `completed` | `completed` | `completed` |
| Failed | `failed` | `failed` | `failed` |
| Killed | - | - | `killed` |

## Universal Task Concepts

---

## Terminal Status Check

```typescript
export function isTerminalTaskStatus(status: TaskStatus): boolean {
  return status === 'completed' || status === 'failed' || status === 'killed'
}
```

---

## Task ID Generation

```typescript
const TASK_ID_PREFIXES: Record<string, string> = {
  local_bash: 'b',
  local_agent: 'a',
  remote_agent: 'r',
  in_process_teammate: 't',
  local_workflow: 'w',
  monitor_mcp: 'm',
  dream: 'd',
}

// Case-insensitive-safe alphabet (36^8 combinations)
const TASK_ID_ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyz'

export function generateTaskId(type: TaskType): string {
  const prefix = TASK_ID_PREFIXES[type] ?? 'x'
  const bytes = randomBytes(8)
  let id = prefix
  for (let i = 0; i < 8; i++) {
    id += TASK_ID_ALPHABET[bytes[i]! % TASK_ID_ALPHABET.length]
  }
  return id
}
```

---

## Task State Base

```typescript
export type TaskStateBase = {
  id: string
  type: TaskType
  status: TaskStatus
  description: string
  toolUseId?: string
  startTime: number
  endTime?: number
  totalPausedMs?: number
  outputFile: string
  outputOffset: number
  notified: boolean
}
```

---

## Task Context

```typescript
export type TaskContext = {
  abortController: AbortController
  getAppState: () => AppState
  setAppState: SetAppState
}
```

---

## Ideas for Team Pipeline

1. **Task Types** - Different execution modes (local bash, agent, workflow)
2. **Status Tracking** - Track pending/running/completed/failed/killed
3. **Task IDs** - Unique IDs with type prefix for tracking
4. **Output Files** - Store task output to files for later retrieval
5. **Abort Support** - AbortController for cancellation
6. **Time Tracking** - startTime, endTime, totalPausedMs for metrics
