# Dotfiles

Personal macOS dev environment. Each tool owns a top-level directory; Dotbot symlinks its files into `~` per `dotbot.conf.yaml`, the single source of truth for what lands where. Third-party code lives in `submodules/`.

## Rules

- Trust Dotbot: files in `dotbot.conf.yaml` are already symlinked into `~`, so edit and search only inside this repo and never inspect or diff `~`.
- Always run `./dotbot.sh` after you add, remove, or rename an entry in `dotbot.conf.yaml`.
- Paths in `dotbot.conf.yaml` are repo-relative.
- Submodules are read-only: update them with `./submodules-update.sh`.
- Ask first before: changing submodule refs, editing multi-profile files (`git/gitconfig*`, `ssh/config`, `zsh/zshrc.work.zsh`), running `./update.sh` or `./submodules-update.sh`, adding a top-level directory.

## Commands

```bash
./dotbot.sh                          # relink after changing dotbot.conf.yaml
./update.sh                          # update everything (ask first)
./nvim-update.sh                     # update Neovim, LSP, plugins
./herdr-update.sh                    # update herdr
./submodules-update.sh               # update submodules (ask first)
./brew-update.sh                     # update Homebrew
./mise-update.sh                     # update mise
./prune.sh                           # prune everything (brew + mise)
./brew-prune.sh                      # prune Homebrew to match Brewfile
./mise-prune.sh                      # prune mise
./macos/defaults.sh                  # apply macOS preferences
```

## Validation

Validate the thing you changed, not the links:

- Zsh: `zsh -n zsh/zshrc.zsh`, then `zsh -i -c 'echo ok'`.
- Neovim: `NVIM_APPNAME=nvim-<distro> nvim --headless +q` (distro = `dagadbm`, `lazyvim`, `astrovim`).
- Brewfile: `brew bundle check --file=macos/Brewfile`.

## Layout Gotchas

- `neovim/` holds several configs side by side, each linked to `~/.config/nvim-<name>` and picked with `NVIM_APPNAME`. `dagadbm/` is the legacy hand-rolled config; `lazyvim/` and `astrovim/` are distros (customise via their `lua/plugins/`).
- Multi-profile (personal/work): `git/gitconfig` plus `gitconfig_personal` / `gitconfig_work`, `ssh/config` plus `ssh/personal` / `ssh/work`, and `zsh/zshrc.work.zsh`.
- Zsh entry points: `zsh/zshrc.zsh` (interactive), `zsh/zprofile.zsh` (login). oh-my-zsh + Powerlevel10k; runtimes via mise.
- `submodules/` holds tools and zsh plugins not installed via Homebrew, linked by `dotbot.conf.yaml`. Managed by `submodules-update.sh`.

## Git Submodules
### Add
```bash
git submodule add https://github.com/wfxr/forgit.git submodules/forgit
```
### Delete
```bash
export MODULE=submodules/repo_name && git submodule deinit -f $MODULE && rm -rf .git/modules/$MODULE && git rm -f $MODULE
```

## Themes: astrodark

Every tool uses astrodark from the astrotheme Neovim plugin. Take colours from upstream; don't invent hex values.

Upstream sources:

- Palette: `~/.local/share/nvim-astrovim/lazy/astrotheme/lua/astrotheme/palettes/astrodark.lua`
- Extras: `~/.local/share/nvim-astrovim/lazy/astrotheme/extras/<tool>/*.astrodark.*` (no zsh extra; use `fish/` as reference)

When upstream changes:

- Re-copy astrodark file only from extras: `ghostty/themes/`, `wezterm/colors/`, `helix/themes/`, `lazygit/themes/`, `tmux/themes/`, `bat/themes/` (from `sublime/`).
- Re-copy but keep local fixes: `zsh/fzf.astrodark.zsh` (exports `FZF_THEME`), `git/delta.astrodark.gitconfig` (keep blended diff backgrounds; see header comment)
- Update by hand from the palette: `zsh/p10k.astrodark.zsh`, `zsh/fsh.astrodark.ini` (mapped from `fish/astrodark.fish`), `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` in `zsh/zshrc.zsh`, statusline and battery colours in `tmux/tmux.conf`, `[theme.custom]` in `herdr/config.toml`.
