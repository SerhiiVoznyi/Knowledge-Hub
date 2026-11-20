---
type: weekly-review
title: 'Weekly Review <% tp.date.now("GGGG-[W]WW") %>'
summary: "<One sentence: the main outcome or theme of the week.>"
covers: []
week: <% tp.date.now("GGGG-[W]WW") %>
start: <% moment().isoWeekday(1).format("YYYY-MM-DD") %>
end: <% moment().isoWeekday(7).format("YYYY-MM-DD") %>
previous_review: ""
projects: []
related: []
tags: []
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
---

# Weekly Review <% tp.date.now("GGGG-[W]WW") %>

[Knowledge-Hub](../README.md) / [Journal](Journal.md) / Weekly Review <% tp.date.now("GGGG-[W]WW") %>

## Meetings

- <[[YYYY.MM.DDTHH.MM.SS-Meeting-Title]] — one-line outcome.>

## Decisions

- <[[YYYY.MM.DDTHH.MM.SS-Decision-Title]] — one-line statement.>

## Completed Tasks

- <Task description — [[Owner]], from [[Source note]].>

## Open and Overdue Tasks

- <Task description — [[Owner]], due YYYY-MM-DD, from [[Source note]]. Mark overdue ones with "(overdue)".>

## Follow-Ups

- <Who to contact next week and why.>

## Notes

<Patterns, risks, or anything worth remembering from the week.>
