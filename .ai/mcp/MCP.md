# MCP servers (optional)

[Knowledge-Hub](../../README.md) / [.ai](../AI.md) / mcp

MCP servers let agents pull meeting context straight from your tools: event titles, attendees, and email addresses from a calendar; threads from Slack or Teams; and messages from email. Every skill works without them. When no server is configured, the agent filing a conversation uses what the source contains and asks you for the rest.

## What each source is used for

| Source | Used by | What the agent reads |
|--------|---------|----------------------|
| Calendar (Google or Outlook) | Filing conversations | The event matching a conversation's date and time: title, attendees, attendee emails, and the description |
| Slack | Filing conversations | A thread you point to, saved into `inbox/` as `YYYY-MM-DD_slack_<slug>.md` |
| Microsoft 365 (Outlook mail and calendar, Teams chat) | Filing conversations | Calendar events, an email thread, or a Teams chat you point to, saved into `inbox/` |

Agents only read from these services. The skills never send messages, accept invites, or change events.

## Candidate servers

These are community servers that were available at the time of writing. Check each one's repository, maintenance status, and requested permissions before you install it, and give it the narrowest scopes it accepts (read-only calendar, read-only mail).

| Service | Package | Auth |
|---------|---------|------|
| Google Calendar | `@cocal/google-calendar-mcp` | Google OAuth client JSON (`GOOGLE_OAUTH_CREDENTIALS`) |
| Microsoft 365 | `@softeria/ms-365-mcp-server` | Microsoft sign-in on first run; supports a read-only mode |
| Slack | `@zencoderai/slack-mcp-server` | Slack bot token (`SLACK_BOT_TOKEN`) and team ID (`SLACK_TEAM_ID`) |

## Setup in Cursor

1. Copy [`mcp.example.json`](mcp.example.json) to `.cursor/mcp.json` in the repo, or merge it into your user-level `~/.cursor/mcp.json`. Delete the servers you don't use.
2. Put secrets in environment variables, not in the file. The example reads them with `${env:NAME}`.
3. `.cursor/mcp.json` is git-ignored, so a local copy that contains secrets is never committed.
4. Restart Cursor or reload MCP servers, then check that the servers show as connected in Cursor's MCP settings.

Other agents (Claude Code, Codex, Copilot) use the same servers through their own MCP configuration files. Only the file location differs.

## Privacy

Calendar, mail, and chat content becomes part of the vault once it is ingested. Only connect accounts whose content you are allowed to store, and keep ingested content local: the allowlist `.gitignore` excludes it, so never force-add it. Real MCP configuration (`mcp.json`) is git-ignored; only `mcp.example.json` is shared.
