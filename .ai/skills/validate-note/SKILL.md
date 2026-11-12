---
name: validate-note
description: Audit a Knowledge-Hub note against the md-note-structure rules and fix what fails — Content completeness and order, resolving anchors, back-links to Content, separators, subsection IDs, and README registration. Use after creating or editing any note, or when asked to check, lint, or fix a note's structure.
---

# Validate a Note

Run this after every note edit. The rules are defined in [`md-note-structure`](../md-note-structure/SKILL.md); this skill is the checklist for applying them.

## Checklist

Work through each item and fix the note in place. Headings inside fenced code blocks are not headings and are ignored.

1. **Title.** Line 1 is the only H1 (`# <Topic>`), except `# Part ...` dividers in multi-part guides. An intro paragraph follows.
2. **Content exists.** There is a `## Content` heading after the intro, with a `---` line before and after.
3. **Content is complete.** Every `##` and `###` heading after `## Content` appears as an entry, numbered for `##` and nested bullets for `###`.
4. **Content has no stale entries.** Every entry points to a heading that still exists.
5. **Content is in order.** Entries follow document order.
6. **Anchors resolve.** Each `(#anchor)` equals the GitHub slug of its target heading (rule 7 in `md-note-structure`). Watch for en/em dashes, dots in IDs (`1.1` becomes `11`), and duplicate headings (`-1` suffix).
7. **Back-links.** Each `##` and `###` section after Content has `[↑ Content](#content)` as the first non-blank line under its heading. The only exception is a `##` whose first non-blank line is a `###` heading (a grouping section).
8. **Separators.** A `---` line sits between top-level sections and between consecutive `###` subsections. The file ends with `---` and an optional italic closing line.
9. **Subsection IDs.** Within each section, IDs use one prefix and number from 1 without gaps (`J1.` ... `J10.`).
10. **No emojis** inside the note.
11. **Registered.** The root `README.md` catalog contains `](<folder>/<File>.md)` for this note.

## Automated helper

[`check-note.ps1`](check-note.ps1) automates items 1–7 and 11. It is read-only and only reports findings. It runs under Windows PowerShell 5.1 or PowerShell 7 (`pwsh`) on any OS:

```powershell
# one note
pwsh .ai/skills/validate-note/check-note.ps1 dotnet/EF_Core_Interview_Cheat_Sheet.md

# every tracked note
pwsh .ai/skills/validate-note/check-note.ps1

# Windows PowerShell 5.1 without pwsh
powershell -NoProfile -ExecutionPolicy Bypass -File .ai/skills/validate-note/check-note.ps1 dotnet/EF_Core_Interview_Cheat_Sheet.md
```

Each file prints `PASS` or `FAIL` with line-numbered findings. The exit code is `1` if any file fails. If PowerShell is unavailable, apply the checklist by reading the file; the rules do not depend on the script.

Items 8–10 still need a manual read.

## Fixing

- Prefer fixing the heading text over the anchor when a dash or symbol makes the slug unpredictable. For example, change `0–2` to `0-2` in the heading and the link.
- When a section is missing from Content, add it at the matching position instead of appending it at the end.
- Re-run the checklist after fixing, until it passes.
