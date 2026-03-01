# Architecture Rules

## Layer Separation (Clean Architecture)
- Domain logic must never import from infrastructure (DB, HTTP, queue, filesystem)
- Dependency direction: UI → Application → Domain ← Infrastructure
- One module = one responsibility. If you can't name it in 3 words, it's doing too much.

## File Organization Defaults
When no project-specific structure exists, default to:
```
src/
  domain/       # Pure business logic, no I/O
  application/  # Use cases, orchestration
  infra/        # DB, HTTP clients, queues, external APIs
  api/          # HTTP handlers (thin — delegate to application layer)
  utils/        # Pure functions, no side effects
tests/
  unit/         # No I/O, fast
  integration/  # Real dependencies, test containers
```

## Module Rules
- Never create circular dependencies
- Public API of a module = explicit exports only. Everything else is private.
- Config (env vars, feature flags) flows top-down. Never read env vars inside domain.
- Constants live in one place per concern (`src/domain/constants.ts`, not scattered)

## State Management
- No global mutable state outside a designated store
- Prefer passing dependencies explicitly (constructor injection, function params)
- Avoid singletons; prefer factory functions or DI containers

## API Design
- REST: GET (read) / POST (create) / PUT (replace) / PATCH (partial update) / DELETE
- Version from day 1: `/v1/` prefix — never break existing clients
- Error schema: `{ "error": { "code": "SNAKE_CASE_CODE", "message": "...", "trace_id": "..." } }`
- Paginate all list endpoints — cursor-based for datasets > 10k rows
- Idempotency keys on any mutation with side effects (email, payment, queue publish)
