---
type: person
title: '<% tp.file.title.replace(/_/g, " ") %>'
summary: "<One sentence: who they are and how they relate to the vault owner's work.>"
covers: []
company: ""
role: ""
email: ""
phone: ""
timezone: ""
projects: []
related: []
aliases: []
tags: []
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
---

# <% tp.file.title.replace(/_/g, " ") %>

[Knowledge-Hub](../README.md) / [People](People.md) / <% tp.file.title.replace(/_/g, " ") %>

## About

<Who they are, what they care about, how they prefer to work. Only facts that were stated.>

## Interactions

- <YYYY-MM-DD — [[YYYY.MM.DDTHH.MM.SS-Meeting-Title]]: one line on what happened.>

## Open Tasks

```dataview
TASK
FROM "meetings" OR "tasks"
WHERE !completed AND owner = this.file.link
SORT due ASC
```
