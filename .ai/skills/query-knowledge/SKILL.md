---
name: query-knowledge
description: Answer questions from the vault — what was agreed with a person, the state of a project, why a decision was made, who owns a task, what happened in a period — by searching front matter and note text and citing every note used. Never invents facts. Use when the user asks anything about past conversations, people, clients, projects, decisions, or tasks.
---

# Query the Knowledge Base

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Query the Knowledge Base

Answer from the vault only. Note types, fields, and folders are described in [`vault-conventions`](../vault-conventions/SKILL.md).

## Steps

1. **Pin down the question.** Find the people, projects, topics, and time range it is about. Resolve names through file names, H1s, and `aliases` in `people/` and `projects/`, as [`update-entities`](../update-entities/SKILL.md) does.

2. **Search the metadata first.** Every note's front matter has a `summary`, a `covers` list, and reference keys to its related notes (`vault-conventions` section 2). Use `summary` and `covers` to decide which notes to open. Then follow the reference keys (`decisions`, `source`, `meetings`, `projects`, `stakeholders`, `supersedes`, `superseded_by`, `related`) to related notes without reading bodies:

   ```powershell
   rg -n '^(summary|covers): .*pricing' meetings decisions notes projects people journal study
   rg -l 'project: "\[\[Client-X-Migration\]\]"' meetings decisions notes
   rg -l 'Anna_Kowalska' meetings decisions
   rg -n '\[owner:: \[\[Anna_Kowalska\]\]\]' meetings tasks
   rg -n '^date: 2026-11-' meetings decisions
   rg -n '^status: (proposed|accepted)' decisions
   rg -n '^superseded_by: "\[\[' decisions
   ```

3. **Read the hub notes.** A person's Interactions, or a project's Timeline, is the index of every related meeting. Read it before reading the meetings themselves.

4. **Search the text.** Use `rg -i` across `meetings/`, `decisions/`, `notes/`, `people/`, `projects/`, and `journal/` for topic words and their synonyms. If nothing is found, also search `inbox/_processed/`: it holds the raw sources, including details that the summaries left out.

5. **Weigh what you found.**
   - Prefer the most recent source when facts conflict, and mention the change ("the go-live moved from 15 December to 15 January on 2026-11-20").
   - For decisions, report the current one. Mention a `superseded` or `reversed` decision only to explain the history.
   - Separate decisions and commitments from opinions and proposals.

6. **Answer with citations.** Lead with the direct answer. Then give the supporting points, each citing its note as a wiki-link with the date: `([[2026.11.20T14.30.00-Client-X-Kickoff]], 2026-11-20)`. Quote the note's wording when the exact words matter.

7. **Say what is missing.** If the vault does not contain the answer, say so plainly and say what you searched. Do not fill the gap with general knowledge or guesses. Point out related open questions or open tasks if there are any.

## Rules

- Read-only by default. Change notes only if the user asks, for example "mark that done" or "save this as a note".
- If the user asks to save an answer, write it as a new note in the matching folder, created from its template with complete front matter, following `vault-conventions`.
- For "what's open" or "what's overdue" questions, collect task lines from `meetings/` and `tasks/`, the same set the dashboards in `dashboards/` show.

## Done when

- The answer is supported by the cited notes, and every claim can be traced to one of them.
- Gaps and conflicts are stated, not hidden.
