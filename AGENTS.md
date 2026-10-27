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
  (personal/work) files, running `mise run update` or
  `mise run submodules:update`, adding a top-level directory.

## Commands

```bash
mise tasks                                # list tasks
mise run                                  # pick a task interactively
mise run dotbot                           # relink after changing dotbot.conf.yaml
mise run update                           # update everything
mise run nvim:update                      # update Neovim, LSP, plugins
mise run herdr:update                     # update herdr
mise run hk:update                        # update hk, install git hooks
mise run claude:update                    # update agent tooling
mise run submodules:update                # update submodules
mise run brew:update                      # update Homebrew
mise run mise:update                      # update mise
mise run prune                            # prune everything
mise run brew:prune                       # prune Homebrew to match Brewfile
mise run mise:prune                       # prune mise
mise run claude:prune                     # prune claude to match scripts/claude-update.sh
mise run macos:defaults                   # apply macOS preferences
mise run lint                             # format and lint all configs and scripts
```

### Git Submodules

#### Add

```bash
git submodule add https://github.com/wfxr/forgit.git submodules/forgit
```

#### Delete

```bash
export MODULE=submodules/repo_name && \
  git submodule deinit -f $MODULE && \
  rm -rf .git/modules/$MODULE && \
  git rm -f $MODULE
```

## Layout

- `neovim/<name>/` links to `~/.config/nvim-<name>`, picked via
  `NVIM_APPNAME`. `dagadbm/` is the legacy hand-rolled config; `lazyvim/` and
  `astrovim/` are distros (customise in their `lua/plugins/`).
- Multi-profile: `git/gitconfig*`, `ssh/config` + `ssh/personal` /
  `ssh/work`, `zsh/zshrc.work.zsh`.
- `scripts/*.sh` run as `mise.toml` tasks and source `scripts/utils.sh` (cd to
  repo root, helpers); `*-prune.sh` also source `scripts/prune-utils.sh`.
  `bootstrap.sh` runs directly, before mise exists.

## Theme: astrodark

Every tool uses astrodark (astrotheme Neovim plugin); take every colour from
upstream `$AT` = `~/.local/share/nvim-astrovim/lazy/astrotheme`: palette
`$AT/lua/astrotheme/palettes/astrodark.lua`, extras
`$AT/extras/<tool>/*.astrodark.*` (zsh uses `fish/`). On upstream change,
update each file by its class.

### Vendored: re-copy the extra unchanged

| Target                          | Extra from                      |
| ------------------------------- | ------------------------------- |
| `ghostty/themes/`               | `ghostty/`                      |
| `wezterm/colors/`               | `wezterm/`                      |
| `helix/themes/`                 | `helix/`                        |
| `lazygit/themes/`               | `lazygit/`                      |
| `bat/themes/`                   | `sublime/`                      |
| `git/delta.astrodark.gitconfig` | `delta/`                        |

### Patched: re-copy, keep local fix

- `zsh/fzf.astrodark.zsh`: exports `FZF_THEME`.

### Derived: hand-edit from the palette

Each derived file holds its role map in one comment block
(`ccstatusline` uses a `"//"` array): a title line, a legend line, one line per
palette key with full names (`syntax.*` or `ui.*`), then optional `notes:`
lines for rules the file itself does not show. Keep it current and in this
shape:

```zsh
# astrodark theme, derived
# legend: <palette key>: <roles>
# ui.accent: dir
# syntax.green: prompt char, status ok, git clean
# notes: <rule the file itself does not show>
```

- `zsh/`: `p10k.astrodark.zsh`, `fsh.astrodark.ini`, `ls-colors.astrodark.zsh`,
  `lsd.astrodark.yaml`, `broot.conf.toml` `[skin]`, `zshrc.zsh` autosuggest
- `tmux/astrodark.tmux`
- `herdr/config.toml` `[theme.custom]`
- `agents/claude/ccstatusline.settings.json`
