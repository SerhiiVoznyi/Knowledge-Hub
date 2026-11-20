---
name: log-decision
description: Record a business decision as a note in decisions/ with its context, the options considered, the decision, its consequences, and its source, and link it from the meeting and project. Handles superseding earlier decisions. Use when filing a conversation, or when the user asks to log, record, revisit, or reverse a decision.
---

# Log a Decision

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Log a Decision

Front matter and section rules are in [`vault-conventions`](../vault-conventions/SKILL.md). Read that skill first.

## What counts as a decision

A decision is a choice that the people who had the authority to make it agreed on: "We go with fixed-price for phase 1", "Release moves to 15 January", "We drop the mobile app from scope". Do not log the following as decisions:

- proposals still under discussion, which go under the meeting's Key Points;
- personal opinions;
- tasks, which are handled by [`extract-tasks`](../extract-tasks/SKILL.md).

If it is unclear whether something was agreed, log it with `status: proposed` and add a question to the meeting's Open Questions.

## Steps

1. **Check for an earlier decision on the same question.** Search `decisions/` by project and topic. If this decision replaces one, follow "Superseding" below.
2. **Create the note.** Always copy [`.ai/templates/decision.md`](../../templates/decision.md), never write it from scratch. Copy it to `decisions/YYYY.MM.DDTHH.MM.SS-Short-Title.md`, using the meeting's timestamp (see the timestamp rules in `vault-conventions`). The short title names the subject, not the outcome: `Pricing-Model`, not `Fixed-Price-Chosen`.
3. **Fill in the front matter.** Keep every key from the template. Set `title` (equal to the H1), `summary` (the decision in one sentence), `covers` (the subjects it settles), `date`, `status`, `project`, `decided_by` (a list of person links), `source` (the meeting link), `supersedes` and `superseded_by` (or `""`), `related` (other decisions on the same subject), and `created` and `updated` (today).
4. **Write the sections:**
   - **Context.** What needed deciding, and the constraints at the time.
   - **Options.** The alternatives that were discussed, each with its main argument. If none were discussed, write `None discussed.`
   - **Decision.** One or two sentences, worded as agreed.
   - **Consequences.** Work created or removed, risks accepted, and what is now ruled out.
   - **Source.** The meeting link, plus any other source.
5. **Link it.** Add the decision to the meeting's `decisions` front-matter key, and add a bullet under the meeting's `## Decisions`: `- [[2026.11.20T14.30.00-Pricing-Model]] — fixed price for phase 1.` Bump the meeting's `updated`. The project's Decisions section picks it up automatically through Dataview. Also add a Timeline entry on the project.

## Superseding

When a new decision replaces an older one:

- In the old note, set `status: superseded`, set `superseded_by: "[[YYYY.MM.DDTHH.MM.SS-New-Title]]"`, bump `updated`, and append to its Consequences: `Superseded by [[YYYY.MM.DDTHH.MM.SS-New-Title]] on YYYY-MM-DD.`
- In the new note, set `supersedes: "[[YYYY.MM.DDTHH.MM.SS-Old-Title]]"` and explain in Context what changed.
- A decision that is undone without a replacement gets `status: reversed`, a bumped `updated`, and a dated line in Consequences.

## Done when

- The decision note exists, was created from the template, has every front-matter key, and follows `vault-conventions`.
- The meeting's `decisions` key and `## Decisions` section link to it, and its `source` links back to the meeting.
- Any decision it replaces is marked `superseded`, and `supersedes` and `superseded_by` point at each other.
