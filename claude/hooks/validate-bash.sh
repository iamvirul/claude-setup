#!/usr/bin/env bash
# PreToolUse hook: validates Bash commands before execution
# Exit 0 = allow, Exit 2 = block with message

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

if [[ -z "$COMMAND" ]]; then
  exit 0
fi

# Block catastrophic operations
DANGER_PATTERNS=(
  "rm -rf /"
  "rm -rf \$HOME"
  "rm -rf ~"
  ":(){:|:&};:"
  "mkfs\."
  "dd if=/dev/zero"
  "dd if=/dev/random"
  "> /dev/sda"
  "chmod -R 777 /"
  "chown -R .* /"
  "curl.*\| *bash"
  "wget.*\| *bash"
  "sudo passwd"
  "sudo visudo"
)

for pattern in "${DANGER_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "BLOCKED: Potentially destructive command detected: $pattern" >&2
    exit 2
  fi
done

# Warn about sensitive file access
SENSITIVE_PATTERNS=(
  "\.env$"
  "\.env\."
  "credentials"
  "\.aws/credentials"
  "\.ssh/id_"
  "\.gnupg"
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    echo "WARNING: Command accesses potentially sensitive files. Verify this is intentional." >&2
    # Don't block, just warn (exit 0)
    break
  fi
done

exit 0
