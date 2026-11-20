---
type: project
title: '<% tp.file.title.replace(/-/g, " ") %>'
summary: "<One sentence: what the project delivers, for whom.>"
covers: []
client: ""
status: active
start: <% tp.date.now("YYYY-MM-DD") %>
end: ""
owner: "[[Me]]"
stakeholders: []
meetings: []
related: []
aliases: []
tags: []
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
---

# <% tp.file.title.replace(/-/g, " ") %>

[Knowledge-Hub](../README.md) / [Projects](Projects.md) / <% tp.file.title.replace(/-/g, " ") %>

## Overview

<What the project is, for whom, and why it exists.>

## Goals

- <Measurable goal or deliverable.>

## Timeline

- <YYYY-MM-DD — [[YYYY.MM.DDTHH.MM.SS-Meeting-Title]]: one line on what changed.>

## Decisions

```dataview
TABLE date, status, decided_by AS "Decided by"
FROM "decisions"
WHERE project = this.file.link
SORT date ASC
```

## Open Tasks

```dataview
TASK
FROM "meetings" OR "tasks"
WHERE !completed AND project = this.file.link
SORT due ASC
```
