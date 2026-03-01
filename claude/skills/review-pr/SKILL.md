---
name: review-pr
description: >
  Perform a comprehensive senior-engineer code review. Checks for correctness,
  security vulnerabilities, performance issues, test coverage, and architectural
  consistency. Use after making code changes or when asked to review code.
allowed-tools: Read, Grep, Glob, Bash(git diff*), Bash(git log*), Bash(git status)
---

You are performing a senior software architect code review. Be thorough, specific, and actionable.

## Review Process

1. **Get the diff**
   ```
   git diff HEAD~1 HEAD   # or git diff for uncommitted changes
   ```

2. **For each changed file**, check:

   ### Correctness
   - Does the logic handle edge cases? (null/empty/zero/negative/overflow)
   - Are error paths fully handled? No silent swallows.
   - Is concurrent access safe? Race conditions?
   - Are all code paths reachable? Dead code?

   ### Security (OWASP Top 10)
   - SQL injection: parameterized queries used?
   - No secrets/credentials in code
   - Input validated at boundaries
   - Auth/authz checked properly
   - No sensitive data in logs or error responses

   ### Performance
   - N+1 queries in loops?
   - Unnecessary re-computation inside loops?
   - Missing indexes for new query patterns?
   - Unbounded result sets?
   - Heavy sync work that should be async?

   ### Architecture
   - Layer separation maintained? (no domain importing infra)
   - Single responsibility?
   - Correct abstraction level?
   - Circular dependencies introduced?

   ### Testing
   - Are new code paths covered by tests?
   - Are edge cases tested?
   - Tests testing behavior, not implementation?

3. **Format your findings**:

```
## Code Review Summary

### 🔴 Critical (must fix before merge)
- `file.ts:42` — SQL query built with string concat → use parameterized query
  ```ts
  // Fix:
  db.query('SELECT * FROM users WHERE id = ?', [userId])
  ```

### 🟡 Warning (should fix)
- `service.ts:87` — N+1 query in loop, fetch all IDs in single query first

### 🟢 Suggestions (nice to have)
- `utils.ts:12` — Extract magic number 86400 to named constant `SECONDS_PER_DAY`

### ✅ Looks Good
- Error handling is comprehensive
- Types are correct
- Tests cover the happy path
```

Be specific: always include `file:line` reference and a concrete fix suggestion.
