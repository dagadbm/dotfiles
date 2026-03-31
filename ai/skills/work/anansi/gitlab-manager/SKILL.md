---
name: gitlab-manager
description: Manage GitLab merge requests, issues, and repository tasks for the ISS project. Use when the user wants to create MRs, view MRs, list MRs, open MRs in browser, create branches, view issues, or any GitLab-related workflow request. Triggers on "create a MR", "open MR", "list my MRs", "view issue", "create branch", or any GitLab workflow request.
allowed-tools: Bash(glab *), Read, Write, Edit
disable-model-invocation: true
---

# GitLab Manager for ISS

Manages GitLab operations via the `glab` CLI for the ISS project.

## Step 0: Load Config

**Always do this first.** Read the config file and extract variables:

```bash
cat ~/.agents/skills/gitlab-manager/config.json
```

The config defines these variables — use them everywhere, never hardcode:

| Variable | Config field | Example value |
|---|---|---|
| `$REPO` | `repo` | `"anansi-team/infra/iss"` |
| `$REPO_URL` | `repo_url` | `"https://gitlab.com/anansi-team/infra/iss"` |
| `$DEFAULT_BRANCH` | `default_branch` | `"develop"` |

## Step 1: Auth Check

Check the `authenticated` field from config:

- If `true` → proceed
- If `false` → run `glab auth login`, wait for completion, then update config `authenticated: true`

All `glab` commands should use `-R $REPO` when not already inside the repo directory. When running from the repo root, the flag can be omitted.

## MR Creation Workflow

When creating an MR, always follow these steps in order:

### Step A: Verify Commit Messages

Check that all commits on the branch (vs `$DEFAULT_BRANCH`) contain `Resolves $JIRA_TICKET_ID`:

```bash
git log develop..HEAD --format="%H %s%n%b"
```

- Every commit must have a line: `Resolves $JIRA_TICKET_ID` (e.g. `Resolves PROJ-123`)
- If ANY commit is missing this line → **do NOT proceed**. Tell the user which commits are missing it and ask them to amend before continuing.

### Step B: Ask User to Push

**Never push yourself.** Ask the user to push the branch:

> "Please push the branch with `git push -u origin BRANCH-NAME`, then let me know when done."

Wait for the user to confirm the branch is pushed before proceeding.

### Step C: Create the MR

Before creating, read the Jira config to get the base URL:

```bash
cat .agents/skills/jira-manager/config.json
```

Include the Jira ticket link at the end of the MR description, using the base URL from the config:

```
[$JIRA_TICKET_ID]($JIRA_BASE_URL/browse/$JIRA_TICKET_ID)
```

Example (from current config): `[ANANSI-123](https://anansi.atlassian.net/browse/ANANSI-123)`

## Operations

### 1. Create a Merge Request

**Required inputs:** title, source branch (defaults to current branch)
**Optional inputs:** description, target branch (default: `$DEFAULT_BRANCH`), draft, labels, assignee, reviewer

```bash
# Basic MR
glab mr create \
  --title "TITLE" \
  --description "DESCRIPTION" \
  --target-branch "$DEFAULT_BRANCH" \
  --assignee @me \
  --yes

# Draft MR
glab mr create \
  --title "Draft: TITLE" \
  --description "DESCRIPTION" \
  --target-branch "$DEFAULT_BRANCH" \
  --draft \
  --assignee @me \
  --yes

# With labels and reviewer
glab mr create \
  --title "TITLE" \
  --description "DESCRIPTION" \
  --target-branch "$DEFAULT_BRANCH" \
  --label "bugfix" \
  --assignee @me \
  --reviewer username \
  --yes
```

After creation, output the MR URL and offer to:
- Open in browser
- Mark as ready (if draft)

### 2. View a Merge Request

```bash
# View by MR ID
glab mr view 123

# View with comments
glab mr view 123 --comments

# Open in browser
glab mr view 123 --web

# View current branch's MR
glab mr view
```

### 3. List Merge Requests

```bash
# My open MRs
glab mr list --assignee @me

# MRs awaiting my review
glab mr list --reviewer @me

# All open MRs
glab mr list

# Draft MRs only
glab mr list --draft --assignee @me

# Merged MRs
glab mr list --merged --assignee @me
```

### 4. Update a Merge Request

```bash
# Mark ready (remove draft)
glab mr update 123 --ready

# Add labels
glab mr update 123 --label "needs-review"

# Change title
glab mr update 123 --title "New title"

# Change target branch (use $DEFAULT_BRANCH or user-specified)
glab mr update 123 --target-branch "$DEFAULT_BRANCH"
```

### 5. Merge a Merge Request

```bash
# Merge when pipeline succeeds
glab mr merge 123

# Merge immediately (squash)
glab mr merge 123 --squash --yes

# Merge and remove source branch
glab mr merge 123 --remove-source-branch --yes
```

### 6. Create a Git Branch from Context

Branch name pattern:
- Format: `TICKET-ID-short-description-in-kebab-case` (if tied to a Jira ticket)
- Or: `short-description-in-kebab-case` (standalone)
- Lowercase, replace spaces and special chars with `-`, strip punctuation
- Keep concise (max ~50 chars total)

Example: Jira ticket ANANSI-456 "Add user auth flow" → `ANANSI-456-add-user-auth-flow`

```bash
git checkout -b BRANCH-NAME
```

### 7. View an Issue

```bash
glab issue view 123

# Open in browser
glab issue view 123 --web
```

### 8. List Issues

```bash
# Open issues assigned to me
glab issue list --assignee @me

# All open issues
glab issue list

# Issues with a specific label
glab issue list --label "bug"
```

### 9. CI Pipeline Status

```bash
# View pipeline for current branch
glab ci view

# List recent pipelines
glab ci list
```

## Workflow Tips

- After creating an MR, always offer: open in browser? mark as ready?
- Use `--fill` flag for quick MR creation from commit messages.
- Use `-R $REPO` if running outside the repo directory.
- Target branch always comes from `$DEFAULT_BRANCH` unless user specifies otherwise. Never hardcode it.
- When referencing Jira tickets in MR titles/descriptions, prefix with the ticket key (e.g. `PROJ-123`).
- Always end MR descriptions with a Jira ticket link. Read base URL from `.agents/skills/jira-manager/config.json`.
- Never push the branch yourself — always ask the user to push and wait for confirmation.
- Never create an MR if commits are missing `Resolves $JIRA_TICKET_ID` in their message body.
