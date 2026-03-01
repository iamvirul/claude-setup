# claude-setup

One-command Claude Code optimization for any machine. Installs a production-grade configuration that turns Claude into a Staff/Principal engineer persona with strict code quality, security, and observability standards.

## Quick Install

```bash
git clone https://github.com/iamvirul/claude-setup.git ~/claude-setup
cd ~/claude-setup && ./setup.sh
```

Or directly from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/iamvirul/claude-setup/main/setup.sh | bash
```

> **Requires**: bash 3.2+, python3 (for settings merge)

## What Gets Installed

All files are installed to `~/.claude/`:

| Path | Purpose |
|------|---------|
| `CLAUDE.md` | Core architect mindset: SOLID, Clean Architecture, error handling, security, testing strategy, API design, performance defaults |
| `rules/architecture.md` | Layer separation, file organization, module rules, API design |
| `rules/code-quality.md` | Type safety, naming, function design, error handling, immutability |
| `rules/security.md` | OWASP Top 10, auth, secrets management, input validation |
| `rules/testing.md` | 70/20/10 pyramid, AAA pattern, integration test isolation |
| `rules/observability.md` | Structured logging, distributed tracing, USE metrics, health endpoints |
| `hooks/validate-bash.sh` | Blocks catastrophic bash commands before execution |
| `hooks/post-edit.sh` | Formatting hints (prettier/ruff/gofmt) after file edits |
| `skills/review-pr/SKILL.md` | `/review-pr` — Senior code review with Critical/Warning/Suggestion tiers |
| `skills/commit/SKILL.md` | `/commit` — Conventional commits with staged-file deliberation |
| `skills/debug/SKILL.md` | `/debug` — Systematic root cause analysis workflow |
| `agents/code-reviewer.md` | Isolated read-only code review subagent |

## Idempotent

Running `./setup.sh` multiple times is safe. Each run:
1. Backs up your existing `~/.claude` to `~/.claude_backup_TIMESTAMP`
2. Installs fresh copies of all managed files
3. **Smart-merges** `settings.json` — your existing `model`, `effortLevel`, `enabledPlugins`, and other personal settings are preserved

## Updating

```bash
cd ~/claude-setup
git pull
./setup.sh
```

## Uninstalling

```bash
cd ~/claude-setup
./uninstall.sh
```

Removes only the files managed by this repo. Your `~/.claude` directory and any other files are untouched.

## Customizing

### Add your own rules

Drop a `.md` file in `~/.claude/rules/` and reference it from `CLAUDE.md`:

```markdown
@~/.claude/rules/my-project-rules.md
```

### Add your own skills

Create `~/.claude/skills/my-skill/SKILL.md` with a YAML frontmatter + instructions block. Invoke with `/my-skill` in Claude Code.

### Adjust permissions

Edit `~/.claude/settings.json` directly. The `permissions` block controls which tools Claude can use automatically vs. requiring confirmation.

### Personal plugins

`enabledPlugins` in `settings.json` is intentionally omitted from this repo. Your installed plugins are preserved across setup runs.

## Repository Structure

```
claude-setup/
├── setup.sh                  # Idempotent installer
├── uninstall.sh              # Removes managed files
├── README.md
├── .gitignore
└── claude/                   # Source of truth for all config
    ├── CLAUDE.md
    ├── settings.json         # Base settings (no personal plugins)
    ├── rules/
    │   ├── architecture.md
    │   ├── code-quality.md
    │   ├── security.md
    │   ├── testing.md
    │   └── observability.md
    ├── hooks/
    │   ├── validate-bash.sh
    │   └── post-edit.sh
    ├── skills/
    │   ├── review-pr/SKILL.md
    │   ├── commit/SKILL.md
    │   └── debug/SKILL.md
    └── agents/
        └── code-reviewer.md
```

## License

MIT
