---
name: new-note
description: Create a new study note under study/ from the shared template and register it in its topic folder index file. Use when asked to add, write, or start a new cheat sheet, study guide, or reference note. For meetings, people, projects, decisions, or tasks use update-entities, log-decision, or extract-tasks instead.
---

# Create a New Study Note

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Create a New Study Note

Read [`md-note-structure`](../md-note-structure/SKILL.md) first. It defines every rule this workflow applies.

## Steps

1. **Pick the folder.** Use the existing topic folder under `study/` that fits (`study/dotnet/`, `study/databases/`, `study/algorithms/`, `study/aws/`). If none fits, create a new lowercase folder under `study/` with its own index file (step 5).

2. **Name the file.** Use `Title_Case_With_Underscores.md`. For interview notes, end it in `_Cheat_Sheet.md`. Check that no existing note already covers the topic. If one does, extend it instead.

3. **Copy the template.** Always start from [`.ai/templates/study-note.md`](../../templates/study-note.md). Never write a study note from scratch. Fill in:
   - the front matter, keeping every key (`md-note-structure`, rule 1): `title` equal to the H1, a one-sentence `summary`, `covers` with the main topics, `topic`, `level`, `version`, `related` (related study notes, and add this note to their `related` too), `tags`, and `created` and `updated` set to today. Fill `covers` last, from the real sections;
   - the H1 title and the intro paragraph;
   - optional `>` notes (version, prerequisite, currency);
   - `## How to Use This Guide`;
   - topic sections with prefixed subsection IDs (`A1.`, `A2.`, ...; pick a meaningful prefix per section);
   - the standard closing sections that apply (Rapid Answers, Quick Interview Checklist, Glossary);
   - the italic closing summary line.

   Delete any template placeholder section you do not use.

4. **Build `## Content` from the real headings.** Once the body is written, list every `##` section (numbered) and its `###` subsections (nested bullets) in document order. Compute each anchor with the slug rules in `md-note-structure`, rule 7. Never write Content first and leave it stale.

5. **Register the note in its topic index file** (`study/<folder>/<Folder>.md`, for example `study/dotnet/DotNet.md`).
   - Under `## Notes`, add:

     ```markdown
     - [File_Name.md](File_Name.md) — one-line description of scope
     ```

   - For a new folder, create its index file `study/<folder>/<Folder>.md` (Title Case folder name, see `vault-conventions` section 8) in the same shape as the existing topic indexes (H1, breadcrumb, `## Notes`), then link it from the `## Topics` list in [`study/Study.md`](../../../study/Study.md) and from the study line of the root [`README.md`](../../../README.md) vault map.

## Done when

- The file sits in the right folder under `study/` with a conforming name.
- The file was created from the template, has every front-matter key, and follows [`md-note-structure`](../md-note-structure/SKILL.md).
- The topic index file links to the file, the topic is reachable from the root README, and every link resolves.
