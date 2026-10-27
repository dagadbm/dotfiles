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
`$AT/extras/<tool>/*.astrodark.*`.

### Vendored: re-copy the extra unchanged

- `ghostty/themes/` from `ghostty/`
- `wezterm/colors/` from `wezterm/`
- `helix/themes/` from `helix/`
- `lazygit/themes/` from `lazygit/`
- `bat/themes/` from `sublime/`
- `git/delta.astrodark.gitconfig` from `delta/`

### Derived: hand-edit from the palette

- `zsh/`: `p10k.astrodark.zsh`, `fzf.astrodark.zsh`, `fsh.astrodark.ini`,
  `ls-colors.astrodark.zsh`, `lsd.astrodark.yaml`, `broot.conf.toml` `[skin]`,
  `zshrc.zsh` autosuggest
- `tmux/astrodark.tmux`
- `herdr/config.toml` `[theme.custom]`
- `agents/claude/ccstatusline.settings.json`

Each file keeps its changes in one comment block starting with
`astrodark theme, derived`:

```zsh
# astrodark theme, derived
# legend: <palette key>: <variables set>
# ui.base: fzf_bg, fzf_gutter
# syntax.blue: fzf_hl, fzf_prompt
# notes: <changes that are not obvious from reading the file>
```
