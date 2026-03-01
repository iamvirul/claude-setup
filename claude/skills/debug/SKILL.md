---
name: debug
description: >
  Systematic debugging workflow. Given a bug description or error, finds root cause
  and proposes a minimal, correct fix. Use when investigating unexpected behavior.
allowed-tools: Read, Grep, Glob, Bash(git log*), Bash(git diff*), Bash(git blame*)
---

Perform systematic root cause analysis. Do not guess — investigate.

## Debugging Process

### 1. Reproduce & Characterize
- What is the exact error message or unexpected behavior?
- Under what conditions does it occur? (always / sometimes / specific input)
- When did it start? (check recent commits if unknown)
  ```bash
  git log --oneline -20
  git diff HEAD~5 HEAD -- <file>
  ```

### 2. Narrow the Scope
- Read the error trace from bottom to top (root cause is usually at the bottom)
- Identify the exact file and line where it fails
- Find the entry point that triggers the failure path

### 3. Understand the Data Flow
- Trace the input from entry point to failure
- What state is expected vs. what state exists?
- Is this a type mismatch? Null where non-null expected? Wrong assumptions?

### 4. Find the Root Cause
- The root cause is rarely where the error throws — it's where wrong data was created
- Check: Was this always broken, or did a recent change introduce it?
  ```bash
  git blame <file>:<line>
  git log -S "relevant_function_name" --oneline
  ```

### 5. Propose a Minimal Fix
- Fix the root cause, not the symptom
- Minimal change: don't refactor while fixing
- Add a regression test that would have caught this
- Explain WHY the fix works

### Output Format

```
## Root Cause
[Clear explanation of what the actual bug is and why it fails]

## Evidence
- `file.ts:42` — [what the code does wrong]
- [relevant data/state that confirms the diagnosis]

## Fix
[Minimal code change, with explanation of why it's correct]

## Regression Test
[Test that would catch this in the future]

## What NOT to do
[Common wrong fixes people might try and why they don't address root cause]
```

Do not fix symptoms. Do not over-engineer the fix.
