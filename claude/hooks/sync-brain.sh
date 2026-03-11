#!/usr/bin/env bash
# sync-brain.sh — Auto-commit and push Obsidian Brain changes to private repo
#
# Fires on PostToolUse (Edit|Write). Only acts when the written file is inside
# ~/Documents/Obsidian/Claude Brain/. Commits and pushes in the background
# so it never blocks Claude.

set -euo pipefail

BRAIN_DIR="$HOME/Documents/Obsidian/Claude Brain"

# Read tool input from stdin
INPUT=$(cat)

# Extract file_path from JSON tool input
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json, os
d = json.load(sys.stdin)
path = d.get('tool_input', {}).get('file_path', '')
print(os.path.expanduser(path))
" 2>/dev/null || echo "")

# Nothing to do if no path extracted
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Only act on files inside the brain vault
if [[ "$FILE_PATH" != "$BRAIN_DIR"* ]]; then
  exit 0
fi

# Brain must be a git repo — bail silently if not set up yet
if [[ ! -d "$BRAIN_DIR/.git" ]]; then
  exit 0
fi

# Commit and push in background (non-blocking)
(
  cd "$BRAIN_DIR"

  # Stage all changes (new notes, edits, deletes)
  git add -A

  # Nothing staged? Nothing to do.
  if git diff --cached --quiet; then
    exit 0
  fi

  NOTE_NAME="$(basename "$FILE_PATH" .md)"
  git commit -m "brain: ${NOTE_NAME} — $(date '+%Y-%m-%d %H:%M')" --quiet
  git push origin HEAD --quiet
  echo "BRAIN SYNC: Pushed '${NOTE_NAME}' to private repo" >&2
) &

exit 0
