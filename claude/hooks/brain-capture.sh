#!/bin/bash
# brain-capture.sh — Reminds Claude to capture learnings to Obsidian Brain
# Runs after file edits. Every 5 edits in a session, prompts a brain-capture consideration.

COUNTER_FILE="/tmp/claude-brain-edit-counter-$$"
SESSION_FILE="/tmp/claude-brain-session"

# Use a stable session key (PID of the parent shell)
SESSION_PID=$(ps -p $$ -o ppid= 2>/dev/null | tr -d ' ')
COUNTER_FILE="/tmp/claude-brain-edits-${SESSION_PID}"

count=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
count=$((count + 1))
echo "$count" > "$COUNTER_FILE"

# Every 5 edits, emit a brain reminder
if (( count % 5 == 0 )); then
  echo ""
  echo "BRAIN: $count edits this session. After completing this task, check: did you learn something worth capturing to ~/Documents/Obsidian/Claude Brain/? (skill, pattern, or debug solution)"
fi

exit 0
