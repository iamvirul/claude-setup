#!/usr/bin/env bash
# Claude Code optimization setup — idempotent installer
# Usage: ./setup.sh
# Re-run at any time; backs up existing config before overwriting.

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Banner ────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}${BOLD}╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${BLUE}${BOLD}║     Claude Code — Senior Architect Setup         ║${RESET}"
echo -e "${BLUE}${BOLD}╚══════════════════════════════════════════════════╝${RESET}"
echo ""

# ── Resolve paths ─────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_CLAUDE_DIR="$SCRIPT_DIR/claude"
CLAUDE_DIR="$HOME/.claude"

# ── Prerequisites ─────────────────────────────────────────────────────────────
echo -e "${BOLD}Checking prerequisites...${RESET}"

# Bash version >= 3.2 (macOS ships 3.2)
if [[ "${BASH_VERSINFO[0]}" -lt 3 ]] || \
   { [[ "${BASH_VERSINFO[0]}" -eq 3 ]] && [[ "${BASH_VERSINFO[1]}" -lt 2 ]]; }; then
  echo -e "${RED}ERROR: Bash 3.2+ required (found ${BASH_VERSION})${RESET}" >&2
  exit 1
fi
echo -e "  ${GREEN}✓${RESET} Bash ${BASH_VERSION}"

# python3 required for settings.json merge
if ! command -v python3 &>/dev/null; then
  echo -e "${RED}ERROR: python3 is required for settings merge but was not found.${RESET}" >&2
  echo "  Install via: brew install python3  (macOS) or your package manager" >&2
  exit 1
fi
echo -e "  ${GREEN}✓${RESET} python3 $(python3 --version 2>&1 | awk '{print $2}')"
echo ""

# ── Backup existing config ────────────────────────────────────────────────────
if [[ -d "$CLAUDE_DIR" ]]; then
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  BACKUP_DIR="${CLAUDE_DIR}_backup_${TIMESTAMP}"
  echo -e "${BOLD}Backing up existing ~/.claude → ${BACKUP_DIR}${RESET}"
  cp -r "$CLAUDE_DIR" "$BACKUP_DIR"
  echo -e "  ${GREEN}✓${RESET} Backup created"
  echo ""
fi

# ── Create directories ────────────────────────────────────────────────────────
echo -e "${BOLD}Creating directory structure...${RESET}"
mkdir -p \
  "$CLAUDE_DIR/rules" \
  "$CLAUDE_DIR/hooks" \
  "$CLAUDE_DIR/skills/review-pr" \
  "$CLAUDE_DIR/skills/commit" \
  "$CLAUDE_DIR/skills/debug" \
  "$CLAUDE_DIR/skills/brain-sync" \
  "$CLAUDE_DIR/agents"
echo -e "  ${GREEN}✓${RESET} Directories ready"
echo ""

# ── Copy config files ─────────────────────────────────────────────────────────
echo -e "${BOLD}Installing config files...${RESET}"

# CLAUDE.md
cp "$REPO_CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo -e "  ${GREEN}✓${RESET} CLAUDE.md"

# Rules
for rule_file in architecture code-quality security testing observability; do
  cp "$REPO_CLAUDE_DIR/rules/${rule_file}.md" "$CLAUDE_DIR/rules/${rule_file}.md"
  echo -e "  ${GREEN}✓${RESET} rules/${rule_file}.md"
done

# Hooks
cp "$REPO_CLAUDE_DIR/hooks/validate-bash.sh"      "$CLAUDE_DIR/hooks/validate-bash.sh"
cp "$REPO_CLAUDE_DIR/hooks/post-edit.sh"           "$CLAUDE_DIR/hooks/post-edit.sh"
cp "$REPO_CLAUDE_DIR/hooks/sync-claude-setup.sh"   "$CLAUDE_DIR/hooks/sync-claude-setup.sh"
cp "$REPO_CLAUDE_DIR/hooks/brain-capture.sh"       "$CLAUDE_DIR/hooks/brain-capture.sh"
chmod +x \
  "$CLAUDE_DIR/hooks/validate-bash.sh" \
  "$CLAUDE_DIR/hooks/post-edit.sh" \
  "$CLAUDE_DIR/hooks/sync-claude-setup.sh" \
  "$CLAUDE_DIR/hooks/brain-capture.sh"
echo -e "  ${GREEN}✓${RESET} hooks/validate-bash.sh (executable)"
echo -e "  ${GREEN}✓${RESET} hooks/post-edit.sh (executable)"
echo -e "  ${GREEN}✓${RESET} hooks/sync-claude-setup.sh (executable)"
echo -e "  ${GREEN}✓${RESET} hooks/brain-capture.sh (executable)"

# Skills
for skill in review-pr commit debug brain-sync; do
  cp "$REPO_CLAUDE_DIR/skills/${skill}/SKILL.md" "$CLAUDE_DIR/skills/${skill}/SKILL.md"
  echo -e "  ${GREEN}✓${RESET} skills/${skill}/SKILL.md"
done

# Agents
cp "$REPO_CLAUDE_DIR/agents/code-reviewer.md" "$CLAUDE_DIR/agents/code-reviewer.md"
echo -e "  ${GREEN}✓${RESET} agents/code-reviewer.md"
echo ""

# ── Obsidian Brain vault ──────────────────────────────────────────────────────
echo -e "${BOLD}Setting up Obsidian Brain vault...${RESET}"

OBSIDIAN_BRAIN="$HOME/Documents/Obsidian/Claude Brain"
REPO_OBSIDIAN="$SCRIPT_DIR/obsidian/Claude Brain"

if [[ -d "$OBSIDIAN_BRAIN" ]]; then
  echo -e "  ${YELLOW}⚠${RESET}  Vault already exists — preserving existing notes"
else
  mkdir -p \
    "$OBSIDIAN_BRAIN/Skills" \
    "$OBSIDIAN_BRAIN/Patterns" \
    "$OBSIDIAN_BRAIN/Debugging" \
    "$OBSIDIAN_BRAIN/Projects" \
    "$OBSIDIAN_BRAIN/Templates"

  cp "$REPO_OBSIDIAN/Index.md"                        "$OBSIDIAN_BRAIN/Index.md"
  cp "$REPO_OBSIDIAN/Skills/Skills Index.md"          "$OBSIDIAN_BRAIN/Skills/Skills Index.md"
  cp "$REPO_OBSIDIAN/Patterns/Patterns Index.md"      "$OBSIDIAN_BRAIN/Patterns/Patterns Index.md"
  cp "$REPO_OBSIDIAN/Debugging/Debugging Index.md"    "$OBSIDIAN_BRAIN/Debugging/Debugging Index.md"
  cp "$REPO_OBSIDIAN/Projects/Projects Index.md"      "$OBSIDIAN_BRAIN/Projects/Projects Index.md"
  cp "$REPO_OBSIDIAN/Templates/"*.md                  "$OBSIDIAN_BRAIN/Templates/"
  cp "$REPO_OBSIDIAN/.gitignore"                      "$OBSIDIAN_BRAIN/.gitignore"

  echo -e "  ${GREEN}✓${RESET} Vault created: ~/Documents/Obsidian/Claude Brain/"
  echo -e "  ${GREEN}✓${RESET} Skills/, Patterns/, Debugging/, Projects/, Templates/"
fi
echo ""

# ── Link Brain to private GitHub repo ────────────────────────────────────────
echo -e "${BOLD}Linking Brain to private GitHub repo...${RESET}"

if [[ -d "$OBSIDIAN_BRAIN/.git" ]]; then
  EXISTING_REMOTE=$(cd "$OBSIDIAN_BRAIN" && git remote get-url origin 2>/dev/null || echo "not set")
  echo -e "  ${GREEN}✓${RESET} Already linked → ${EXISTING_REMOTE}"
else
  echo ""
  echo -e "  Brain notes auto-commit and push after every /brain-sync."
  echo -e "  Create a ${BOLD}private${RESET} repo on GitHub first, then paste the URL below."
  echo -e "  (Leave blank to skip — you can set this up manually later)"
  echo ""
  echo -n "  Private repo URL: "
  read -r BRAIN_REPO_URL

  if [[ -n "$BRAIN_REPO_URL" ]]; then
    # Ensure .gitignore is in place
    cp "$REPO_OBSIDIAN/.gitignore" "$OBSIDIAN_BRAIN/.gitignore"
    cd "$OBSIDIAN_BRAIN"
    git init -b main --quiet
    git remote add origin "$BRAIN_REPO_URL"
    git add -A
    git commit -m "brain: initial vault setup" --quiet
    git push -u origin main --quiet
    cd - > /dev/null
    echo -e "  ${GREEN}✓${RESET} Brain linked and pushed → ${BRAIN_REPO_URL}"
  else
    echo -e "  ${YELLOW}⚠${RESET}  Skipped. Set it up later:"
    echo "       cd ~/Documents/Obsidian/Claude\\ Brain"
    echo "       git init -b main && git remote add origin YOUR_PRIVATE_URL"
    echo "       git add -A && git commit -m 'brain: initial' && git push -u origin main"
  fi
fi
echo ""

# ── Merge settings.json ───────────────────────────────────────────────────────
echo -e "${BOLD}Merging settings.json...${RESET}"

REPO_SETTINGS="$REPO_CLAUDE_DIR/settings.json"
USER_SETTINGS="$CLAUDE_DIR/settings.json"

python3 - "$REPO_SETTINGS" "$USER_SETTINGS" <<'PYEOF'
import sys
import json
import os

repo_path = sys.argv[1]
user_path = sys.argv[2]

with open(repo_path) as f:
    repo = json.load(f)

# Load existing user settings if present (from backup or pre-existing)
user = {}
backup_settings = None

# Look for a backup of settings.json (most recent backup)
claude_dir = os.path.dirname(user_path)
parent_dir = os.path.dirname(claude_dir)
backup_dirs = sorted([
    d for d in os.listdir(parent_dir)
    if d.startswith('.claude_backup_')
], reverse=True)

if backup_dirs:
    candidate = os.path.join(parent_dir, backup_dirs[0], 'settings.json')
    if os.path.exists(candidate):
        with open(candidate) as f:
            user = json.load(f)
        backup_settings = candidate

# Merge strategy: repo keys are base; user keys WIN on conflict
# Special case: enabledPlugins from user is preserved entirely
merged = {**repo, **user}

# Always use the full permissions and hooks blocks from repo
# (user overrides are in the user's CLAUDE.md / manual edits)
merged['permissions'] = repo['permissions']
merged['hooks'] = repo['hooks']

# Preserve user's model/effortLevel if they had one
for key in ('model', 'effortLevel', 'autoMemoryEnabled'):
    if key in user:
        merged[key] = user[key]

with open(user_path, 'w') as f:
    json.dump(merged, f, indent=2)
    f.write('\n')

if backup_settings:
    print(f"  Merged from backup: {backup_settings}")
else:
    print("  No prior settings found — using repo defaults")

PYEOF

echo -e "  ${GREEN}✓${RESET} settings.json written"
echo ""

# ── Verification ──────────────────────────────────────────────────────────────
echo -e "${BOLD}Verifying installation...${RESET}"

ERRORS=0

check_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    echo -e "  ${GREEN}✓${RESET} $path"
  else
    echo -e "  ${RED}✗${RESET} MISSING: $path"
    ERRORS=$((ERRORS + 1))
  fi
}

check_executable() {
  local path="$1"
  if [[ -x "$path" ]]; then
    echo -e "  ${GREEN}✓${RESET} $path (executable)"
  else
    echo -e "  ${RED}✗${RESET} NOT EXECUTABLE: $path"
    ERRORS=$((ERRORS + 1))
  fi
}

check_file "$CLAUDE_DIR/CLAUDE.md"
check_file "$CLAUDE_DIR/settings.json"
check_file "$CLAUDE_DIR/rules/architecture.md"
check_file "$CLAUDE_DIR/rules/code-quality.md"
check_file "$CLAUDE_DIR/rules/security.md"
check_file "$CLAUDE_DIR/rules/testing.md"
check_file "$CLAUDE_DIR/rules/observability.md"
check_executable "$CLAUDE_DIR/hooks/validate-bash.sh"
check_executable "$CLAUDE_DIR/hooks/post-edit.sh"
check_executable "$CLAUDE_DIR/hooks/sync-claude-setup.sh"
check_executable "$CLAUDE_DIR/hooks/brain-capture.sh"
check_executable "$CLAUDE_DIR/hooks/sync-brain.sh"
check_file "$CLAUDE_DIR/skills/review-pr/SKILL.md"
check_file "$CLAUDE_DIR/skills/commit/SKILL.md"
check_file "$CLAUDE_DIR/skills/debug/SKILL.md"
check_file "$CLAUDE_DIR/skills/brain-sync/SKILL.md"
check_file "$CLAUDE_DIR/agents/code-reviewer.md"
echo ""

if [[ "$ERRORS" -gt 0 ]]; then
  echo -e "${RED}${BOLD}Setup completed with $ERRORS error(s). Review output above.${RESET}"
  exit 1
fi

# ── Success ───────────────────────────────────────────────────────────────────
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║  ✓  Claude Code setup complete!                  ║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "Installed to: ${BOLD}${CLAUDE_DIR}${RESET}"
echo ""
echo -e "${BOLD}What's active:${RESET}"
echo "  • CLAUDE.md           — Staff engineer mindset + architecture principles"
echo "  • rules/ (5)          — Code quality, security, testing, observability, architecture"
echo "  • hooks/ (5)          — Bash validation, post-edit hints, auto-sync to GitHub, brain capture, brain push"
echo "  • skills/ (4)         — /review-pr, /commit, /debug, /brain-sync"
echo "  • agents/ (1)         — code-reviewer (read-only subagent)"
echo "  • Obsidian Brain       — ~/Documents/Obsidian/Claude Brain/"
echo ""
echo -e "${BOLD}Obsidian setup (manual — do this once):${RESET}"
echo "  1. Open Obsidian → Open vault → ~/Documents/Obsidian"
echo "  2. Install 'Local REST API' community plugin and enable it"
echo "  3. Open Graph View (Ctrl+G) to explore your growing knowledge base"
echo "  4. Type /brain-sync in Claude Code to capture session learnings"
echo ""
echo -e "${YELLOW}Restart Claude Code to activate all changes.${RESET}"
echo ""
