# Universal Keybinding System (OpenCode, KiloCode, Claude Code)

## Overview

A universal keybinding system that works across OpenCode, KiloCode, and Claude Code. Each platform has different defaults but the architecture is portable.

## Default Bindings Structure

```typescript
type KeybindingBlock = {
  context: string  // Context name (Global, Chat, Task, etc.)
  bindings: Record<string, string>  // key -> action
}
```

---

## Contexts

| Context | Description |
|---------|-------------|
| `Global` | App-wide shortcuts |
| `Chat` | Chat input shortcuts |
| `Autocomplete` | Autocomplete navigation |
| `Settings` | Settings panel |
| `Confirmation` | Yes/no dialogs |
| `Tabs` | Tab navigation |
| `Transcript` | Transcript view |
| `HistorySearch` | Ctrl+r history search |
| `Task` | Task/background running |
| `Scroll` | Scroll/paging |
| `Select` | Selection component |
| `MessageSelector` | Message rewind dialog |

---

## Default Bindings Example

```typescript
export const DEFAULT_BINDINGS: KeybindingBlock[] = [
  {
    context: 'Global',
    bindings: {
      'ctrl+c': 'app:interrupt',
      'ctrl+d': 'app:exit',
      'ctrl+l': 'app:redraw',
      'ctrl+t': 'app:toggleTodos',
      'ctrl+o': 'app:toggleTranscript',
    },
  },
  {
    context: 'Chat',
    bindings: {
      escape: 'chat:cancel',
      'ctrl+x ctrl+k': 'chat:killAgents',
      enter: 'chat:submit',
      up: 'history:previous',
      down: 'history:next',
    },
  },
  {
    context: 'Task',
    bindings: {
      'ctrl+b': 'task:background',
    },
  },
]
```

---

## Feature-Gated Bindings

Bindings can be conditional based on features:

```typescript
...(feature('KAIROS') || feature('KAIROS_BRIEF')
  ? { 'ctrl+shift+b': 'app:toggleBrief' as const }
  : {}),
...(feature('QUICK_SEARCH')
  ? {
      'ctrl+shift+f': 'app:globalSearch' as const,
      'ctrl+shift+p': 'app:quickOpen' as const,
    }
  : {}),
```

---

## Platform-Specific Bindings

```typescript
// Platform-specific image paste shortcut
const IMAGE_PASTE_KEY = getPlatform() === 'windows' ? 'alt+v' : 'ctrl+v'

// Terminal VT mode detection
const SUPPORTS_TERMINAL_VT_MODE = ...

// Mode cycle shortcut adapts to platform
const MODE_CYCLE_KEY = SUPPORTS_TERMINAL_VT_MODE ? 'shift+tab' : 'meta+m'
```

---

## Action Patterns

| Pattern | Example | Description |
|---------|---------|-------------|
| `app:*` | `app:interrupt`, `app:exit` | App-level actions |
| `chat:*` | `chat:submit`, `chat:cancel` | Chat actions |
| `task:*` | `task:background` | Task actions |
| `select:*` | `select:next`, `select:accept` | Selection actions |
| `confirm:*` | `confirm:yes`, `confirm:no` | Dialog actions |
| `history:*` | `history:previous` | History navigation |

---

## Ideas for Team Pipeline

1. **Context-Aware Bindings** - Different shortcuts for different modes
2. **Feature-Gated Shortcuts** - Enable/disable shortcuts via features
3. **Platform Adaptation** - Adapt to Windows/macOS/Linux
4. **Action Namespacing** - Clear naming: `context:action`
5. **Override System** - User bindings can override defaults
