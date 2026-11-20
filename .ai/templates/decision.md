---
type: decision
title: '<% tp.file.title.replace(/^\d{4}\.\d{2}\.\d{2}T\d{2}\.\d{2}\.\d{2}-/, "").replace(/-/g, " ") %>'
summary: "<One sentence: what was decided.>"
covers: []
date: <% tp.date.now("YYYY-MM-DD") %>
status: accepted
project: ""
decided_by: []
source: ""
supersedes: ""
superseded_by: ""
related: []
tags: []
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
---

# <% tp.file.title.replace(/^\d{4}\.\d{2}\.\d{2}T\d{2}\.\d{2}\.\d{2}-/, "").replace(/-/g, " ") %>

[Knowledge-Hub](../README.md) / [Decisions](Decisions.md) / <% tp.file.title.replace(/^\d{4}\.\d{2}\.\d{2}T\d{2}\.\d{2}\.\d{2}-/, "").replace(/-/g, " ") %>

## Context

<The problem or question that needed a decision, and the constraints at the time.>

## Options

- <Option considered, with the main argument for or against it.>

## Decision

<The decision in one or two sentences, as it was agreed.>

## Consequences

- <What changes because of it: work created, work avoided, risks accepted.>

## Source

- <[[YYYY.MM.DDTHH.MM.SS-Meeting-Title]], or where else the decision was made.>
