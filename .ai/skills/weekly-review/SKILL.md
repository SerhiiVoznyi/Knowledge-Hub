---
name: weekly-review
description: Write the weekly review note in journal/ for an ISO week — meetings held, decisions made, tasks completed, open and overdue tasks, follow-ups, and notes. Use when the user asks for a weekly review, a week summary, or "what happened this week", or at the end of a week.
---

# Weekly Review

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Weekly Review

Front matter, file name, and section rules are in [`vault-conventions`](../vault-conventions/SKILL.md). Read that skill first.

## Steps

1. **Pick the week.** Default to the current ISO week, Monday to Sunday. On a Monday before noon, ask whether the user means the previous week. Compute `week` (`2026-W47`), `start`, and `end`.

2. **Collect the material.**
   - **Meetings:** notes in `meetings/` whose `date` is between `start` and `end`.
   - **Decisions:** notes in `decisions/` whose `date` is in the range, plus decisions whose status changed during the week. Look for a dated Consequences line.
   - **Completed tasks:** task lines in `meetings/` and `tasks/` with `[completion::]` in the range.
   - **Open and overdue tasks:** open task lines (`- [ ]`) with `due` on or before `end`, plus open high-priority tasks. Tag a task as overdue when its `due` is before the review date.
   - **Follow-ups:** open tasks owned by someone other than `[[Me]]`, which you are waiting on; Open Questions from the week's meetings; and meetings that still have `status: needs-review`.

   Useful searches:

   ```powershell
   rg -l '^date: 2026-11-(1[6-9]|2[0-2])' meetings decisions
   rg -n '\[completion:: 2026-11-(1[6-9]|2[0-2])\]' meetings tasks
   rg -n '^\s*- \[ \] ' meetings tasks
   ```

3. **Write the note.** Always copy [`.ai/templates/weekly-review.md`](../../templates/weekly-review.md), never write it from scratch. Copy it to `journal/YYYY.MM.DDTHH.MM.SS-Weekly-Review-YYYY-Www.md`, timestamped with the time of writing.
   - **Front matter:** keep every key. Set `title` (equal to the H1), `summary` (the week's main outcome in one sentence), `covers` (the week's main subjects), `week`, `start`, `end`, `previous_review` (the latest earlier review in `journal/`, or `""`), `projects` (projects with meetings, decisions, or task activity in the week), and `created` and `updated` (today).
   - **Sections:** fill in every one:
     - Write each item as a plain bullet with a wiki-link to its source note. **Do not use `- [ ]` checkboxes**: tasks live only in their source note.
     - Under **Notes**, give two to four observations: recurring blockers, projects that are slipping, relationships that need attention. Base them only on the collected material.
     - Write `None.` under any section that has nothing in it.

4. **Do not change the sources.** The review only reads. If you notice a task that looks done or a stale project status, list it under Follow-Ups as something to confirm.

## Done when

- `journal/YYYY.MM.DDTHH.MM.SS-Weekly-Review-YYYY-Www.md` exists, was created from the template, has every front-matter key, follows `vault-conventions`, is listed in `journal/Journal.md`, and every item links to its source.
- You have told the user the three to five things that need their attention most.
