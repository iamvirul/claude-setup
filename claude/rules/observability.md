# Observability Rules

## Structured Logging
Every log entry must be JSON with these fields:
```json
{
  "level": "info|warn|error|debug",
  "timestamp": "2026-01-01T00:00:00.000Z",
  "service": "user-service",
  "trace_id": "abc-123",
  "span_id": "def-456",
  "message": "Human-readable description",
  "...contextFields": "relevant data"
}
```

## Log Levels
- `error` — Something broke that needs immediate attention. Include full error + context.
- `warn` — Unexpected but handled. Degraded behavior, retried operations.
- `info` — Normal significant events: request received, job started/completed, user action.
- `debug` — Detailed data for debugging. Never in production by default.

## What to Log
- Request start (method, path, trace_id) — NOT body by default (may contain PII)
- Request end (status, duration_ms)
- External calls (service, operation, duration, outcome)
- Background job start/end/failure
- Business events (user signup, order created, payment processed)

## What NOT to Log
- Passwords, tokens, API keys — ever
- Full request/response bodies by default
- PII (email, phone, address) unless explicitly required and encrypted
- Sensitive query parameters

## Distributed Tracing
- Every service must accept and propagate `X-Trace-ID` header
- Generate trace_id at entry point (HTTP handler, queue consumer) if not present
- Pass trace_id through all internal function calls via context object
- Include trace_id in all log entries and error responses

## Metrics (USE Method for each resource)
- **Utilization**: % of time resource is busy (CPU, DB pool usage)
- **Saturation**: Amount of work waiting (queue depth, request backlog)
- **Errors**: Rate of failed operations
- Key application metrics: p50/p95/p99 latency, error rate, throughput, cache hit rate

## Health Endpoints
```
GET /health/live   → 200 if process is running (liveness)
GET /health/ready  → 200 if all dependencies are healthy (readiness)
GET /health        → Summary with dependency status
```

## Alerts
- Error rate > 1% for 5 minutes → page
- p99 latency > SLO threshold → page
- Queue depth growing unboundedly → warn
- External dependency unhealthy → warn
