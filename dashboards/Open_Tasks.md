---
type: dashboard
title: "Open Tasks"
summary: "Every open task in the vault, grouped into overdue, due soon, mine, by owner, and without a due date."
covers: [overdue tasks, tasks due in the next 7 days, my tasks, tasks by owner, tasks without a due date]
queries: [meetings, tasks]
requires: [dataview]
related: ["[[Follow_Ups]]", "[[Active_Projects]]", "[[Standalone_Tasks]]"]
tags: [dashboard]
created: 2026-11-20
updated: 2026-11-20
---

# Open Tasks

[Knowledge-Hub](../README.md) / [Dashboards](Dashboards.md) / Open Tasks

Every open task in the vault. Tasks live in meeting notes and in [[Standalone_Tasks]]; this page only queries them. Requires the Dataview plugin.

## Overdue

```dataview
TASK
FROM "meetings" OR "tasks"
WHERE !checked AND due AND due < date(today)
SORT due ASC
```

## Due in the Next 7 Days

```dataview
TASK
FROM "meetings" OR "tasks"
WHERE !checked AND due AND due >= date(today) AND due <= date(today) + dur(7 days)
SORT due ASC
```

## Mine

```dataview
TASK
FROM "meetings" OR "tasks"
WHERE !checked AND owner = [[Me]]
SORT due ASC
```

## By Owner

```dataview
TASK
FROM "meetings" OR "tasks"
WHERE !checked
GROUP BY owner
```

## No Due Date

```dataview
TASK
FROM "meetings" OR "tasks"
WHERE !checked AND !due
GROUP BY file.link
```
