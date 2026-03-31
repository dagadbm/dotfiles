---
name: fix-commit-message
description: Rewrites the last commit message to match the project commit message template. Invoke manually with /fix-commit-message.
allowed-tools: "Bash, Read, Edit, Write"
disable-model-invocation: true
---

# Fix Commit Message

Rewrite the last commit message to match the project commit message template.

## Template

```
<short imperative summary>

<Why this change is needed — one or more paragraphs explaining the
context and motivation behind the work.>

This development adds the following:
1. <First thing added/changed>
2. <Second thing added/changed>
3. <Third thing added/changed>

Resolves <TICKET-XXXX>

**DEPLOYMENT INSTRUCTIONS:**
* <Step 1 — e.g. run migrations>
* <Step 2 — e.g. register a periodic task>
* <Step 3 — e.g. create cloud storage buckets, update env vars, etc.>
```

## Instructions

1. Run `git log -1 --format="%B"` to read the current commit message.
2. Run `git diff HEAD~1 HEAD` to understand what was actually changed.
3. Extract the ticket reference from the branch name or existing commit message (`git rev-parse --abbrev-ref HEAD`).
4. Draft a new message following the template above:
   - **Summary line**: short, imperative, no period.
   - **Body**: explain the *why* — the business/product motivation, not just what the code does.
   - **Numbered list**: one item per logical change (data structures, endpoints, jobs, config, etc.).
   - **Resolves**: use the ticket from the branch or existing message.
   - **Deployment instructions**: include only steps actually required. Use exact commands. Omit steps that are not needed.
5. Amend the commit: `git commit --amend -m "..."` using a HEREDOC to preserve formatting.
6. Show the final commit message to the user for confirmation.
