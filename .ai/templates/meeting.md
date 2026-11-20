---
type: meeting
title: '<% tp.file.title.replace(/^\d{4}\.\d{2}\.\d{2}T\d{2}\.\d{2}\.\d{2}-/, "").replace(/-/g, " ") %>'
summary: "<One sentence: why the meeting happened and what came out of it.>"
covers: []
date: <% tp.date.now("YYYY-MM-DD") %>
time: ""
duration: ""
location: ""
source: paste
source_lang: en
status: needs-review
participants: []
project: ""
decisions: []
notes: []
follow_up_of: ""
raw_input: ""
related: []
tags: []
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
---

# <% tp.file.title.replace(/^\d{4}\.\d{2}\.\d{2}T\d{2}\.\d{2}\.\d{2}-/, "").replace(/-/g, " ") %>

[Knowledge-Hub](../../README.md) / [Meetings](../Meetings.md) / [<% tp.file.title.slice(0, 4) %>](<% tp.file.title.slice(0, 4) %>.md) / <% tp.file.title.replace(/^\d{4}\.\d{2}\.\d{2}T\d{2}\.\d{2}\.\d{2}-/, "").replace(/-/g, " ") %>

## Summary

<Three to five sentences: why the meeting happened, what was settled, what happens next.>

## Key Points

- <Point, attributed when it matters: "[[Anna_Kowalska]] said the budget is fixed for Q1.">

## Decisions

- <[[YYYY.MM.DDTHH.MM.SS-Decision-Title]] — one-line statement of the decision.>

## Action Items

- [ ] <Verb-first description> [owner:: [[Me]]] [due:: YYYY-MM-DD]

## Open Questions

- <Anything unclear or unconfirmed, phrased as a question.>

## Source

- <Source type and where it came from: "Teams transcript, exported by Anna.">
- [raw input](../../inbox/_processed/<file>.md)
