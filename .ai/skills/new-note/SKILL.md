---
name: new-note
description: Create a new Knowledge-Hub note from the shared template and register it in the root README catalog. Use when asked to add, write, or start a new cheat sheet, study guide, or reference note.
---

# Create a New Note

Read [`md-note-structure`](../md-note-structure/SKILL.md) first. It defines every rule this workflow applies.

## Steps

1. **Pick the folder.** Use the existing topic folder that fits (`dotnet/`, `databases/`, `algorithms/`, `aws/`). If none fits, create a new lowercase folder and plan a matching README group (step 5).

2. **Name the file.** Use `Title_Case_With_Underscores.md`. For interview notes, end it in `_Cheat_Sheet.md`. Check that no existing note already covers the topic. If one does, extend it instead.

3. **Copy the template.** Start from [`.ai/templates/note-template.md`](../../templates/note-template.md) and fill in:
   - the H1 title and the intro paragraph;
   - optional `>` notes (version, prerequisite, currency);
   - `## How to Use This Guide`;
   - topic sections with prefixed subsection IDs (`A1.`, `A2.`, ...; pick a meaningful prefix per section);
   - the standard closing sections that apply (Rapid Answers, Quick Interview Checklist, Glossary);
   - the italic closing summary line.

   Delete any template placeholder section you do not use.

4. **Build `## Content` from the real headings.** Once the body is written, list every `##` section (numbered) and its `###` subsections (nested bullets) in document order. Compute each anchor with the slug rules in `md-note-structure`, rule 7. Never write Content first and leave it stale.

5. **Register the note in [`README.md`](../../../README.md).**
   - Under `## 📖 Catalog`, find the `### <emoji> <folder>/` heading for the folder and add:

     ```markdown
     - [File_Name.md](folder/File_Name.md) — one-line description of scope
     ```

   - For a new folder, also add a bullet to `## 🗂️ How this hub is organized` (`- <emoji> **folder** — short description`) and a new `### <emoji> folder/` catalog group, keeping the README's existing emoji style.

6. **Validate.** Run the [`validate-note`](../validate-note/SKILL.md) checklist on the new file and fix everything it reports before finishing.

## Done when

- The file sits in the right folder with a conforming name.
- `validate-note` passes with no findings.
- The README catalog links to the file, and the link resolves.
