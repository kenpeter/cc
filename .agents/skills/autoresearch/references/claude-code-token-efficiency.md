# Universal Token Efficiency System (OpenCode, KiloCode, Claude Code)

## Overview

Token efficiency is about minimizing token usage while maximizing useful work done. This applies to all three platforms.

---

## Token Budget Parsing

Users can specify token budgets in prompts:

| Format | Example | Description |
|--------|---------|-------------|
| Shorthand start | `+500k` | At start of message |
| Shorthand end | `+500k.` | At end of message |
| Verbose | `use 2M tokens` | Anywhere in message |

```python
# Python implementation
SHORTHAND_START_RE = r'^\s*\+(\d+(?:\.\d+)?)\s*(k|m|b)\b'
SHORTHAND_END_RE = r'\s\+(\d+(?:\.\d+)?)\s*(k|m|b)\s*[.!?]?\s*$'
VERBOSE_RE = r'\b(?:use|spend)\s+(\d+(?:\.\d+)?)\s*(k|m|b)\s*tokens?\b'

MULTIPLIERS = {'k': 1000, 'm': 1000000, 'b': 1000000000}

def parse_token_budget(text: str) -> int | None:
    # Match start shorthand (+500k), end shorthand (500k.), or verbose (use 500k tokens)
    # Returns parsed integer or None if not found
```

---

## Token Counting

| Platform | Method |
|----------|--------|
| OpenCode | `roughTokenCountEstimation(text)` |
| KiloCode | Same as OpenCode |
| Claude Code | `roughTokenCountEstimation(text)` + API |

```python
def rough_token_count_estimation(text: str) -> int:
    # Rough estimate: ~4 characters per token
    return len(text) // 4
```

---

## Context Window Management

| Platform | Max Context | Token Budget Feature |
|----------|-------------|---------------------|
| OpenCode | Varies by model | `+N` in prompt |
| KiloCode | Varies by model | `+N` in prompt |
| Claude Code | 200K+ | `+N` in prompt |

---

## Efficiency Patterns

### 1. Minimal Prompts
```
# Instead of verbose
"Please read the file at path/to/file.ts and tell me what it does"

# Use minimal
"read path/to/file.ts"
```

### 2. Token Budget for Long Tasks
```
+2M
Goal: Process all files in src/
```

### 3. Caching Considerations
- Reuse context from previous turns when possible
- Use cache-friendly tool ordering

---

## Universal Token Ideas

1. **Budget Syntax** - `+N` suffix in prompts (works across platforms)
2. **Token Counting** - Character-based estimation fallback
3. **Context Awareness** - Track current context size
4. **Smart Truncation** - Only include relevant parts
5. **Cache Optimization** - Tool ordering for cache hits

---

## Platform-Specific Notes

| Platform | Token Features |
|----------|----------------|
| OpenCode | Via prompt tokens, uses model context |
| KiloCode | Same as OpenCode |
| Claude Code | Full token budget system, cache tokens |

---

## Test Patterns

```python
def test_token_budget_parsing():
    assert parse_token_budget("+500k") == 500000
    assert parse_token_budget("+1m.") == 1000000
    assert parse_token_budget("use 2M tokens") == 2000000
    assert parse_token_budget("hello") is None
```

```python
def test_token_estimation():
    # ~4 chars per token
    assert rough_token_count_estimation("hello") == 1
    assert rough_token_count_estimation("a" * 100) == 25
```
