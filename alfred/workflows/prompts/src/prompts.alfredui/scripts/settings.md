### Help

Two ways to add a source:

1. **Look it up**: paste a bare GitHub link or `owner/repo` in the field above and press ↩. The sources it finds show here, already typed (`claude …` or `markdown …`); double-click one to add it to the list.
2. **Type it**: write it in the list on the left, one source per line starting with its type, `claude` or `markdown`. A line without a type fails.

Test checks the list and shows the result here, Save keeps it and updates the prompts, ⎋ closes without saving. An empty list goes back to the workflow configuration, then the defaults.

- `claude <repo> [plugin]`: every plugin of a Claude marketplace, or one; a repo that is no marketplace is one plugin (its `skills/<name>/SKILL.md`)
- `markdown <repo or folder> [glob,…]`: its Markdown (`.md`, `.mdc`) files, or those matching the globs, from the repo root (`*` crosses folders, a folder gives its Markdown files)

A repo is `owner/repo` or a GitHub link, `@<ref>` picks a branch, tag or commit. A folder on this Mac starts with `/` or `~`.

A prompt's name and description come from its frontmatter, else its file name (its folder's for `SKILL.md`) and first line of text.

#### Examples

- Every plugin of a Claude marketplace:
  - `claude anthropics/claude-plugins-official`
- One plugin:
  - `claude anthropics/claude-plugins-official superpowers`
- A plugin repo that is no marketplace:
  - `claude vercel-labs/agent-skills`
- Every Markdown file of a repo:
  - `markdown owner/repo`
- A folder, by glob or link:
  - `markdown owner/repo prompts`
  - `markdown https://github.com/owner/repo/tree/main/prompts`
- Files by glob, several with commas:
  - `markdown danielmiessler/fabric data/patterns/*/system.md`
  - `markdown owner/repo skills/*/SKILL.md,.cursor/rules`
- A legacy .cursorrules file:
  - `markdown owner/repo .cursorrules`
- Pinned to a tag:
  - `markdown owner/repo@v1.2 prompts`
- A folder on this Mac:
  - `markdown ~/notes/prompts`
