#!/usr/bin/env bash
# Claude Code optimization setup — uninstaller
# Removes all files installed by setup.sh.
# Does NOT remove ~/.claude entirely — only the files this repo manages.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

CLAUDE_DIR="$HOME/.claude"

echo ""
echo -e "${YELLOW}${BOLD}Claude Code Setup — Uninstaller${RESET}"
echo ""

if [[ ! -d "$CLAUDE_DIR" ]]; then
  echo -e "${YELLOW}Nothing to uninstall: ~/.claude does not exist.${RESET}"
  exit 0
fi

echo -e "${BOLD}This will remove the following from ~/.claude:${RESET}"
echo "  • CLAUDE.md"
echo "  • rules/{architecture,code-quality,security,testing,observability}.md"
echo "  • hooks/{validate-bash,post-edit}.sh"
echo "  • skills/{review-pr,commit,debug}/SKILL.md"
echo "  • agents/code-reviewer.md"
echo "  • settings.json (replaced with minimal stub)"
echo ""
echo -e "${YELLOW}Your ~/.claude directory itself and any other files will NOT be touched.${RESET}"
echo ""
read -r -p "Continue? [y/N] " confirm
if [[ "${confirm,,}" != "y" ]]; then
  echo "Aborted."
  exit 0
fi
echo ""

remove_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    rm "$path"
    echo -e "  ${GREEN}✓${RESET} Removed $path"
  else
    echo -e "  (skipped — not found) $path"
  fi
}

remove_dir_if_empty() {
  local path="$1"
  if [[ -d "$path" ]] && [[ -z "$(ls -A "$path")" ]]; then
    rmdir "$path"
    echo -e "  ${GREEN}✓${RESET} Removed empty dir $path"
  fi
}

echo -e "${BOLD}Removing files...${RESET}"

remove_file "$CLAUDE_DIR/CLAUDE.md"
remove_file "$CLAUDE_DIR/rules/architecture.md"
remove_file "$CLAUDE_DIR/rules/code-quality.md"
remove_file "$CLAUDE_DIR/rules/security.md"
remove_file "$CLAUDE_DIR/rules/testing.md"
remove_file "$CLAUDE_DIR/rules/observability.md"
remove_file "$CLAUDE_DIR/hooks/validate-bash.sh"
remove_file "$CLAUDE_DIR/hooks/post-edit.sh"
remove_file "$CLAUDE_DIR/skills/review-pr/SKILL.md"
remove_file "$CLAUDE_DIR/skills/commit/SKILL.md"
remove_file "$CLAUDE_DIR/skills/debug/SKILL.md"
remove_file "$CLAUDE_DIR/agents/code-reviewer.md"

# Remove settings.json and replace with a minimal stub
if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
  rm "$CLAUDE_DIR/settings.json"
  cat > "$CLAUDE_DIR/settings.json" <<'JSON'
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
JSON
  echo -e "  ${GREEN}✓${RESET} settings.json reset to minimal stub"
fi

# Clean up empty directories
echo ""
echo -e "${BOLD}Cleaning empty directories...${RESET}"
for dir in \
  "$CLAUDE_DIR/skills/review-pr" \
  "$CLAUDE_DIR/skills/commit" \
  "$CLAUDE_DIR/skills/debug" \
  "$CLAUDE_DIR/skills" \
  "$CLAUDE_DIR/rules" \
  "$CLAUDE_DIR/hooks" \
  "$CLAUDE_DIR/agents"; do
  remove_dir_if_empty "$dir"
done

echo ""
echo -e "${GREEN}${BOLD}Uninstall complete.${RESET}"
echo ""
echo "To reinstall, run: ./setup.sh"
echo ""
