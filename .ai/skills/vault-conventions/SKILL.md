---
name: vault-conventions
description: Source of truth for business notes in the Knowledge-Hub Obsidian vault — note types, folders, templates, file names, the YAML front-matter metadata (keys, order, reference links), wiki-links, the inline task format, and the English-only rule. Use before creating or editing any note in meetings/, people/, projects/, decisions/, notes/, tasks/, journal/, or dashboards/.
---

# Vault Conventions

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Vault Conventions

Knowledge-Hub is an Obsidian vault of business knowledge: conversations, the people and projects they involve, the decisions they produce, and the tasks that follow. These rules apply to every note in the business folders. Study notes under `study/` follow [`md-note-structure`](../md-note-structure/SKILL.md) instead.

Other skills link here instead of restating these rules.

## 1. Note types and folders

| Type | Folder | File name | Template |
|------|--------|-----------|----------|
| `meeting` | `meetings/<YYYY>/` | `YYYY.MM.DDTHH.MM.SS-Short-Title.md` | [`meeting.md`](../../templates/meeting.md) |
| `person` | `people/` | `First_Last.md` | [`person.md`](../../templates/person.md) |
| `project` | `projects/` | `Project-Name.md` | [`project.md`](../../templates/project.md) |
| `decision` | `decisions/` | `YYYY.MM.DDTHH.MM.SS-Short-Title.md` | [`decision.md`](../../templates/decision.md) |
| `note` | `notes/` | `YYYY.MM.DDTHH.MM.SS-Short-Title.md` | [`note.md`](../../templates/note.md) |
| `tasks` | `tasks/` | `Standalone_Tasks.md` | [`tasks.md`](../../templates/tasks.md) |
| `weekly-review` | `journal/` | `YYYY.MM.DDTHH.MM.SS-Weekly-Review-YYYY-Www.md` | [`weekly-review.md`](../../templates/weekly-review.md) |
| `dashboard` | `dashboards/` | `Title_Case.md` | [`dashboard.md`](../../templates/dashboard.md) |

Templates live in [`.ai/templates/`](../../templates/AI_Templates.md), next to the study note template.

**Every new note is created by copying its template. Never write a note from scratch or from memory.** Copy the whole file, keep every front-matter key and every section, and replace every `<% ... %>` Templater expression and every `<...>` placeholder with real values, or delete the placeholder line. A note whose front matter is missing a key from section 2 is incomplete.
- `inbox/` holds raw input waiting to be filed into notes. `inbox/_processed/` holds raw input that has already been ingested. Neither is a note, and neither is validated.
- A meeting's year folder matches the year of its `date`.
- File names use ASCII letters, digits, `-`, and `_` only. Transliterate names with diacritics (`Łukasz Żak` becomes `Lukasz_Zak.md`) and keep the real spelling in the H1 and in `aliases`.
- Meetings, decisions, notes, and weekly reviews are named `<timestamp>-<Short-Title>.md`, with a lowercase `.md`: `2026.11.20T14.30.00-Client-X-Kickoff.md`. People, projects, `Standalone_Tasks.md`, and dashboards keep stable names so their wiki-links stay readable.
  - The timestamp is `YYYY.MM.DDTHH.MM.SS` in 24-hour local time.
  - **Meeting:** the start of the conversation. If only the date is known, use `T00.00.00` and leave `time` empty.
  - **Decision:** the timestamp of the meeting it came from; otherwise the time it was made, or `T00.00.00` on its date.
  - **Note:** the date and time the information refers to, if the source states one; otherwise the time it was captured.
  - **Weekly review:** the time it was written. Its short title is `Weekly-Review-YYYY-Www`.
  - For meetings, decisions, and notes, the date part matches the note's `date`.
- `Short-Title` is two to five words in Title-Case joined with hyphens: `Client-X-Kickoff`.
- Every note file name (without `.md`) is unique across the whole vault, because wiki-links resolve by file name. Folder index files (section 8) follow the same rule. They are not notes, even though they sit next to notes and have no fixed shared name.
- Inbox file names start with the date and the source, in lowercase: `2026-11-20_audio_client-call.md`. This keeps them from colliding with note names.

## 2. Front matter

Every business note starts with a YAML front-matter block. It is the note's metadata: flat key/value pairs that tell an agent what the file is, what data it covers, and which documents it relates to, without reading the body. Study notes use the same idea with the keys defined in [`md-note-structure`](../md-note-structure/SKILL.md#1-front-matter-title-and-intro).

### 2.1 Shape rules

- **Every key listed for the type is present**, in the order listed. A value is left empty (`""` or `[]`) only when the fact is unknown or does not apply, never guessed and never omitted.
- **Keys come in four groups, always in this order:** identity (`type`, `title`, `summary`, `covers`), facts (the type's own fields), references (links to other documents), housekeeping (`aliases`, `tags`, `created`, `updated`).
- **Flat only.** One key per line, scalar values or inline lists (`[a, b]`). No nested objects and no multi-line block lists, because the Obsidian Properties panel cannot edit them.
- **Strings that contain `:`, `#`, `[`, or a leading quote are quoted.** `title` and `summary` are always quoted. Agents use double quotes; the templates use single quotes around Templater expressions, which is equally valid.

### 2.2 Keys per type

| Type | Identity | Facts | References | Housekeeping |
|------|----------|-------|------------|--------------|
| `meeting` | `type`, `title`, `summary`, `covers` | `date`, `time`, `duration`, `location`, `source`, `source_lang`, `status` | `participants`, `project`, `decisions`, `notes`, `follow_up_of`, `raw_input`, `related` | `tags`, `created`, `updated` |
| `person` | `type`, `title`, `summary`, `covers` | `company`, `role`, `email`, `phone`, `timezone` | `projects`, `related` | `aliases`, `tags`, `created`, `updated` |
| `project` | `type`, `title`, `summary`, `covers` | `client`, `status`, `start`, `end` | `owner`, `stakeholders`, `meetings`, `related` | `aliases`, `tags`, `created`, `updated` |
| `decision` | `type`, `title`, `summary`, `covers` | `date`, `status` | `project`, `decided_by`, `source`, `supersedes`, `superseded_by`, `related` | `tags`, `created`, `updated` |
| `note` | `type`, `title`, `summary`, `covers` | `date`, `source` | `project`, `people`, `meetings`, `raw_input`, `related` | `tags`, `created`, `updated` |
| `tasks` | `type`, `title`, `summary`, `covers` | | `projects`, `related` | `tags`, `created`, `updated` |
| `weekly-review` | `type`, `title`, `summary`, `covers` | `week`, `start`, `end` | `previous_review`, `projects`, `related` | `tags`, `created`, `updated` |
| `dashboard` | `type`, `title`, `summary`, `covers` | `queries`, `requires` | `related` | `tags`, `created`, `updated` |

Example (meeting):

```yaml
---
type: meeting
title: "Client X Kickoff"
summary: "Kickoff call that fixed the phase 1 scope and the pricing model."
covers: [phase 1 scope, pricing model, go-live date]
date: 2026-11-20
time: "14:30"
duration: "45m"
location: "Teams"
source: teams
source_lang: pl
status: processed
participants: ["[[Anna_Kowalska]]", "[[Me]]"]
project: "[[Client-X-Migration]]"
decisions: ["[[2026.11.20T14.30.00-Pricing-Model]]"]
notes: []
follow_up_of: ""
raw_input: "inbox/_processed/2026-11-20_teams_client-x-kickoff.md"
related: []
tags: [kickoff]
created: 2026-11-20
updated: 2026-11-20
---
```

### 2.3 Identity and housekeeping keys

- `type` is always set and matches the table in section 1.
- `title` is the human-readable title, identical to the H1.
- `summary` is one sentence saying what the document is and why it is kept: what happened in a meeting, who a person is, what a project delivers, what was decided. Never empty.
- `covers` is a list of the topics, entities, or data the document contains, as short lowercase phrases without links: `[phase 1 scope, pricing model, go-live date]`. An agent should be able to tell from `summary` and `covers` alone whether the note answers a question. Never empty, except in a note that has no content yet.
- `aliases` lists other names for a person or project (short forms, original-script spelling).
- `tags` is a YAML list of lowercase kebab-case words without `#`: `tags: [pricing, scope]`.
- `created` is the date the note was created. `updated` is the date of its latest edit: **bump `updated` on every edit**. Both are ISO dates and never empty.

### 2.4 Fact keys

- Dates are ISO `YYYY-MM-DD`. `week` is ISO `YYYY-Www` (`2026-W47`). `date`, `start` (weekly review), and `end` (weekly review) are never empty.
- `time` is `"HH:MM"` (24-hour, quoted). `duration` is a quoted string such as `"45m"` or `"1h30m"`.
- Dashboard `queries` lists the folders its Dataview blocks read (`[meetings, tasks]`). `requires` lists the plugins it needs (`[dataview]`).
- Allowed enum values:
  - meeting `status`: `processed`, `needs-review` (use `needs-review` while a metadata question is still open)
  - meeting and note `source`: `paste`, `audio`, `teams`, `zoom`, `meet`, `slack`, `teams-chat`, `email`, `file`, `record`, `other`
  - project `status`: `active`, `on-hold`, `done`, `cancelled`
  - decision `status`: `proposed`, `accepted`, `superseded`, `reversed`
- `source_lang` is the ISO 639-1 code of the original conversation (`en`, `pl`, `uk`, `de`, ...).

### 2.5 Reference keys

Reference keys are the links to related documents. Each relation has its own key, so an agent can follow the graph from front matter alone.

- Links are quoted wiki-links to the file name: `project: "[[Client-X-Migration]]"`, `participants: ["[[Anna_Kowalska]]", "[[John_Smith]]"]`. Single-valued keys hold one link or `""`. Plural keys hold a list or `[]`.
- `raw_input` is the vault-relative path of the raw source, quoted and not a wiki-link: `"inbox/_processed/2026-11-20_teams_client-x-kickoff.md"`.
- `related` holds links that no typed key covers (a related note, a similar earlier meeting, a sibling dashboard). Do not repeat a link that is already in a typed key.
- Every link must resolve (section 4).

| Key | On | Points to |
|-----|----|-----------|
| `participants` | meeting | person notes of everyone who took part |
| `project` | meeting, decision, note | the project note |
| `decisions` | meeting | decisions made in the meeting |
| `notes` | meeting | notes in `notes/` created from or about the meeting |
| `follow_up_of` | meeting | the earlier meeting this one continues |
| `projects` | person, tasks, weekly-review | projects the person works on; projects with tasks in the file; projects active in the week |
| `owner` | project | the person note of the project owner |
| `stakeholders` | project | person notes of the people involved, other than the owner |
| `meetings` | project, note | key meetings of the project (its Timeline stays the full log); meetings a note came from or belongs to |
| `decided_by` | decision | person notes of the people who decided |
| `source` | decision | the meeting the decision came from, or `""` |
| `supersedes` / `superseded_by` | decision | the decision this one replaces / the decision that replaced this one |
| `people` | note | person notes the note is about |
| `previous_review` | weekly-review | the previous weekly review, or `""` for the first one |

**Reciprocal pairs.** When you set one side, set the other side in the same change:

- meeting `decisions` and decision `source`
- meeting `notes` and note `meetings`
- project `owner` / `stakeholders` and person `projects` (except `[[Me]]`, whose `projects` stays `[]`)
- decision `supersedes` and decision `superseded_by`
- `related` on both notes

## 3. Body

- The first line after the front matter is a single H1 with the human-readable title, identical to `title`: `# Client X Kickoff`, `# Anna Kowalska`.
- The H1 is followed by a blank line and a **breadcrumb line**: relative Markdown links to the root README and every parent folder index from the root down, each joined by ` / `, ending with the note's title as plain text. Use the same link labels as the folder indexes (section 8):

  | Note | Breadcrumb |
  |------|------------|
  | `people/Anna_Kowalska.md` | `[Knowledge-Hub](../README.md) / [People](People.md) / Anna Kowalska` |
  | `meetings/2026/<file>.md` | `[Knowledge-Hub](../../README.md) / [Meetings](../Meetings.md) / [2026](2026.md) / Client X Kickoff` |
  | `decisions/<file>.md` | `[Knowledge-Hub](../README.md) / [Decisions](Decisions.md) / Pricing Model` |

  Every template already contains it. When a note moves (for example, a renamed folder), fix its breadcrumb in the same change.
- The H1 is followed by the type's sections, as `##` headings in this order. Keep every section; write `None.` under a section that has nothing in it. `tasks` and `dashboard` notes have a one-paragraph intro under the H1 instead of fixed sections: `tasks` then has one `## <Project or Area>` heading per group (`## General` when there is no project), and a `dashboard` has one `##` heading per query.

| Type | Sections |
|------|----------|
| `meeting` | Summary, Key Points, Decisions, Action Items, Open Questions, Source |
| `person` | About, Interactions, Open Tasks |
| `project` | Overview, Goals, Timeline, Decisions, Open Tasks |
| `decision` | Context, Options, Decision, Consequences, Source |
| `note` | Summary, Details, Related, Source |
| `weekly-review` | Meetings, Decisions, Completed Tasks, Open and Overdue Tasks, Follow-Ups, Notes |

- Timeline and Interactions entries are dated bullets, newest at the bottom: `- 2026-11-20 — [[2026.11.20T14.30.00-Client-X-Kickoff]]: agreed on the phase 1 scope.`
- Write in English. Translate content from other languages. Keep an original-language term in parentheses only when the exact wording matters (a product name, a legal term, a quoted commitment).
- No emojis anywhere in a business note.
- Record what was said, not what you infer. Anything uncertain goes under Open Questions as a question to confirm.

## 4. Links

- Link notes with Obsidian wiki-links to the file name: `[[Anna_Kowalska]]`, `[[Client-X-Migration]]`. Use `[[Anna_Kowalska|Anna]]` for different display text and `[[Client-X-Migration#Goals]]` for a section.
- Every wiki-link must resolve to an existing file in the vault. Create the missing person or project note (see [`update-entities`](../update-entities/SKILL.md)) rather than leaving a dangling link.
- Link to raw source files with a relative Markdown link, never a wiki-link: `[raw transcript](../../inbox/_processed/2026-11-20_audio_client-call.md)`.
- Link study notes with wiki-links or relative links as usual.

## 5. Tasks

A task line lives in exactly one place: under `## Action Items` in the meeting it came from, or in `tasks/Standalone_Tasks.md` when it did not come from a meeting. Tasks are never copied into a second file. Dashboards, person notes, and project notes show them through Dataview queries.

Task lines use the Dataview inline-field format, which the Obsidian Tasks plugin is configured to read:

```markdown
- [ ] Send the revised proposal [owner:: [[Anna_Kowalska]]] [project:: [[Client-X-Migration]]] [priority:: high] [due:: 2026-11-27]
- [x] Share the API spec [owner:: [[John_Smith]]] [due:: 2026-11-21] [completion:: 2026-11-21]
```

- The description comes first and starts with a verb.
- `[owner:: [[Person]]]` is required. Use the person note of whoever committed to the task. If the owner is unknown, add the task anyway with `[owner:: [[Me]]]` and list the question under Open Questions.
- `[project:: [[Project]]]` is optional in meeting notes, because the meeting's front matter already has it. It is required in `tasks/Standalone_Tasks.md` when the task belongs to a project.
- Optional Tasks fields go last, in this order: `[priority:: highest|high|medium|low|lowest]`, `[start:: YYYY-MM-DD]`, `[scheduled:: YYYY-MM-DD]`, `[due:: YYYY-MM-DD]`, `[completion:: YYYY-MM-DD]`.
- Add `due` only when a date or deadline was stated. Resolve relative dates ("next Friday") against the meeting date.
- To complete a task, change `[ ]` to `[x]` and append `[completion:: YYYY-MM-DD]` in place. To cancel it, use `[-]`.
- `[[Me]]` is the vault owner's own person note, `people/Me.md`.

## 6. Editing existing notes

- Append to Timeline, Interactions, and Notes sections. Do not rewrite earlier entries.
- Every edit sets `updated` to today's date.
- If an older note lacks a key from section 2, add it in the right position while you are editing the note.
- When the content changes what the note covers, update `summary` and `covers` so they still describe the whole note.
- When a fact changes (a new role, a new project status), update the front matter and add a dated entry that says what changed.
- When you link two notes through a reference key, set the reciprocal key on the other note in the same change (section 2.5), and bump its `updated` too.
- When a decision is replaced, set the old decision's `status` to `superseded` and its `superseded_by` to the new decision, and set `supersedes: "[[old decision]]"` on the new one.

## 7. Privacy

The vault holds real conversations and personal data. Do not paste vault content into external services other than the configured MCP tools. Audio files stay out of git (see `.gitignore`).

## 8. Folder indexes

The root [`README.md`](../../../README.md) is the vault's entry point, and every folder has an **index file** named after the folder. Together they form the backbone of the knowledge graph: root to folder, folder to subfolder, folder to note.

- **Index file name:** the folder name in Title Case, with `.md`. Acronyms keep their capitals, and a leading `_` or `.` is dropped. Examples: `people/People.md`, `meetings/Meetings.md`, `meetings/2026/2026.md`, `study/dotnet/DotNet.md`, `study/aws/AWS.md`, `inbox/_processed/Processed.md`, `.ai/AI.md`.
  - If that name is already taken somewhere else in the vault, prefix the parent folder's name, as in `.ai/templates/AI_Templates.md`. Index names must be unique across the vault, like note names.
  - The root `README.md` is the only file still called `README.md`.
- Breadcrumbs connect every file to this backbone. Each folder index has one under its H1. Each note has one too, ending with its own title (section 3). The root README is the only file without one.
- A folder index is not a note. It has no front matter, is never wiki-linked, and uses relative Markdown links only: `[Anna Kowalska](Anna_Kowalska.md)`, `[Meetings](../meetings/Meetings.md)`.
- Its shape:
  - an H1;
  - a breadcrumb line linking each parent index (`[Knowledge-Hub](../README.md) / People`);
  - one sentence on what the folder holds;
  - `## Notes` (or `## Years` / `## Folders` for subfolders);
  - an optional `## Related` list of sibling folder indexes.
- **When you create a note, add it to its folder index** under `## Notes` as `- [<H1 title>](<File_Name>.md) — <one line>`, replacing `None yet.` if it is there.
  - Keep people and projects sorted by title.
  - Meetings, decisions, notes, and weekly reviews sort by file name, oldest first. The timestamp prefix makes that order chronological.
  - Meetings go in the year index (`meetings/<YYYY>/<YYYY>.md`).
- When a new folder appears (a new meeting year), create its index file and link it from the parent folder's index.
- When you rename or delete a note, update its entry in the folder index.
