---
name: commit
description: >
  Create a well-structured git commit following conventional commits format.
  Reviews staged changes, writes a precise commit message, and commits.
  Use when you're ready to commit work.
allowed-tools: Bash(git status), Bash(git diff*), Bash(git add*), Bash(git commit*), Bash(git log*)
---

Create a clean, conventional commit for the current changes.

## Process

1. **Check current state**
   ```bash
   git status
   git diff --staged   # staged changes
   git diff            # unstaged changes
   ```

2. **Review recent commit style**
   ```bash
   git log --oneline -10
   ```

3. **Stage the right files** — be deliberate, not `git add -A`
   - Stage only files related to the current change
   - Never stage: `.env`, secrets, large binaries, auto-generated files

4. **Write commit message** following Conventional Commits:
   ```
   <type>(<scope>): <short description>

   [optional body: WHY, not WHAT]

   [optional footer: BREAKING CHANGE: ..., Closes #123]
   ```

   Types:
   - `feat`: new feature
   - `fix`: bug fix
   - `refactor`: restructuring without behavior change
   - `test`: adding/fixing tests
   - `docs`: documentation only
   - `perf`: performance improvement
   - `chore`: build, deps, tooling
   - `security`: security fix

   Rules:
   - Subject line ≤ 72 chars, imperative mood ("add X" not "added X")
   - Body: wrap at 72 chars, explain motivation and context
   - Reference issues: `Closes #123`, `Fixes #456`

5. **Commit**:
   ```bash
   git commit -m "$(cat <<'EOF'
   feat(auth): add JWT refresh token rotation

   Implements single-use refresh tokens that rotate on each use.
   Eliminates token theft risk from replay attacks.

   Closes #234
   EOF
   )"
   ```

If the user has not specified which files to commit, ask before staging.
Never force-push or amend published commits without explicit confirmation.
