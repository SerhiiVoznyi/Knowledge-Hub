# AGENTS.md

[Knowledge-Hub](README.md) / AGENTS.md

Instructions for any AI agent working in this repository.

## Repository

Knowledge-Hub is a personal business knowledge base, kept as an Obsidian vault of Markdown files. Agents turn conversations (pasted notes, audio recordings, Teams, Zoom, or Meet transcripts, Slack or Teams chats, and email threads) into linked notes about meetings, people, projects, decisions, and tasks, and answer questions from those notes. The repo also keeps an archive of study notes. There is no build. The product is the notes themselves.

| Folder | Contents |
|--------|----------|
| `inbox/` | Raw input waiting to be ingested. `inbox/_processed/` holds ingested raw input. `inbox/audio/` holds recordings (git-ignored) |
| `meetings/<YYYY>/` | One note per conversation |
| `people/` | One note per person. `people/Me.md` is the vault owner |
| `projects/` | One note per project or client engagement |
| `decisions/` | One note per decision |
| `notes/` | Standalone information that is not a conversation: reference facts, ideas, findings, records |
| `tasks/` | `Standalone_Tasks.md`, for tasks that did not come from a meeting |
| `journal/` | Weekly reviews |
| `dashboards/` | Dataview pages for open tasks, follow-ups, and active projects |
| `study/` | Study notes and interview cheat sheets (.NET, databases, algorithms, AWS) |
| `Clippings/` | Web pages saved with the Obsidian Web Clipper (created on first use, local only) |
| `.ai/` | Agent skills, note templates, and MCP setup (see [`.ai/AI.md`](.ai/AI.md)) |

[`README.md`](README.md) is the entry point: it explains how to use the vault and links every folder's index file. An index file is named after its folder in Title Case: `people/People.md`, `meetings/2026/2026.md`, `study/aws/AWS.md`. Each index links back to its parent and down to its subfolders and notes, so the indexes form the backbone of the knowledge graph (see section 8 of `vault-conventions`). The root `README.md` is the only file still called `README.md`.

## Mandatory rules

1. **Vault owner first**: before any business-note request (capture, task, decision, person or project update, question about past work, weekly review), check that `people/Me.md` is complete as defined in [`.ai/skills/setup-owner/SKILL.md`](.ai/skills/setup-owner/SKILL.md). If it is missing or incomplete, run `setup-owner` first, then continue with the original request. Also run it whenever the user says "set up my profile" or `/setup-me`.
2. **Business notes** (any `.md` file in `meetings/`, `people/`, `projects/`, `decisions/`, `notes/`, `tasks/`, `journal/`, or `dashboards/`): before creating or editing one, read [`.ai/skills/vault-conventions/SKILL.md`](.ai/skills/vault-conventions/SKILL.md) and follow it.
3. **Adding information**: every request to add, save, record, or file information from text, a file, a chat or email thread, or a record, and every item in `inbox/`, goes through [`.ai/skills/capture-input/SKILL.md`](.ai/skills/capture-input/SKILL.md).
4. **Questions about past work**: answer them with [`.ai/skills/query-knowledge/SKILL.md`](.ai/skills/query-knowledge/SKILL.md), from the vault only, and cite the notes you used.
5. **Study notes** (any `.md` file under `study/`): before creating or editing one, read [`.ai/skills/md-note-structure/SKILL.md`](.ai/skills/md-note-structure/SKILL.md). To add a new one, follow [`.ai/skills/new-note/SKILL.md`](.ai/skills/new-note/SKILL.md).
6. **Folder indexes**: when you create, rename, or delete a note or folder, update the index file of its folder (and of the parent folder for a new folder) in the same change. A new folder gets an index file named after the folder in Title Case (`meetings/2027/2027.md`).
   - **Breadcrumbs**: every file except the root `README.md` has a breadcrumb line directly under its H1. It is a chain of relative links to the root README and the parent folder indexes, ending with the file's own title: `[Knowledge-Hub](../README.md) / [People](People.md) / Anna Kowalska`.
   - When a file moves or is renamed, fix its breadcrumb. When a folder moves, fix the breadcrumbs of everything inside it.
7. **Templates and metadata**: create every new note, business or study, by copying its template. Never write a note from scratch. Each template starts with a YAML front-matter metadata block of flat key/value pairs:
   - what the file is: `type`, `title`, `summary`, and `covers`;
   - its facts;
   - reference keys that link related documents;
   - `created` and `updated`.

   Keep every key in the template's order, and leave a value empty only when it is unknown. On every edit, bump `updated` and keep reference links reciprocal. The keys are defined in section 2 of `vault-conventions`, and for study notes in rule 1 of `md-note-structure`.
8. **Faithfulness**: never invent facts, dates, numbers, or commitments. Anything uncertain goes under Open Questions.
9. If a user instruction conflicts with these skills, follow the user and say which rule was overridden.

## Skill index

| Skill | Path | Use when |
|-------|------|----------|
| `setup-owner` | [`.ai/skills/setup-owner/SKILL.md`](.ai/skills/setup-owner/SKILL.md) | `people/Me.md` is missing or incomplete, or the user asks to set up or update their profile. Interviews the user and writes the owner note |
| `vault-conventions` | [`.ai/skills/vault-conventions/SKILL.md`](.ai/skills/vault-conventions/SKILL.md) | Writing or editing any business note. Defines types, templates, front-matter metadata, links, and the task format |
| `capture-input` | [`.ai/skills/capture-input/SKILL.md`](.ai/skills/capture-input/SKILL.md) | The user asks to add information from text, a file, a thread, or a record, or there is something in `inbox/`. Splits it into meeting, decision, task, person, project, and standalone notes |
| `extract-tasks` | [`.ai/skills/extract-tasks/SKILL.md`](.ai/skills/extract-tasks/SKILL.md) | Pulling tasks out of a conversation, or adding, completing, or reassigning a task |
| `update-entities` | [`.ai/skills/update-entities/SKILL.md`](.ai/skills/update-entities/SKILL.md) | Creating or updating person and project notes |
| `log-decision` | [`.ai/skills/log-decision/SKILL.md`](.ai/skills/log-decision/SKILL.md) | Recording, revisiting, or superseding a decision |
| `query-knowledge` | [`.ai/skills/query-knowledge/SKILL.md`](.ai/skills/query-knowledge/SKILL.md) | Answering any question about past conversations, people, projects, decisions, or tasks |
| `weekly-review` | [`.ai/skills/weekly-review/SKILL.md`](.ai/skills/weekly-review/SKILL.md) | Writing the weekly review in `journal/` |
| `md-note-structure` | [`.ai/skills/md-note-structure/SKILL.md`](.ai/skills/md-note-structure/SKILL.md) | Writing or editing a study note under `study/` |
| `new-note` | [`.ai/skills/new-note/SKILL.md`](.ai/skills/new-note/SKILL.md) | Creating a new study note and adding it to its topic index file |

All templates are in [`.ai/templates/`](.ai/templates/AI_Templates.md). Business templates: `meeting.md`, `person.md`, `project.md`, `decision.md`, `note.md`, `tasks.md`, `weekly-review.md`, and `dashboard.md`. The study template is `study-note.md`.

## Scope

- `inbox/`, `Clippings/`, the root `README.md` and every folder index file, `AGENTS.md`, `.obsidian/`, and files under `.ai/` are not notes and are not validated.
- `test-tasks/` holds only local, git-ignored build output. It is not part of the vault.
- The vault holds real conversations and personal data. Do not send its content to external services other than the configured MCP tools.
- The repository is a public-safe template. [`.gitignore`](.gitignore) is an allowlist: only `README.md`, `AGENTS.md`, `.ai/`, `.assets/`, `study/`, `.githooks/`, and the empty skeleton of the private folders (index pages, `.gitkeep`, dashboard queries) are tracked. Every note, `people/Me.md`, and any new root folder stay local.
- Never run `git add -f` on ignored files, never set `ALLOW_SKELETON=1`, and never undo `.ai/scripts/protect-vault.ps1` unless the user explicitly asks to change the published skeleton.
