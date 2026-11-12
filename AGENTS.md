# AGENTS.md

Instructions for any AI agent working in this repository.

## Repository

Knowledge-Hub is a personal collection of study notes and interview cheat sheets in Markdown. There is no build. The product is the notes themselves.

| Folder | Contents |
|--------|----------|
| `dotnet/` | C# and .NET platform, EF Core, concurrency |
| `databases/` | SQL, relational fundamentals, PostgreSQL |
| `algorithms/` | Searching, sorting, interview algorithm patterns |
| `aws/` | AWS Solutions Architect (Associate and Professional) |
| `.ai/` | Agent skills and templates (see [`.ai/README.md`](.ai/README.md)) |

[`README.md`](README.md) is the human-facing catalog of every note.

## Mandatory rules

These apply to every task that touches a note (any `.md` file in a topic folder):

1. **Before creating or editing a note**, read [`.ai/skills/md-note-structure/SKILL.md`](.ai/skills/md-note-structure/SKILL.md) and follow it. Every note has a `# <Topic>` title, a `## Content` section linking to every section, and `[↑ Content](#content)` under every section heading.
2. **To add a new note**, follow [`.ai/skills/new-note/SKILL.md`](.ai/skills/new-note/SKILL.md), including registering it in the `README.md` catalog.
3. **After any note edit**, run [`.ai/skills/validate-note/SKILL.md`](.ai/skills/validate-note/SKILL.md) on each changed note and fix every finding before finishing.
4. If a user instruction conflicts with these skills, follow the user and say which rule was overridden.

## Skill index

| Skill | Path | Use when |
|-------|------|----------|
| `md-note-structure` | [`.ai/skills/md-note-structure/SKILL.md`](.ai/skills/md-note-structure/SKILL.md) | Writing or editing any note. Defines the template and rules |
| `new-note` | [`.ai/skills/new-note/SKILL.md`](.ai/skills/new-note/SKILL.md) | Creating a new note and adding it to `README.md` |
| `validate-note` | [`.ai/skills/validate-note/SKILL.md`](.ai/skills/validate-note/SKILL.md) | Checking or fixing a note's structure, after every edit |

Template: [`.ai/templates/note-template.md`](.ai/templates/note-template.md).

## Scope

- `test-tasks/` holds only local, git-ignored build output (`bin/`, `obj/`). It is not part of the notes, and the note rules do not apply there.
- `README.md`, `AGENTS.md`, and files under `.ai/` are not notes and do not follow the note template.
