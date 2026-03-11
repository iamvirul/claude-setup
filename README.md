# claude-setup

One-command Claude Code optimization for any machine. Installs a production-grade configuration that turns Claude into a Staff/Principal engineer persona — with strict code quality, security, observability standards, and an **Obsidian-powered persistent brain** that grows smarter with every session.

Any edits you make to `~/.claude` files are **automatically committed and pushed** to your own fork — your config stays in sync across every machine.

---

## Getting Started

### Step 1 — Fork this repo

Click **Fork** on GitHub so you have your own copy to sync to.

> This is important. The auto-sync hook pushes your `~/.claude` changes to `origin/main`.
> If you clone this repo directly (without forking), you won't be able to push.

### Step 2 — Clone your fork and run setup

```bash
git clone https://github.com/YOUR_USERNAME/claude-setup.git ~/claude-setup
cd ~/claude-setup && ./setup.sh
```

> **Requires**: bash 3.2+, python3

### Step 3 — Open your Obsidian vault (once)

1. Open Obsidian → **Open folder as vault** → select `~/Documents/Obsidian`
2. **Settings → Community Plugins** → install **Local REST API** → enable it
3. Open Graph View (`Ctrl+G`) to explore your growing knowledge base

That's it. Restart Claude Code and everything is active.

---

## The Obsidian Brain

Claude uses `~/Documents/Obsidian/Claude Brain/` as a persistent knowledge vault. Every session, Claude can read from it and write to it — so the more it works, the more it knows.

### How it grows

```
Claude solves a non-obvious problem
            ↓
  /brain-sync  (or automatic on session end)
            ↓
  Claude writes a structured note to the vault
  (Skill / Pattern / Debug solution / Project map)
            ↓
  Note appears in Obsidian with tags + links
            ↓
  Next session: Claude reads it before starting similar work
```

### Vault structure

```
~/Documents/Obsidian/Claude Brain/
  Index.md                    ← master index with quick links
  Skills/
    Skills Index.md           ← all learned techniques
    <technique>.md
  Patterns/
    Patterns Index.md         ← architecture patterns from real projects
    <pattern>.md
  Debugging/
    Debugging Index.md        ← root causes + fixes for non-obvious bugs
    <bug-name>.md
  Projects/
    Projects Index.md         ← per-project structure, decisions, conventions
    <project-name>.md
  Templates/
    Skill Note.md
    Pattern Note.md
    Debug Note.md
    Project Note.md
```

### Trigger a sync manually

Type `/brain-sync` in Claude Code at any time. Claude will review the session, identify what's worth capturing, and write structured notes to the vault.

---

## How Auto-Sync Works

After setup, every time Claude edits a managed `~/.claude` file:

```
Edit ~/.claude/CLAUDE.md  (or any managed file)
           ↓
  PostToolUse hook fires
           ↓
  File copied → ~/claude-setup/claude/
           ↓
  git commit + git push  (background, non-blocking)
           ↓
  Your fork on GitHub is updated automatically
```

### On a new machine

```bash
git clone https://github.com/YOUR_USERNAME/claude-setup.git ~/claude-setup
cd ~/claude-setup && ./setup.sh
```

Your entire config — including the Obsidian vault structure — is restored instantly.

---

## What Gets Installed

### Claude Code config (`~/.claude/`)

| Path | Purpose |
|------|---------|
| `CLAUDE.md` | Core architect mindset: SOLID, Clean Architecture, error handling, security, testing strategy, API design, performance defaults, Obsidian Brain instructions |
| `rules/architecture.md` | Layer separation, file organization, module rules, API design |
| `rules/code-quality.md` | Type safety, naming, function design, error handling, immutability |
| `rules/security.md` | OWASP Top 10, auth, secrets management, input validation |
| `rules/testing.md` | 70/20/10 pyramid, AAA pattern, integration test isolation |
| `rules/observability.md` | Structured logging, distributed tracing, USE metrics, health endpoints |
| `hooks/validate-bash.sh` | Blocks catastrophic bash commands before execution |
| `hooks/post-edit.sh` | Formatting hints (prettier/ruff/gofmt) after file edits |
| `hooks/sync-claude-setup.sh` | Auto-syncs `~/.claude` edits back to your fork on GitHub |
| `hooks/brain-capture.sh` | Counts edits per session; reminds Claude to consider capturing learnings |
| `skills/review-pr/SKILL.md` | `/review-pr` — Senior code review with Critical/Warning/Suggestion tiers |
| `skills/commit/SKILL.md` | `/commit` — Conventional commits with staged-file deliberation |
| `skills/debug/SKILL.md` | `/debug` — Systematic root cause analysis workflow |
| `skills/brain-sync/SKILL.md` | `/brain-sync` — Capture session learnings to Obsidian Brain |
| `agents/code-reviewer.md` | Isolated read-only code review subagent |

### Obsidian vault (`~/Documents/Obsidian/Claude Brain/`)

Created on first run. Skipped safely if the vault already exists (your notes are never overwritten).

---

## Idempotent

Running `./setup.sh` multiple times is safe. Each run:
1. Backs up your existing `~/.claude` to `~/.claude_backup_TIMESTAMP`
2. Installs fresh copies of all managed files
3. **Smart-merges** `settings.json` — your existing `model`, `effortLevel`, `enabledPlugins`, and other personal settings are preserved
4. Skips the Obsidian vault if it already exists — your accumulated notes are untouched

---

## Updating from Upstream

To pull in improvements from the original repo:

```bash
cd ~/claude-setup
git remote add upstream https://github.com/iamvirul/claude-setup.git
git fetch upstream
git merge upstream/main
./setup.sh
```

---

## Uninstalling

```bash
cd ~/claude-setup
./uninstall.sh
```

Removes only the files managed by this repo. Your `~/.claude` directory, Obsidian vault, and any other files are untouched.

---

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

---

## Repository Structure

```
claude-setup/
├── setup.sh                        # Idempotent installer
├── uninstall.sh                    # Removes managed files
├── README.md
├── .gitignore
├── claude/                         # Source of truth for ~/.claude config
│   ├── CLAUDE.md
│   ├── settings.json               # Base settings (no personal plugins)
│   ├── rules/
│   │   ├── architecture.md
│   │   ├── code-quality.md
│   │   ├── security.md
│   │   ├── testing.md
│   │   └── observability.md
│   ├── hooks/
│   │   ├── validate-bash.sh
│   │   ├── post-edit.sh
│   │   ├── sync-claude-setup.sh
│   │   └── brain-capture.sh
│   ├── skills/
│   │   ├── review-pr/SKILL.md
│   │   ├── commit/SKILL.md
│   │   ├── debug/SKILL.md
│   │   └── brain-sync/SKILL.md
│   └── agents/
│       └── code-reviewer.md
└── obsidian/                       # Obsidian Brain vault template
    └── Claude Brain/
        ├── Index.md
        ├── Skills/
        │   └── Skills Index.md
        ├── Patterns/
        │   └── Patterns Index.md
        ├── Debugging/
        │   └── Debugging Index.md
        ├── Projects/
        │   └── Projects Index.md
        └── Templates/
            ├── Skill Note.md
            ├── Pattern Note.md
            ├── Debug Note.md
            └── Project Note.md
```

---

## License

MIT
