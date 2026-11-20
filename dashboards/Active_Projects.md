---
type: dashboard
title: "Active Projects"
summary: "Projects by status, with meeting activity from the last 30 days."
covers: [active projects, on-hold projects, recent project activity, done and cancelled projects]
queries: [projects, meetings]
requires: [dataview]
related: ["[[Open_Tasks]]", "[[Follow_Ups]]"]
tags: [dashboard]
created: 2026-11-20
updated: 2026-11-20
---

# Active Projects

[Knowledge-Hub](../README.md) / [Dashboards](Dashboards.md) / Active Projects

Projects by status, with their latest activity. Requires the Dataview plugin.

## Active

```dataview
TABLE client, owner, start
FROM "projects"
WHERE status = "active"
SORT file.name ASC
```

## On Hold

```dataview
TABLE client, owner, start
FROM "projects"
WHERE status = "on-hold"
SORT file.name ASC
```

## Recent Activity

```dataview
TABLE WITHOUT ID project AS "Project", file.link AS "Meeting", date
FROM "meetings"
WHERE project AND date >= date(today) - dur(30 days)
SORT date DESC
```

## Done and Cancelled

```dataview
TABLE client, start, end
FROM "projects"
WHERE status = "done" OR status = "cancelled"
SORT end DESC
```
