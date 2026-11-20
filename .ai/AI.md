# .ai

[Knowledge-Hub](../README.md) / .ai

Tool-agnostic instructions for AI agents working in Knowledge-Hub. Nothing here is specific to one assistant: every file is plain Markdown that any agent (Cursor, Codex, Copilot, Claude, or others) can use. The root [`AGENTS.md`](../AGENTS.md) is the entry point that makes these skills mandatory.

## Layout

```
.ai/
  AI.md                              this file
  skills/
    Skills.md                        index of every skill
    setup-owner/SKILL.md             interview the user and write people/Me.md (runs first)
    vault-conventions/SKILL.md       rules for every business note (source of truth)
    capture-input/SKILL.md           text, file, or record -> split into linked notes
    extract-tasks/SKILL.md           commitments -> task lines; complete, cancel, reassign
    update-entities/SKILL.md         create and update people/ and projects/ notes
    log-decision/SKILL.md            decision records and superseding
    query-knowledge/SKILL.md         answer questions from the vault with citations
    weekly-review/SKILL.md           weekly review in journal/
    md-note-structure/SKILL.md       structure rules for study notes (source of truth)
    new-note/SKILL.md                create a study note and register it in its topic index
  templates/
    AI_Templates.md                  index of every template
    meeting.md, person.md, ...       templates for business notes
    study-note.md                    template for a new study note
  mcp/
    MCP.md                           optional calendar, Slack, and Microsoft 365 servers
    mcp.example.json                 example MCP configuration without secrets
  scripts/
    protect-vault.ps1                one-time setup: pre-commit guard and skip-worktree on skeleton pages
```

Cursor slash commands live in `.cursor/commands/` at the repository root. Each one is a short prompt that starts a skill, for example `/setup-me` runs `setup-owner`.

## Skill format

Each skill is a folder under `skills/` containing a `SKILL.md`, with optional supporting files next to it:

```markdown
---
name: <folder-name>
description: <what the skill does and when to use it, in one or two sentences>
---

# <Skill Title>

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / <Skill Title>

<Instructions: rules, steps, and a "done when" definition.>
```

- `name` matches the folder name in kebab-case.
- `description` states both *what* and *when*, because agents use it to decide whether to load the skill.
- Link other skills and templates with relative paths, so the links work in any viewer.
- Rules live in one skill only. Other skills link to it instead of restating it. Business rules live in `vault-conventions`, and study rules in `md-note-structure`.

## Adding a skill

1. Create `.ai/skills/<name>/SKILL.md` in the format above.
2. Add a row to the skill index in [`AGENTS.md`](../AGENTS.md), and a mandatory rule there if agents must always apply it.
3. Add it to the layout list in this file and to the [skills index](skills/Skills.md).
