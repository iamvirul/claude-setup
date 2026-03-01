#!/usr/bin/env bash
# PostToolUse hook: auto-syncs ~/.claude edits back to ~/claude-setup repo
# Fires after every Edit/Write. If the changed file is a managed ~/.claude file,
# copies it to the repo and pushes to GitHub.

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json, os
d = json.load(sys.stdin)
path = d.get('tool_input', {}).get('file_path', '')
print(os.path.expanduser(path))
" 2>/dev/null || echo "")

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

CLAUDE_DIR="$HOME/.claude"
REPO_DIR="$HOME/claude-setup"
REPO_CLAUDE_DIR="$REPO_DIR/claude"

# Only act on files inside ~/.claude/
if [[ "$FILE_PATH" != "$CLAUDE_DIR/"* ]]; then
  exit 0
fi

# Only act on managed file types
RELATIVE="${FILE_PATH#"$CLAUDE_DIR/"}"
case "$RELATIVE" in
  CLAUDE.md|\
  settings.json|\
  rules/*.md|\
  hooks/*.sh|\
  skills/*/SKILL.md|\
  agents/*.md)
    ;;
  *)
    exit 0
    ;;
esac

# Repo must exist
if [[ ! -d "$REPO_DIR/.git" ]]; then
  echo "SYNC: Skipping — $REPO_DIR is not a git repo" >&2
  exit 0
fi

# Copy file into repo, preserving subdirectory structure
DEST="$REPO_CLAUDE_DIR/$RELATIVE"
DEST_DIR="$(dirname "$DEST")"
mkdir -p "$DEST_DIR"
cp "$FILE_PATH" "$DEST"

# Commit and push in background (non-blocking)
(
  cd "$REPO_DIR"
  if git diff --quiet "$DEST" 2>/dev/null && git ls-files --error-unmatch "$DEST" &>/dev/null; then
    # No changes tracked — nothing to commit
    exit 0
  fi
  git add "$DEST"
  # Only commit if there's actually something staged
  if git diff --cached --quiet; then
    exit 0
  fi
  SHORT_NAME="$(basename "$RELATIVE")"
  git commit -m "chore: auto-sync ${SHORT_NAME}" --quiet
  git push --quiet origin main
  echo "SYNC: Pushed ${RELATIVE} to GitHub" >&2
) &

exit 0
