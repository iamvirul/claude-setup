# Code Quality Rules

## Type Safety
- TypeScript: strict mode always. No `any`. No `as unknown as T` hacks.
- Python: type annotations on all function signatures. Use `TypeVar`, `Protocol` for generics.
- Go: no raw `interface{}` unless interfacing with truly external/dynamic data.
- At untyped boundaries (external APIs, JSON), validate and type-assert explicitly.

## Naming
- Variables/functions: describe what they ARE or DO, not how they work
  - Good: `getUserById`, `isEmailVerified`, `activeSubscriptions`
  - Bad: `getData`, `flag`, `temp`, `x`
- Boolean names: use `is/has/can/should` prefix (`isLoading`, `hasPermission`)
- Avoid abbreviations except universally understood ones (`id`, `url`, `ctx`, `req`, `res`)
- Constants: SCREAMING_SNAKE_CASE for module-level; camelCase for local scope

## Functions
- Single responsibility: one function does one thing
- Max 20-30 lines. If longer, extract.
- Max 3-4 params. If more, use a config object/struct.
- Pure functions preferred: same input → same output, no side effects
- No boolean trap: `createUser(name, true, false)` → use named options object

## Error Handling
```
// Pattern: Never swallow. Always add context.
try {
  const result = await externalCall(input);
  return result;
} catch (error) {
  logger.error('ExternalCall failed', { input, error, trace_id: ctx.traceId });
  throw new ServiceError('EXTERNAL_CALL_FAILED', 'Dependency unavailable', { cause: error });
}
```
- Typed errors: use error classes/types with `code` field, not just message strings
- Propagate with context added at each layer — don't just re-throw raw

## Immutability
- Prefer `const` over `let`. Never `var`.
- Don't mutate function arguments — return new values
- Use spread/Object.assign for object updates, not direct mutation
- Arrays: prefer `.map()/.filter()/.reduce()` over `.forEach()` with mutation

## Comments
- Write comments for WHY, not WHAT (the code already says what)
- Comment non-obvious algorithmic decisions, business rule context, known trade-offs
- TODO comments: always include owner + ticket `// TODO(you): fix in TICKET-123`
- Never leave commented-out code — delete it (git history exists)

## Dead Code
- Delete unused variables, imports, functions immediately
- No `_unusedParam` hacks — redesign the interface
- Feature flag dead code: clean up immediately when flag is permanently enabled
