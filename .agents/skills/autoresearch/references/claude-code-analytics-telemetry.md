# Universal Analytics & Telemetry System (OpenCode, KiloCode, Claude Code)

## Overview

Analytics and telemetry track usage, performance, and errors across the platform.

---

## Analytics Architecture

### Event Types

| Category | Events | Description |
|----------|--------|-------------|
| **Session** | start, end, duration | Session lifecycle |
| **Tool** | use, result, empty | Tool execution |
| **Model** | tokens, latency, cache | Model performance |
| **Error** | error, warning, crash | Error tracking |
| **Feature** | usage, enabled | Feature adoption |

### Core Analytics Functions

```python
# Basic analytics interface
def logEvent(eventName: str, metadata: dict):
    """Log analytics event"""
    
def logError(errorId: str, context: dict):
    """Log error with context"""
    
def logMetric(name: str, value: float, unit: str):
    """Log numeric metric"""
```

---

## Telemetry Systems

### 1. OpenTelemetry

Claude Code uses OpenTelemetry for structured tracing:

```python
# OpenTelemetry concepts
from opentelemetry import trace, metrics

# Tracer for spans
tracer = trace.get_tracer(__name__)

# Metrics exporter
def export_metrics(metrics_data):
    """Export to OTLP endpoint"""
```

### 2. Tracing

| Concept | Description |
|--------|-------------|
| **Span** | Single operation |
| **Trace** | Full request path |
| **Attributes** | Span metadata |
| **Exporter** | OTLP, Prometheus, etc. |

### 3. Metrics

| Metric Type | Example |
|------------|---------|
| **Counter** | errors_total |
| **Gauge** | active_sessions |
| **Histogram** | request_duration_ms |

---

## Event Logging

### Event Examples

```python
# Tool events
logEvent('tengu_tool_empty_result', {...})
logEvent('tengu_tool_result_persisted', {...})

# Session events  
logEvent('tengu_unary_event', {...})

# Feature events
logEvent('tengu_skill_loaded', {...})
logEvent('tengu_plugin_enabled_for_session', {...})

# Dream events
logEvent('tengu_auto_dream_fired', {...})
logEvent('tengu_auto_dream_completed', {...})
logEvent('tengu_auto_dream_failed', {...})

# Tool search
logEvent('tengu_tool_search_mode_decision', {...})
logEvent('tengu_deferred_tools_pool_change', {...})
```

---

## Error Tracking

### Error Types

| Type | Description |
|------|-------------|
| **Warning** | Non-fatal issues |
| **Error** | Failed operations |
| **Crash** | Fatal errors |

### Error Event Fields

```python
error_event = {
    'error_id': str,        # Unique error type ID
    'message': str,        # Error message
    'stack': str,          # Stack trace
    'context': dict,        # Additional context
    'session_id': str,     # Session identifier
    'timestamp': int,      # Unix timestamp
}
```

---

## Feature Flags (GrowthBook)

Claude Code uses GrowthBook for feature flags:

```python
# Feature flag access
def getFeatureValue(flag: str, default: any):
    """Get feature flag value"""
    
# Example usage
if getFeatureValue('tengu_enhanced_telemetry', False):
    enable_enhanced_tracing()
```

---

## Universal Analytics Ideas

### 1. Event System

```python
# Universal event logging
class Analytics:
    @staticmethod
    def log(event: str, **kwargs):
        """Log event with metadata"""
        
    @staticmethod
    def error(error_id: str, **kwargs):
        """Log error"""
        
    @staticmethod
    def metric(name: str, value: float):
        """Log metric"""
```

### 2. Telemetry Collection

```python
# Telemetry configuration
TELEMETRY_CONFIG = {
    'enabled': True,
    'endpoint': 'https://telemetry.example.com',
    'protocol': 'otlp',  # or 'http', 'grpc'
    'sample_rate': 0.1,  # 10% of events
}
```

### 3. Privacy Considerations

| Approach | Description |
|----------|-------------|
| **Opt-in** | User must enable |
| **Anonymization** | Remove PII |
| **Sampling** | Collect subset |
| **Local only** | No external upload |

---

## Platform Mapping

| Concept | OpenCode | KiloCode | Claude Code |
|---------|----------|----------|-------------|
| Event logging | - | - | logEvent |
| Error tracking | - | - | error IDs |
| Feature flags | - | - | GrowthBook |
| Tracing | - | - | OpenTelemetry |
| Metrics | - | - | OTLP exporters |
| Telemetry config | - | - | TELEMETRY_ENABLED env |

---

## Use Cases

### 1. Usage Analytics
- Which tools are used most
- Session duration
- Model selection

### 2. Performance
- Response latency
- Token usage
- Cache hit rates

### 3. Error Monitoring
- Error rates by type
- Crash reports
- Warning frequencies

### 4. Feature Adoption
- Feature enablement
- Flag usage
- Experiment results
