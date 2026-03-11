# Skill: brain-sync

## Trigger
User types `/brain-sync` or asks to "sync to Obsidian", "capture learnings", "save to brain", or "update knowledge base".

## Purpose
Capture meaningful learnings from the current session into the Obsidian Brain vault at `~/Documents/Obsidian/Claude Brain/`.

---

## Execution Instructions

When this skill is triggered, perform the following steps IN ORDER:

### Step 1 — Assess what's worth capturing

Review the current session context and identify learnings that fall into these categories:

| Category | Capture if... |
|----------|--------------|
| **Skill** | You solved something in a reusable way — a technique that will apply again |
| **Pattern** | You identified an architectural pattern worth repeating |
| **Debug** | You diagnosed a non-obvious bug (root cause wasn't immediately clear) |
| **Project** | You worked on a new codebase and learned its structure/conventions |

**DO NOT capture**: trivial changes, obvious fixes, user-specific one-off tasks, anything that won't generalize.

### Step 2 — Check for existing notes to avoid duplicates

Before creating a new note:
1. Use `Glob` to check if a similar note already exists: `~/Documents/Obsidian/Claude Brain/**/*.md`
2. Use `Grep` to search for the topic in existing notes
3. If a related note exists → **update it** (add the new insight) rather than creating a duplicate

### Step 3 — Write the note(s)

For each learning worth capturing:

**File naming:**
- Skills: `~/Documents/Obsidian/Claude Brain/Skills/{{descriptive-kebab-name}}.md`
- Patterns: `~/Documents/Obsidian/Claude Brain/Patterns/{{descriptive-kebab-name}}.md`
- Debugging: `~/Documents/Obsidian/Claude Brain/Debugging/{{symptom-description}}.md`
- Projects: `~/Documents/Obsidian/Claude Brain/Projects/{{project-name}}.md`

**Use the templates in `~/Documents/Obsidian/Claude Brain/Templates/`** — fill every field, no placeholders left behind.

**Frontmatter requirements:**
- `type`: skill | pattern | debug | project
- `tags`: always include type, language, and topic
- `created`: today's date (YYYY-MM-DD format)
- `project`: current project name or "general"

### Step 4 — Update the relevant Index

After writing each note, append a wikilink line to the category's index file:

| Category | Index file to update |
|----------|---------------------|
| Skill    | `~/Documents/Obsidian/Claude Brain/Skills/Skills Index.md` |
| Pattern  | `~/Documents/Obsidian/Claude Brain/Patterns/Patterns Index.md` |
| Debug    | `~/Documents/Obsidian/Claude Brain/Debugging/Debugging Index.md` |
| Project  | `~/Documents/Obsidian/Claude Brain/Projects/Projects Index.md` |

Append: `- [[note-filename|Human Readable Title]]`

### Step 5 — Report what was captured

Output a concise summary:
```
Captured to Obsidian Brain:
  ✓ Skill: [note name] → Skills/filename.md
  ✓ Debug: [note name] → Debugging/filename.md
  (nothing else worth capturing this session)
```

---

## Quality Rules

- **Every note must be immediately useful** if read in a future session with zero prior context.
- **Code examples must be complete** — no `// ...`, no `TODO`.
- **The "Key Insight" or "Root Cause" field is mandatory** — it's the most valuable part.
- Notes that are too vague or generic will be useless. If you can't write a specific insight, don't write the note.
