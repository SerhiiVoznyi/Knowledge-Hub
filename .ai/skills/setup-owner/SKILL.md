---
name: setup-owner
description: Create or complete people/Me.md, the vault owner's profile, by interviewing the user for every missing required field (name, transcript names, email, company, role, timezone) and writing it from the person template. Use when the user says "set up my profile" or runs /setup-me, and before any business-note request when people/Me.md is missing or incomplete.
---

# Set Up the Vault Owner

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Set Up the Vault Owner

`people/Me.md` tells every other skill who the vault owner is: [`capture-input`](../capture-input/SKILL.md) uses it to recognize the owner in transcripts, and tasks, decisions, and projects link to `[[Me]]`. Front matter and link rules are in [`vault-conventions`](../vault-conventions/SKILL.md). Read that skill first.

## Complete profile

`people/Me.md` is complete when it exists and each of these front-matter keys is non-empty and not a template placeholder (`<...>`, `<% ... %>`, or `Me`):

| Key | Holds |
|-----|-------|
| `title` | Full name, with its real spelling |
| `aliases` | Every other form of the name: short forms, initials, other scripts, transcript display names, email handles |
| `company` | Current employer or own business |
| `role` | Job title or role |
| `email` | Work email (extra addresses go in `aliases`) |
| `timezone` | IANA name, for example `Europe/Warsaw` |

If any is missing, the profile is incomplete. [`AGENTS.md`](../../../AGENTS.md) requires running this skill before any other business-note work in that case.

## Steps

1. **Audit.** If `people/Me.md` exists, read it and list the required keys that are missing or placeholders. Never ask again for a value that is already there.

2. **Prepare suggestions.** `git config user.name` and `git config user.email` may hint at the name and email. Offer them as suggestions only. Nothing is saved until the user confirms it.

3. **Interview.** Ask in at most two short rounds. Use structured questions when the tool supports them, otherwise one numbered message per round.
   - **Round 1, required** (only the missing keys):
     1. Full name, with its native spelling.
     2. How the name appears in Teams, Zoom, Meet, or Slack transcripts and in email (for example `Anna K.`, `AK`, `Анна Ковальська`).
     3. Work email, plus any other addresses used for work.
     4. Company.
     5. Role.
     6. Timezone.
   - **Round 2, optional** (say the user can skip): phone, team and manager, languages used in meetings, preferred language for notes, working hours, main responsibilities.

   If the user refuses a required field, write the profile anyway and list that field under `## Open Questions` at the end of the note. The profile then stays incomplete, so tell the user what is missing.

4. **Write the note from the template.** If `people/Me.md` does not exist, copy [`.ai/templates/person.md`](../../templates/person.md) to `people/Me.md`. Keep every front-matter key in the template's order:
   - `type: person`; `title` is the full name.
   - `summary: "Vault owner: <role> at <company>."`
   - `covers: [identity, transcript names, contact details, working preferences]`
   - `company`, `role`, `email`, `phone`, and `timezone` from the answers; `aliases` as a list of every name form from question 2 and extra email addresses.
   - `projects: []` and `related: []`. The owner's `projects` always stays empty (see [`update-entities`](../update-entities/SKILL.md)).
   - `tags: [owner]`; `created` set to today for a new note; `updated` set to today.
   - The H1 is the full name, and the breadcrumb is `[Knowledge-Hub](../README.md) / [People](People.md) / <Full Name>`. The file name stays `Me.md`, so every `[[Me]]` link keeps working.
   - `## About`: the optional answers, one bullet each, worded as the user stated them. Never add facts the user did not give.
   - `## Interactions`: leave empty. Keep the `## Open Tasks` query unchanged.

   When updating an existing note, keep its values unless the user changes them.

5. **Check privacy.** Run `git check-ignore people/Me.md`. It must print the path, which means the file is ignored. Never stage it, and never use `git add -f`. If it is not ignored, stop and tell the user, because `.gitignore` is broken.

6. **Report.** List the saved fields, any skipped optional ones, and any required field that is still missing. If the user's original request was waiting on this setup, continue with it now.

## Done when

- `people/Me.md` exists, was created from the template, and has every required key filled in (or the missing ones are listed under Open Questions and reported).
- No fact in it was guessed. Every value came from the user or was confirmed by the user.
- `git check-ignore people/Me.md` reports the file as ignored.
