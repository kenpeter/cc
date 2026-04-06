# Universal Hooks & Events System (OpenCode, KiloCode, Claude Code)

## Overview

Hooks allow executing code at specific events during the CLI lifecycle.

---

## Hook Event Types

| Event | OpenCode | KiloCode | Claude Code | Description |
|-------|----------|----------|-------------|-------------|
| **PreToolUse** | - | - | ✅ | Before tool execution |
| **PostToolUse** | - | - | ✅ | After tool execution |
| **Notification** | - | - | ✅ | User notifications |
| **Stop** | - | - | ✅ | Agent/Teammate stops |
| **Start** | - | - | ✅ | Session starts |
| **Exit** | - | - | ✅ | Session ends |
| **WorktreeCreate** | - | - | ✅ | Worktree created |
| **WorktreeRemove** | - | - | ✅ | Worktree removed |

---

## Hook Types

### 1. Command Hook
```yaml
hooks:
  PostToolUse:
    - matcher: "Bash"
      type: command
        command: "echo 'Ran: $TOOL_NAME'"
        if: "Bash(git *)"  # Only for git commands
        timeout: 30
        statusMessage: "Running post-tool hook"
        once: false  # Run every time
        async: false  # Block until complete
```

### 2. Prompt Hook
```yaml
hooks:
  PostToolUse:
    - matcher: "Write"
      type: prompt
        prompt: |
          Analyze this write operation:
          $ARGUMENTS
          
          Does it look suspicious?
        model: claude-sonnet-4-6
        timeout: 60
```

### 3. HTTP Hook
```yaml
hooks:
  PostToolUse:
    - matcher: "Bash"
      type: http
        url: "https://webhook.example.com/log"
        headers:
          Authorization: "Bearer $MY_TOKEN"
        allowedEnvVars: ["MY_TOKEN"]
        timeout: 30
```

### 4. Agent Hook (Verifier)
```yaml
hooks:
  PreToolUse:
    - matcher: "Write"
      type: agent
        prompt: |
          Verify that this write operation is safe.
          $ARGUMENTS
        model: claude-sonnet-4-6
        timeout: 60
```

---

## Conditional Hooks

Hooks can have `if` conditions using permission rule syntax:

```yaml
# Only run for git commands
if: "Bash(git *)"

# Only run for TypeScript files
if: "Read(*.ts)"

# Only run for specific tool inputs
if: "Write(src/**/*.ts)"
```

---

## Hook Options

| Option | Type | Description |
|--------|------|-------------|
| `matcher` | string | Pattern to match tool names |
| `if` | string | Condition for running |
| `timeout` | number | Timeout in seconds |
| `statusMessage` | string | Spinner message |
| `once` | boolean | Run once then remove |
| `async` | boolean | Run in background |
| `asyncRewake` | boolean | Wake on exit code 2 |

---

## Universal Hook Ideas

1. **Event Types** - Standardize events across platforms
2. **Hook Types** - command, prompt, http, agent
3. **Conditional Execution** - if conditions based on tool input
4. **Async Support** - Non-blocking hooks
5. **One-time Hooks** - Auto-remove after execution

---

## Platform Mapping

| Concept | OpenCode | KiloCode | Claude Code |
|---------|----------|----------|-------------|
| PreToolUse | - | - | ✅ |
| PostToolUse | - | - | ✅ |
| Notification | - | - | ✅ |
| Stop hook | - | - | ✅ |
| Custom hooks | - | - | ✅ hooks config |

---

## Example Use Cases

### 1. Auto-format on save
```yaml
hooks:
  PostToolUse:
    - matcher: "Write"
      type: command
        command: "prettier --write $CLAUDE_FILE_PATH"
        if: "Write(*.{ts,js,tsx,jsx})"
```

### 2. Security scanning
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      type: agent
        prompt: |
          Analyze this command for security risks:
          $ARGUMENTS
```

### 3. Activity logging
```yaml
hooks:
  PostToolUse:
    - matcher: "*"
      type: http
        url: "https://logs.example.com/tool"
```
