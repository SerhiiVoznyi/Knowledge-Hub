---
type: dashboard
title: "Follow-Ups"
summary: "What the vault owner is waiting on, and what still needs a decision or a review."
covers: [tasks waiting on others, meetings needing review, proposed decisions, recent meetings]
queries: [meetings, tasks, decisions]
requires: [dataview]
related: ["[[Open_Tasks]]", "[[Active_Projects]]"]
tags: [dashboard]
created: 2026-11-20
updated: 2026-11-20
---

# Follow-Ups

[Knowledge-Hub](../README.md) / [Dashboards](Dashboards.md) / Follow-Ups

What you are waiting on, and what still needs a decision or a review. Requires the Dataview plugin.

## Waiting on Others

```dataview
TASK
FROM "meetings" OR "tasks"
WHERE !checked AND owner AND owner != [[Me]]
GROUP BY owner
```

## Meetings Needing Review

```dataview
TABLE date, project, participants
FROM "meetings"
WHERE status = "needs-review"
SORT date DESC
```

## Proposed Decisions

```dataview
TABLE date, project, decided_by AS "Decided by"
FROM "decisions"
WHERE status = "proposed"
SORT date DESC
```

## Recent Meetings

```dataview
TABLE date, project, participants
FROM "meetings"
WHERE date >= date(today) - dur(14 days)
SORT date DESC
```
