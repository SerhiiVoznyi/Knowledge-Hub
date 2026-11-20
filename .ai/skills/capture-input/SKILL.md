---
name: capture-input
description: Add information to the vault from pasted text, a file, a chat or email thread, or a data record — work out what the user wants kept, split the content into meeting, decision, task, person, project, and standalone notes, write each one in its folder with the timestamp file name, and link them together. Use whenever the user asks to add, save, record, capture, file, or ingest information, or to process the inbox.
---

# Capture Input

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Capture Input

Turn any input into linked notes. Front matter, file names, sections, links, and folder indexes are defined in [`vault-conventions`](../vault-conventions/SKILL.md). Read that skill first.

**Prerequisite:** `people/Me.md` must be complete, because its name and `aliases` are how you recognize the vault owner in transcripts. If it is missing or incomplete, run [`setup-owner`](../setup-owner/SKILL.md) first.

## Inputs

| Input | How to read it |
|-------|----------------|
| Pasted text | Read it from the chat. |
| File in `inbox/` or a path the user gives | Read `.md`, `.txt`, `.vtt`, `.docx`, `.pdf`, `.eml`, `.csv`, or `.json` directly. For `.vtt`, drop the cue numbers and timings and keep `Speaker: text`. |
| Chat, email, or calendar item | Fetch it through a configured MCP server (see [`.ai/mcp/MCP.md`](../../mcp/MCP.md)). If none is configured, ask the user to paste or export it. |
| Data record (a row, a log entry, a form, a JSON object) | Read every field. Keep field names and values exactly as given. |
| Audio or video | There is no transcription tool in the repo. Ask the user for a transcript or an exported text file. |

## Steps

1. **Save the raw input.** Write it unchanged to `inbox/_processed/YYYY-MM-DD_<source>_<slug>.md`, where `<source>` is the meeting `source` value from `vault-conventions` and `<slug>` is two to four lowercase words. If the input was already a file in `inbox/`, move it there instead. Every note you write links to this file under `## Source`.

2. **Understand the intent.** Work out what the user wants kept and why: "add this", "remember that Anna moved to Sales", "file this call". Then classify every piece of the content:

   | Content | Goes to | Skill that applies |
   |---------|---------|--------------------|
   | A conversation: meeting, call, chat, or email thread with an outcome | New meeting note in `meetings/<YYYY>/` | this skill (step 4) |
   | A choice that was agreed | New decision note in `decisions/` | [`log-decision`](../log-decision/SKILL.md) |
   | A commitment by a person | Task line under the meeting's Action Items, or in `tasks/Standalone_Tasks.md` when there is no meeting | [`extract-tasks`](../extract-tasks/SKILL.md) |
   | A fact about a person or project: role, contact, status, preference, constraint | Update of the person or project note | [`update-entities`](../update-entities/SKILL.md) |
   | Standalone information: a reference fact, idea, research finding, how-to, or record that is not a conversation | New note in `notes/` | this skill (step 4) |
   | Study material for interviews or learning | New study note | [`new-note`](../new-note/SKILL.md) |

   If the intent is unclear (for example, whether a pasted thread is a decision or still a proposal), ask before writing.

3. **Plan the split.** One input can produce several files. Before writing anything, list every file to create and every file to change, with its folder and file name. Search first, and extend an existing note instead of creating a duplicate:
   - people and projects by file name, H1, `aliases`, `email`, and `client`;
   - meetings and decisions by date, project, and participants;
   - notes in `notes/` by title, tags, and topic words (`rg -i`).

4. **Write the notes.** Create each new note by copying its template from [`.ai/templates/`](../../templates/). Never write a note from scratch. Name it with the timestamp format and timestamp source rules in `vault-conventions` section 1. Replace every placeholder and Templater expression.
   - **Fill in the whole front matter** (`vault-conventions` section 2): `title` equal to the H1, a one-sentence `summary`, `covers` listing the topics and data in the note, every fact key, every reference key, and `created` and `updated` set to today. Keep every key, in the template's order. Leave a value empty (`""` or `[]`) only when the fact is unknown.
   - Set `raw_input` on meetings and notes to the path of the raw input saved in step 1.
   - **Meeting:** fill in Summary, Key Points, Decisions, Action Items, Open Questions, and Source. Set `status: needs-review` while a metadata question is still open, otherwise `processed`.
   - **Note:** fill in Summary (two or three sentences), Details (the information itself, structured with bullets or a table; keep records field by field), Related, and Source.
   - Translate other languages into English and set `source_lang` on meetings.

5. **Link everything.** Every file produced from one input links to the others it relates to, both in the front-matter reference keys and in the body:
   - the meeting's `decisions` lists its decisions, and each decision's `source` is the meeting;
   - the meeting's `notes` lists the notes, and each note's `meetings` lists the meeting; notes also set `project` and `people`, and list them under `## Related`;
   - a meeting that continues an earlier one sets `follow_up_of`;
   - set the reciprocal side of every pair in `vault-conventions` section 2.5, and bump `updated` on every existing note you touch.

   Add a dated Interactions or Timeline entry to each person and project involved, as `update-entities` describes. Every wiki-link must resolve.

6. **Update the folder indexes.** Add every new note to its folder index file (`people/People.md`, `meetings/<YYYY>/<YYYY>.md`, ...), as `vault-conventions` section 8 describes. For the first meeting of a new year, create `meetings/<YYYY>/<YYYY>.md` and link it from `meetings/Meetings.md`.

7. **Report.** Tell the user, file by file, what you created or changed, with one line each. List anything you could not resolve (an unknown owner, an ambiguous name, a missing date) and ask about it. The same questions go under the meeting's Open Questions.

## Rules

- Record what the input says. Do not infer facts, dates, owners, or numbers that are not in it.
- Each piece of information has exactly one home. Link to it from other notes instead of copying it.
- Do not change dashboards or Dataview query blocks.

## Done when

- Every piece of the input is in exactly one note, task line, or entity update, and the raw input is in `inbox/_processed/`.
- New meetings, decisions, and notes use the timestamp file name, were created from their templates, and follow `vault-conventions`.
- Every new note has every front-matter key for its type, with `summary`, `covers`, `created`, and `updated` filled in, and every reference key has its reciprocal on the linked note.
- Every wiki-link and relative link resolves, and every new note is listed in its folder index file.
- The user has a file-by-file report and every open question.
