---
name: extract-tasks
description: Turn commitments from a conversation into task lines in the vault's inline format, with an owner, optional due date, and priority, or add standalone tasks to tasks/Standalone_Tasks.md. Also marks tasks done or cancelled. Use when filing a conversation, or when the user asks to add, complete, cancel, or reassign a task.
---

# Extract and Manage Tasks

[Knowledge-Hub](../../../README.md) / [.ai](../../AI.md) / [skills](../Skills.md) / Extract and Manage Tasks

The task line format and the "one source of truth" rule are defined in section 5 of [`vault-conventions`](../vault-conventions/SKILL.md#5-tasks). This skill applies them.

## Finding tasks in a conversation

A task is a commitment by a specific person to do something. Look for:

- explicit commitments: "I'll send the proposal by Friday", "John will check the logs";
- assignments that were accepted: "Can you update the estimate?" followed by "Sure";
- agreed next steps: "Let's schedule a follow-up for next week";
- requests addressed to the vault owner (`[[Me]]`), even when the owner did not answer in the source.

Not tasks: ideas ("we could try..."), wishes without an owner, or things that were already done during the conversation. Put ideas under Key Points, and put work nobody took on under Open Questions ("Who owns the migration plan?").

## Writing task lines

1. Start with a verb and keep it self-contained: "Send revised pricing proposal to Client X", not "Send it".
2. Add `[owner:: [[Person]]]` with the person who committed. If that person has no note yet, [`update-entities`](../update-entities/SKILL.md) creates one.
3. Add `[due:: YYYY-MM-DD]` only for a stated deadline. Resolve relative dates against the meeting date: "by Friday" in a Wednesday 2026-11-18 meeting is 2026-11-20. "Next week" without a day is `[scheduled::]` with the Monday of that week, not a `due`.
4. Add `[priority:: high]` or `highest` only when urgency was stated ("urgent", "blocker", "before anything else").
5. Write the lines under `## Action Items` in the meeting note. Never copy them into another file.

## Standalone tasks

Tasks that did not come from a meeting go in `tasks/Standalone_Tasks.md` under a `## <Project or Area>` heading. Use `## General` when there is no project. Include `[project:: [[Project]]]` when the task belongs to one. If `tasks/Standalone_Tasks.md` does not exist, create it from [`.ai/templates/tasks.md`](../../templates/tasks.md).

Whenever you edit `tasks/Standalone_Tasks.md`, keep its front matter current: set `updated` to today, add any new project to `projects`, and add any new area or project heading to `covers`.

Whenever you add or change a task line in a meeting note, set that meeting's `updated` to today.

## Updating tasks

- **Find the task.** Search for its description in `meetings/` and `tasks/`. It exists in one place only.
- **Complete:** change `- [ ]` to `- [x]` and append `[completion:: YYYY-MM-DD]`.
- **Cancel:** change `- [ ]` to `- [-]`. If a reason was given, add it to the meeting's Open Questions or the project's Timeline.
- **Reassign or reschedule:** edit the `owner` or `due` field in place, and add a dated Timeline entry on the project if the change matters.

## Done when

- Every commitment from the source has exactly one task line.
- Every task line has a description and `[owner:: [[...]]]` that resolves, and its optional fields are in the order the conventions give.
- The edited files follow `vault-conventions`, and their `updated` is today.
