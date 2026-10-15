# Dotfiles

Personal macOS dev environment. Each tool owns a top-level directory; Dotbot symlinks its files into `~` per `dotbot.conf.yaml` (repo-relative paths), the single source of truth for what lands where. Third-party code lives in `submodules/`.

## Rules

- Work only inside this repo; Dotbot already mirrors it into `~`.
- Run `./dotbot.sh` after you add, remove, or rename an entry in `dotbot.conf.yaml`.
- Treat `submodules/` as read-only; change it only through `./submodules-update.sh`.
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

### Submodules

```bash
# Add submodule:
git submodule add https://github.com/wfxr/forgit.git submodules/forgit

# Delete submodule (destructive, ask first):
export MODULE=submodules/repo_name && git submodule deinit -f $MODULE && rm -rf .git/modules/$MODULE && git rm -f $MODULE
```

## Validation

- Zsh: `zsh -n zsh/zshrc.zsh`, then `zsh -i -c 'echo ok'`.
- Shell scripts: `bash -n *.sh macos/*.sh`, then `shellcheck -S warning *.sh macos/*.sh`.
- TOML: `taplo check $(git ls-files '*.toml')`.
- YAML (no Python `yaml` module; use Ruby): `ruby -ryaml -e 'ARGV.each{|f| YAML.load_file(f)}' lazygit/config.yml zsh/lsd.config.yaml zsh/lsd.astrodark.yaml`.
- Git config: `git config -f git/gitconfig --list >/dev/null`.
- tmux: `tmux -L t -f tmux/tmux.conf start-server \; kill-server` (no output = ok).
- AppleScript: `osacompile -o /dev/null ghostty/startup.applescript`.
- mise: `mise doctor`.
- Neovim: `NVIM_APPNAME=nvim-<distro> nvim --headless +q` (distro = `dagadbm`, `lazyvim`, `astrovim`).
- Brewfile: `brew bundle check --file=macos/Brewfile`.

## Layout Gotchas

- `neovim/` holds several configs side by side, each linked to `~/.config/nvim-<name>` and picked with `NVIM_APPNAME`. `dagadbm/` is the legacy hand-rolled config; `lazyvim/` and `astrovim/` are distros (customise via their `lua/plugins/`).
- Multi-profile (personal/work): `git/gitconfig` plus `gitconfig_personal` / `gitconfig_work`, `ssh/config` plus `ssh/personal` / `ssh/work`, and `zsh/zshrc.work.zsh`.
- Zsh entry points: `zsh/zshrc.zsh` (interactive), `zsh/zprofile.zsh` (login). oh-my-zsh + Powerlevel10k.
- `submodules/` holds tools and zsh plugins not installed via Homebrew, linked by `dotbot.conf.yaml`.


## Custom Themes: astrodark

Every tool uses astrodark from the astrotheme Neovim plugin. Take every colour from upstream sources:

- Palette: `~/.local/share/nvim-astrovim/lazy/astrotheme/lua/astrotheme/palettes/astrodark.lua`
- Extras: `~/.local/share/nvim-astrovim/lazy/astrotheme/extras/<tool>/*.astrodark.*` (no zsh extra; use `fish/` as reference)

When upstream changes, update by class:

- **Vendored**: re-copy the extras file unchanged into `ghostty/themes/`, `wezterm/colors/`, `helix/themes/`, `lazygit/themes/`, `tmux/themes/`, `bat/themes/` (from `sublime/`).
- **Patched**: re-copy, then keep local fixes: `zsh/fzf.astrodark.zsh` (exports `FZF_THEME`), `git/delta.astrodark.gitconfig` (keep blended diff backgrounds; see header comment).
- **Derived**: edit by hand from the palette. Every other `*astrodark*` file (e.g. `zsh/p10k.astrodark.zsh`, `zsh/fsh.astrodark.ini` mapped from `fish/astrodark.fish`), plus colours embedded in other files: `skin` in `zsh/broot.conf.toml`, `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` in `zsh/zshrc.zsh`, statusline and battery in `tmux/tmux.conf`, `[theme.custom]` in `herdr/config.toml`.
