# .ai

Tool-agnostic instructions for AI agents working in Knowledge-Hub. Nothing here is specific to one assistant: every file is plain Markdown that any agent (Cursor, Codex, Copilot, Claude, or others) can read. The root [`AGENTS.md`](../AGENTS.md) is the entry point that makes these skills mandatory.

## Layout

```
.ai/
  README.md                     this file
  templates/
    note-template.md            skeleton for a new note
  skills/
    md-note-structure/SKILL.md  structure rules for every note (source of truth)
    new-note/SKILL.md           create a note and register it in README.md
    validate-note/SKILL.md      audit and fix a note
    validate-note/check-note.ps1  optional read-only checker
```

## Skill format

Each skill is a folder under `skills/` containing a `SKILL.md`, with optional supporting files next to it:

```markdown
---
name: <folder-name>
description: <what the skill does and when to use it, in one or two sentences>
---

# <Skill Title>

<Instructions: rules, steps, and a "done when" definition.>
```

- `name` matches the folder name in kebab-case.
- `description` states both *what* and *when*, because agents use it to decide whether to load the skill.
- Link other skills and templates with relative paths, so the links work in any viewer.
- Rules live in one skill only. Other skills link to it instead of restating it.

## Adding a skill

1. Create `.ai/skills/<name>/SKILL.md` in the format above.
2. Add a row to the skill index in [`AGENTS.md`](../AGENTS.md), and a mandatory rule there if agents must always apply it.
3. Add it to the layout list in this file.
