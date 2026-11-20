---
name: update-entities
description: Create or update person and project notes in people/ and projects/ — resolve names and aliases, add a dated Interactions or Timeline entry that links the source note, and record changed facts such as role, company, or project status. Use when filing a conversation, or when the user asks to add or update a person, contact, client, or project.
---

# Update People and Projects

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Update People and Projects

Front matter, body sections, and file naming rules are in [`vault-conventions`](../vault-conventions/SKILL.md). Read that skill first.

## Resolving an entity

Before creating a note, look for an existing one:

1. Search file names in `people/` or `projects/`.
2. Search the H1 titles and `aliases` front-matter lists.
3. For people, also search `email` values. For projects, also search `client` values.

Treat partial names, nicknames, and spellings in other languages as the same person when the context agrees (same company, same role, same project). When two candidates are equally likely, ask the user instead of guessing. When you match someone under a new name, add that name to `aliases`.

## Creating a note

Always copy the template; never write a person or project note from scratch. Keep every front-matter key from the template, and set `created` and `updated` to today.

- **Person.** Copy [`.ai/templates/person.md`](../../templates/person.md) to `people/First_Last.md`. Fill in `company`, `role`, `email`, `phone`, and `timezone` only from the source or the calendar, and leave the rest empty. Put the full name, with its real spelling, in the H1 and in `title`. Add short forms and the original-script spelling to `aliases`. Write a one-sentence `summary` (who they are, in relation to the vault owner's work), set `covers` to what the note holds (`[role, contact details, preferences]`), and list their projects in `projects`.
- **Project.** Copy [`.ai/templates/project.md`](../../templates/project.md) to `projects/Project-Name.md`. Fill in `client`, `start` (the date of the first conversation that mentions it), `owner`, `stakeholders`, a one-sentence `summary`, `covers`, and the Overview and Goals that were stated. Add the project to the `projects` key of its owner and every stakeholder (except `[[Me]]`).
- If only a first name is known, use it alone (`people/Anna.md`), and rename the file once the surname is known. Renaming means updating every wiki-link to the old name, and the note's `title`, H1, and breadcrumb.

## Updating a note

For every conversation that involves the entity:

- **Person:** append to `## Interactions`:

  ```markdown
  - 2026-11-20 — [[2026.11.20T14.30.00-Client-X-Kickoff]]: presented the phase 1 scope; concerned about the go-live date.
  ```

- **Project:** append to `## Timeline` in the same format, describing what moved forward or changed.
- **Changed facts:** when the source states a new role, company, email, or project status, update the front matter and say so in the entry ("now Head of IT", "project paused until January").
- **Metadata:** on every update, set `updated` to today. Add a new project to the person's `projects`, and a new person to the project's `stakeholders`, on both sides. Add a meeting to the project's `meetings` when it changed the project's scope, plan, or status (the Timeline still gets every meeting). Extend `covers` and rewrite `summary` when they no longer describe the note.
- **About and Overview:** add durable facts, such as preferences, responsibilities, constraints, or stakeholders. Do not add one-off meeting details here.

Do not touch `## Open Tasks` or the project `## Decisions` section. They are Dataview queries.

## The vault owner

`people/Me.md` is the vault owner. It is created and maintained by [`setup-owner`](../setup-owner/SKILL.md); never create it from a conversation. Do not add Interactions entries to it, and keep its `projects` empty. It exists so that task owners and decision makers can link to `[[Me]]`.

## Done when

- Every person and project mentioned in the source has exactly one note, and every link to it resolves.
- Each one has an entry for this conversation.
- Every note that was created or changed follows `vault-conventions`, has every front-matter key for its type, and has `updated` set to today.
- `projects`, `owner`, and `stakeholders` agree on both sides.
