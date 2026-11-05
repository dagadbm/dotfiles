# Dotfiles

Personal macOS dev environment. Each tool owns a top-level directory; Dotbot
symlinks its files into `~` per `dotbot.conf.yaml` (repo-relative paths), the
single source of truth for what lands where. Third-party code lives in
`submodules/`.

## Rules

- Edit only inside this repo; Dotbot mirrors it into `~`.
- After changing `dotbot.conf.yaml`, run `mise run dotbot`; after any change,
  `mise run lint`.
- `submodules/` is read-only; change it only via `mise run submodules:update`.
- Ask first before: changing submodule refs, editing multi-profile
  (personal/work) files, running `mise run update:sync`,
  `mise run update:async` or `mise run submodules:update`, adding a top-level
  directory.

## Commands

```bash
mise tasks                                # list tasks (descriptions in mise.toml)
mise run                                  # pick a task interactively
```

## Commits

`<type>: <subject>`, one line, lowercase, no scope, no trailing period.

- `feat:` new or changed behaviour or config
- `fix:` corrects something broken
- `refactor:` same behaviour, restructured
- `update:` version, lockfile or submodule bumps (`update: neovim`)
- `docs:` documentation only

No other types, no `(scope)`: name the tool at the start of the subject
instead (`feat: claude auto-compact via env vars`, `fix: claude settings
reorder`). Split unrelated changes into separate commits.

## Layout

- `neovim/<name>/` links to `~/.config/nvim-<name>`, picked via
  `NVIM_APPNAME`. `dagadbm/` is the legacy hand-rolled config; `lazyvim/` and
  `astrovim/` are distros (customise in their `lua/plugins/`).
- Multi-profile: `git/gitconfig*`, `ssh/config` + `ssh/personal` /
  `ssh/work`, `zsh/zshrc.work.zsh`.
- `scripts/*.sh` run as `mise.toml` tasks and source `scripts/utils.sh` (cd to
  repo root, helpers); `*-prune.sh` also source `scripts/prune-utils.sh`.
  Every task points at a script (`file = ...`), never inline `run` code.
- `update-sync.sh` and `update-async.sh` run the `*:update` tasks in one
  `mise run ... ::: ...`, sequentially (`--jobs 1`) or in parallel; add new
  update tasks to both.
  `bootstrap.sh` runs directly, before mise exists.

## Theme: astrodark

Every tool uses astrodark (astrotheme Neovim plugin); take every colour from
upstream `$AT` = `~/.local/share/nvim-astrovim/lazy/astrotheme`: palette
`$AT/lua/astrotheme/palettes/astrodark.lua`, extras
`$AT/extras/<tool>/*.astrodark.*`.

### Vendored: re-copy the extra unchanged

| File | Extra |
| --- | --- |
| `ghostty/themes/` | `ghostty/` |
| `wezterm/colors/` | `wezterm/` |
| `helix/themes/` | `helix/` |
| `lazygit/themes/` | `lazygit/` |
| `bat/themes/` | `sublime/` |
| `git/delta.astrodark.gitconfig` | `delta/` |

### Derived: hand-edit from the palette

| File | Notes |
| --- | --- |
| `zsh/p10k.astrodark.zsh` |  |
| `zsh/fzf.astrodark.zsh` |  |
| `zsh/fsh.astrodark.ini` |  |
| `zsh/ls-colors.astrodark.zsh` |  |
| `zsh/lsd.astrodark.yaml` |  |
| `zsh/broot.conf.toml` | only the `[skin]` section |
| `zsh/zshrc.zsh` | only `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` |
| `tmux/astrodark.tmux` |  |
| `herdr/config.toml` | only the `[theme.custom]` section |
| `agents/claude/ccstatusline.settings.json` |  |
| `agents/claude/astrodark.json` |  |

Each file keeps its changes in one comment block starting with
`astrodark theme, derived`:

```zsh
# astrodark theme, derived
# legend: <palette key> (<derivation or taken from X>, optional): <variables set>
# ui.base: fzf_bg, fzf_gutter
# syntax.green (blend 0.75 into ui.base, taken from delta plus-style): fzf_bg+
# syntax.blue: fzf_hl, fzf_prompt
# notes: <changes that are not obvious from reading the file>
```
