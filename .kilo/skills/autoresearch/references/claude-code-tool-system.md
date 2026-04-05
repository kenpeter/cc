# Universal Tool System (OpenCode, KiloCode, Claude Code)

## Overview

A universal tool system design that works across OpenCode, KiloCode, and Claude Code. Each platform has different built-in tools but the architecture is similar.

---

## Tool Mapping Across Platforms

| Universal Concept | OpenCode | KiloCode | Claude Code |
|-------------------|----------|----------|-------------|
| Read file | `read` | `read` | FileReadTool |
| Edit file | `edit` | `edit` | FileEditTool |
| Write file | `write` | `write` | FileWriteTool |
| Glob files | `glob` | `glob` | GlobTool |
| Grep content | `grep` | `grep` | GrepTool |
| Run shell | `bash` | `bash` | BashTool |
| Web fetch | `webfetch` | `webfetch` | WebFetchTool |
| Web search | `websearch` | `websearch` | WebSearchTool |
| Ask user | `question` | `question` | AskUserQuestionTool |
| Todo write | `todowrite` | `todowrite` | TodoWriteTool |
| Create task | `task` | `task` | TaskCreateTool |
| Stop task | `task stop` | `task stop` | TaskStopTool |
| List MCP | - | - | ListMcpResourcesTool |
| Read MCP | - | - | ReadMcpResourceTool |

---

## Tool Categories

| Category | Description |
|----------|-------------|
| **File** | Read, edit, write, glob, grep files |
| **Shell** | Run shell commands |
| **Agent** | Create, manage, stop tasks/agents |
| **Search** | Web fetch, web search |
| **User** | Ask questions, todo write |

## Feature-Gated Tools

Tools can be conditionally loaded based on features:

```typescript
// Example from Claude Code
const SleepTool = feature('PROACTIVE') || feature('KAIROS')
  ? require('./tools/SleepTool/SleepTool.js').SleepTool
  : null

const cronTools = feature('AGENT_TRIGGERS')
  ? [
      require('./tools/ScheduleCronTool/CronCreateTool.js').CronCreateTool,
      require('./tools/ScheduleCronTool/CronDeleteTool.js').CronDeleteTool,
    ]
  : []
```

---

## Tool Presets

```typescript
export const TOOL_PRESETS = ['default'] as const

export function getToolsForDefaultPreset(): string[] {
  const tools = getAllBaseTools()
  const isEnabled = tools.map(tool => tool.isEnabled())
  return tools.filter((_, i) => isEnabled[i]).map(tool => tool.name)
}
```

---

## Simple Mode Tools

When running in simple mode, only core tools are available:

```typescript
const simpleTools: Tool[] = [BashTool, FileReadTool, FileEditTool]
```

---

## MCP Tool Integration

MCP tools are merged with built-in tools:

```typescript
export function assembleToolPool(
  permissionContext: ToolPermissionContext,
  mcpTools: Tools,
): Tools {
  const builtInTools = getTools(permissionContext)
  const allowedMcpTools = filterToolsByDenyRules(mcpTools, permissionContext)
  
  // Sort for prompt-cache stability
  const byName = (a: Tool, b: Tool) => a.name.localeCompare(b.name)
  return uniqBy(
    [...builtInTools].sort(byName).concat(allowedMcpTools.sort(byName)),
    'name',
  )
}
```

---

## Tool Deny Rules

Tools can be filtered by permission context:

```typescript
export function filterToolsByDenyRules<T extends { name: string }>(
  tools: readonly T[],
  permissionContext: ToolPermissionContext,
): T[] {
  return tools.filter(tool => !getDenyRuleForTool(permissionContext, tool))
}
```

---

## Universal Ideas for All Platforms

1. **Feature Flags** - Conditionally enable tools based on project needs
2. **Tool Presets** - Predefined tool sets (test, debug, ship, simple)
3. **Tool Deny Rules** - Fine-grained tool permissions per project
4. **MCP Server Support** - Extensible tool system via MCP (for Claude Code/OpenCode)
5. **Simple Mode** - Minimal tools for quick tasks (works in all platforms)
6. **Tool Pool Assembly** - Merge built-in + MCP tools with deduplication
