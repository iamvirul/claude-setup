# Security Rules

## Mandatory for Every PR
- [ ] No secrets, tokens, or credentials in code or logs
- [ ] All user inputs validated at system boundary (HTTP, CLI, file, env)
- [ ] No raw string concatenation in SQL — use parameterized queries
- [ ] Auth headers/tokens never logged, even at DEBUG level
- [ ] Errors returned to clients contain no internal stack traces or DB details

## Input Validation
- Validate at entry points: HTTP handlers, CLI arg parsers, env var readers
- Use schema validation libraries (Zod, Joi, Pydantic, validator) — never hand-roll validators
- Allowlist > Denylist for validation rules

## Authentication & Authorization
- Never roll your own auth — use established libraries (passport, Auth0, NextAuth, etc.)
- Validate JWTs server-side on every request. Never trust client-provided user IDs.
- Session tokens: httpOnly, Secure, SameSite=Strict cookies
- Implement rate limiting on all auth endpoints
- Use short-lived access tokens + refresh token rotation

## Secrets Management
- Development: `.env` file (gitignored), never committed
- Production: Secret manager (AWS SSM/Secrets Manager, Vault, GCP Secret Manager)
- Rotate secrets when team members leave or on breach suspicion
- Principle of least privilege for all service accounts and IAM roles

## OWASP Top 10 Checkpoints
1. **Injection**: Parameterized queries, ORM usage, avoid eval/exec with user input
2. **Broken Auth**: Short token lifetimes, secure storage, MFA for admin
3. **XSS**: Escape output, Content-Security-Policy headers, avoid innerHTML
4. **IDOR**: Authorize by ownership, not just authentication
5. **Security Misconfiguration**: Disable debug in prod, remove default credentials
6. **SSRF**: Validate/allowlist URLs before making server-side requests
7. **Deserialization**: Never deserialize untrusted data with object hydration

## Dependency Security
- `npm audit` / `pip-audit` / `cargo audit` before every release
- Pin major versions of dependencies, review minor/patch updates
- No dev dependencies in production builds
