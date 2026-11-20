---
type: dashboard
title: '<% tp.file.title.replace(/_/g, " ") %>'
summary: "<One sentence: what the dashboard shows and when to open it.>"
covers: []
queries: []
requires: [dataview]
related: []
tags: [dashboard]
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
---

# <% tp.file.title.replace(/_/g, " ") %>

[Knowledge-Hub](../README.md) / [Dashboards](Dashboards.md) / <% tp.file.title.replace(/_/g, " ") %>

<One paragraph: what the page shows. Requires the Dataview plugin.>

## <Query Title>

```dataview
TABLE <fields>
FROM "<folder>"
WHERE <condition>
SORT <field> ASC
```
