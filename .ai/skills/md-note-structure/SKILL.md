---
name: md-note-structure
description: Structure rules for every Markdown note in Knowledge-Hub — title, intro, Content table of contents, section separators, back-links to Content, subsection IDs, and anchor slugs. Use before creating or editing any note under a topic folder (dotnet/, databases/, algorithms/, aws/, ...).
---

# Markdown Note Structure

Every note in this repository follows one shape so readers can jump from the table of contents to any section and back in one click. The copy-paste skeleton is [`.ai/templates/note-template.md`](../../templates/note-template.md).

## Skeleton

```markdown
# <Topic>

<One-paragraph intro.>

> <Optional note.>

---

## Content

1. [How to Use This Guide](#how-to-use-this-guide)
2. [<Section>](#section)
   - [<A1. Subsection>](#a1-subsection)

---

## How to Use This Guide

[↑ Content](#content)

...

---

## <Section>

### A1. <Subsection>

[↑ Content](#content)

...

---

*<Closing summary.>*
```

## Rules

### 1. Title and intro

- The first line is a single H1: `# <Topic>`. It is the only H1 except for part dividers (rule 6).
- A short intro paragraph follows, saying what the note covers and for whom.
- Optional `>` blockquotes come after the intro for version, currency, prerequisite, or dialect notes. Use one blockquote per concern, starting with a bold or plain label such as `> Version note:` or `> **Prerequisite:**`.

### 2. Content section

- `## Content` comes right after the intro block, with a `---` line before and after it.
- It is a numbered list (`1.`, `2.`, ...) of every `##` section, in document order.
- `###` subsections are nested `-` bullets under their parent, indented three spaces (four when the parent number has two digits, e.g. `10.`).
- Every entry is a link `[Visible Title](#anchor)`, and the anchor must resolve (rule 7).
- The link text may drop the subsection ID prefix (`[Linear Search](#11-linear-search)`), but it must stay recognizable.
- `####` and deeper headings are not listed.

### 3. Back-link to Content

- Every section that a Content entry points to carries exactly this line:

  ```markdown
  [↑ Content](#content)
  ```

- It sits on its own line directly under the heading, with one blank line before and after.
- Grouping sections: when a `##` heading is followed immediately by a `###` (no body text of its own), the `##` gets no back-link and each `###` under it gets one instead. Any `##` with its own body text gets the back-link.
- The `## Content` heading itself and the H1 never get a back-link.

### 4. Separators

- A `---` line (blank line on both sides) goes between every top-level `##` section and between consecutive `###` subsections.
- The note ends with `---` and then an optional italic one-line closing summary: `*...*`.

### 5. Subsection IDs

- Subsections in study or Q&A sections carry a short ID: `### <PREFIX><N>. <Title>`.
- One prefix per `##` section, derived from its name and used consistently: `P` platform, `R` runtime, `KC` key concepts, `J` / `M` / `S` for junior / mid / senior questions, and so on. Numbered parts may use `1.1`, `1.2` instead.
- Numbering starts at 1 in each section and has no gaps.
- Plain reference subsections (for example `### Reading the Abbreviations`) may omit the ID.

### 6. Long, multi-part guides

- A guide with several large parts may use H1 part dividers: `# Part I — Foundations`.
- In `## Content` each part becomes a bold link line above its sections, and section numbering continues across parts:

  ```markdown
  **[Part I — Foundations](#part-i--foundations)**

  1. [How to Use This Guide](#how-to-use-this-guide)

  **[Part II — The Services in Depth](#part-ii--the-services-in-depth)**

  2. [Chapter 1: Identity](#chapter-1-identity)
  ```

- Part dividers get no back-link. The sections inside them follow rules 3 and 4.

### 7. Anchor slugs

Anchors follow GitHub's heading-slug algorithm:

1. Lowercase the heading text.
2. Remove every character that is not a letter, digit, space, `-`, or `_`. This removes `.`, `,`, `:`, `(`, `)`, `/`, `#`, `+`, `?`, `&`, `—`, `–`, and backticks.
3. Replace each space with `-`. Runs of hyphens are not collapsed.
4. If the same slug occurs more than once in a file, later occurrences get `-1`, `-2`, ... appended.

| Heading | Anchor |
|---------|--------|
| `## How to Use This Guide` | `#how-to-use-this-guide` |
| `### P1. .NET 10 at a Glance` | `#p1-net-10-at-a-glance` |
| `## C# 14 Language Features` | `#c-14-language-features` |
| `### 2.3 Merge Sort (Must Know)` | `#23-merge-sort-must-know` |
| `# Part I — Foundations` | `#part-i--foundations` |
| `## Junior (0-2 Years)` | `#junior-0-2-years` |
| `## Junior (0–2 Years)` (en dash) | `#junior-02-years` |

Use ASCII `-` instead of `–` or `—` inside headings that other sections link to, so slugs stay predictable. Use `—` only in part dividers, where the double hyphen in the slug is expected.

### 8. Body conventions

- Use bold run-in labels for recurring sub-blocks inside a section, such as `**Deeper understanding**`, rather than extra heading levels.
- Use tables for short, enumerable facts, and fenced code blocks with a language tag for code.
- Cross-link other notes with relative paths: `[Associate guide](AWS_Solutions_Architect_Associate_SAA-C03_Cheat_Sheet.md)`.
- No emojis inside notes. Emojis are used only in the root `README.md`.

### 9. Recommended standard sections

Include these when they fit the topic, using these exact titles so anchors match across notes:

- `## How to Use This Guide` as the first section.
- `## Abbreviations and Acronyms` or `## Glossary` for terminology.
- `## Junior (0-2 Years)`, `## Mid (2-5 Years)`, `## Senior (5+ Years)` for leveled interview questions.
- `## Rapid Answers` with a `Question | One-line answer` table.
- `## Quick Interview Checklist` with `- [ ]` items grouped under bold labels.

### 10. Files and folders

- A note lives in a lowercase topic folder: `dotnet/`, `databases/`, `algorithms/`, `aws/`, or a new one.
- File names use `Title_Case_With_Underscores.md`. Interview notes end in `_Cheat_Sheet.md` (for example `EF_Core_Interview_Cheat_Sheet.md`).
- Every note is listed in the root [`README.md`](../../../README.md) catalog (see the `new-note` skill).
