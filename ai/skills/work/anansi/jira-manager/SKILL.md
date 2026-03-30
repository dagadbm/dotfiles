---
name: jira-manager
description: Manage Jira tickets for the ANANSI project. Use when the user wants to create tickets, move ticket state, open tickets in browser, or create git branches from ticket names. Triggers on "create a ticket", "move ticket to", "open ANANSI-123", "create branch for ticket", "transition ticket", or any Jira-related workflow request.
allowed-tools: Bash(acli *), Read, Write, Edit
---

# Jira Manager for ANANSI

Manages Jira tickets via the `acli` CLI for the ANANSI project.

## Step 0: Load Config

**Always do this first.** Read the config file and extract variables:

```bash
cat ~/.agents/skills/jira-manager/config.json
```

The config defines these variables — use them everywhere, never hardcode:

| Variable | Config field | Example value |
|---|---|---|
| `$PROJECT` | `project` | `"ANANSI"` |
| `$BOARD_ID` | `board_id` | `"4"` |
| `$DEFAULT_TYPE` | `default_type` | `"Story"` |
| `$ALLOWED_TYPES` | `allowed_types` | `["Story", "Bug", "Task"]` |
| `$STATUSES` | `statuses` | `["To Do", "In Progress", ...]` |
| `$DEFAULT_STATUS` | `default_status` | `"In Progress"` |

## Step 0.5: Get Current Sprint ID

Fetch the active sprint for the board and extract its ID — store as `$SPRINT_ID`:

```bash
acli jira board list-sprints --id "$BOARD_ID" --state active --json
```

Parse the first sprint's `id` field from `.sprints[0].id`. This is `$SPRINT_ID`.

If no active sprint is found, use the most recent future sprint instead (`--state future`, take first result). If still none, skip sprint assignment.

## Step 1: Auth Check

Check the `authenticated` field from config:

- If `true` → proceed
- If `false` → run `acli auth login`, wait for completion, then update config `authenticated: true`

## Operations

### 1. Create a Ticket

**Required inputs:** summary (title), description
**Optional inputs:** type (default: `$DEFAULT_TYPE`), parent/epic key

**Rules:**
- NEVER create Sub-tasks. Never use type "Sub-task".
- Default type is `$DEFAULT_TYPE`. User can request any type in `$ALLOWED_TYPES`.
- If no parent/epic is mentioned, create as standalone (no `--parent` flag).
- ALWAYS use ADF format for descriptions (renders as rich text in Jira, not plain text).

**Description format:** Write as ADF JSON, pass via `--description-file`. Save to a temp file first.

ADF structure for common elements:
- Heading: `{"type":"heading","attrs":{"level":2},"content":[{"type":"text","text":"Title"}]}`
- Paragraph: `{"type":"paragraph","content":[{"type":"text","text":"..."}]}`
- Bold text: `{"type":"text","text":"bold","marks":[{"type":"strong"}]}`
- Bullet list: `{"type":"bulletList","content":[{"type":"listItem","content":[{"type":"paragraph","content":[{"type":"text","text":"item"}]}]}]}`
- Code block: `{"type":"codeBlock","attrs":{"language":"bash"},"content":[{"type":"text","text":"..."}]}`

Use the `Write` tool to create `./jira_workitem.json` with the full workitem payload (including sprint). The `description` field must be ADF JSON (not a file path):

```json
{
  "summary": "SUMMARY",
  "projectKey": "$PROJECT",
  "type": "$DEFAULT_TYPE",
  "assignee": "@me",
  "description": { <ADF content here> },
  "additionalAttributes": {
    "customfield_10020": { "id": $SPRINT_ID }
  }
}
```

For tickets with a parent/epic, add `"parentIssueId": "$PROJECT-123"` to the JSON.

Then create the ticket:

```bash
acli jira workitem create --from-json ./jira_workitem.json
```

After the command completes, delete `./jira_workitem.json`.

Transition the new ticket to `$DEFAULT_STATUS`:

```bash
acli jira workitem transition --key "$PROJECT-456" --status "$DEFAULT_STATUS" --yes
```

Then output the ticket key and offer to:
- Open in browser
- Create a git branch for it

### 2. Transition Ticket State

**Required inputs:** ticket key (e.g. `$PROJECT-123`)

Present the full list from `$STATUSES` and prompt the user to pick one:

```
Available statuses:
1. <$STATUSES[0]>
2. <$STATUSES[1]>
...

Which status do you want to move $PROJECT-123 to?
```

Then run:

```bash
acli jira workitem transition --key "$PROJECT-123" --status "<chosen status>" --yes
```

### 3. View a Ticket

```bash
acli jira workitem view $PROJECT-123

# Open in browser
acli jira workitem view $PROJECT-123 --web
```

### 4. Create a Git Branch from a Ticket

```bash
acli jira workitem view $PROJECT-123 --fields "key,summary" --json
```

Branch name pattern:
- Format: `$PROJECT-123-short-summary-in-kebab-case`
- Lowercase, replace spaces and special chars with `-`, strip punctuation
- Keep concise (max ~50 chars total)

Example: `$PROJECT-456` "Add user authentication flow" → `$PROJECT-456-add-user-authentication-flow`

```bash
git checkout -b $PROJECT-456-add-user-authentication-flow
```

### 5. Search / List Tickets

```bash
# My open tickets
acli jira workitem search --jql "project = $PROJECT AND assignee = currentUser() AND statusCategory != Done" --fields "key,summary,status,issuetype" --json

# Tickets in a specific status
acli jira workitem search --jql "project = $PROJECT AND status = 'In Progress'" --fields "key,summary,assignee,issuetype" --json
```

## Workflow Tips

- After creating a ticket, always offer: open in browser? create branch?
- After transitioning, confirm the new state.
- When in doubt about type, use `$DEFAULT_TYPE` — never Sub-task.
- If the user mentions an Epic, use it as `--parent` but do not create sub-tasks of stories.
