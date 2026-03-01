#!/usr/bin/env bash
# PostToolUse hook: runs after Edit/Write tool calls
# Provides file-aware feedback and optional formatting hints

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Provide formatting hints based on file type
case "$EXT" in
  ts|tsx|js|jsx|mjs|cjs)
    # Check if prettier is available
    if command -v prettier &>/dev/null; then
      prettier --check "$FILE_PATH" &>/dev/null || \
        echo "HINT: Run 'prettier --write $FILE_PATH' to auto-format" >&2
    fi
    # Check if eslint config exists
    if [[ -f ".eslintrc*" ]] || [[ -f "eslint.config*" ]]; then
      echo "REMINDER: Run eslint on $FILE_PATH before committing" >&2
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      ruff check "$FILE_PATH" &>/dev/null || \
        echo "HINT: Run 'ruff check --fix $FILE_PATH' to auto-fix linting" >&2
    fi
    ;;
  go)
    if command -v gofmt &>/dev/null; then
      GOFMT_OUTPUT=$(gofmt -l "$FILE_PATH" 2>/dev/null)
      if [[ -n "$GOFMT_OUTPUT" ]]; then
        echo "HINT: Run 'gofmt -w $FILE_PATH' to format" >&2
      fi
    fi
    ;;
  rs)
    echo "REMINDER: Run 'cargo fmt' and 'cargo clippy' before committing" >&2
    ;;
esac

exit 0
