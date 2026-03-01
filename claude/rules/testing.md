# Testing Rules

## Testing Pyramid
| Layer | Target | Rule |
|-------|--------|------|
| Unit | 70% | No I/O, no network, pure functions. Run in milliseconds. |
| Integration | 20% | Real DB/queue via test containers. Test the wiring. |
| E2E | 10% | Happy path + 1-2 critical failure paths only. Expensive. |

## Unit Test Rules
- One test file per source file, co-located or in `/tests/unit/`
- Each test: Arrange → Act → Assert (AAA pattern). No more.
- Test behavior, not implementation. Never assert on private internals.
- Mock only at system boundaries (HTTP, DB, queue, time, filesystem)
- Never mock your own application code — if you need to, your design has a problem

## What Must Be Tested
- Every public function: at minimum one happy-path + one error-path test
- Every HTTP endpoint: success response, validation error, auth error
- Every background job: normal execution + failure/retry behavior
- Bug fixes: regression test FIRST, then fix (red → green)

## Test Naming Convention
```
describe('UserService', () => {
  describe('createUser', () => {
    it('returns created user when input is valid')
    it('throws ValidationError when email is missing')
    it('throws ConflictError when email already exists')
  })
})
```

## Integration Test Rules
- Use test containers for databases and queues (not mocks)
- Each integration test suite should be fully isolated (own DB schema/prefix)
- Clean up state between tests — use transactions rolled back after each test
- Never hit real external APIs in tests — use recorded fixtures or WireMock

## Coverage
- Minimum 80% branch coverage for business logic
- 100% coverage for critical paths (auth, payments, data migration)
- Coverage alone is not a goal — test quality > coverage number

## Test Performance
- Unit tests: < 100ms per test, < 10s for full suite
- Integration tests: < 30s per suite
- Flaky tests are bugs — fix or delete them immediately
