# Dotfiles

Personal macOS dev environment. Each tool owns a top-level directory; Dotbot
symlinks its files into `~` per `dotbot.conf.yaml` (repo-relative paths), the
single source of truth for what lands where. Third-party code lives in
`submodules/`.

## Rules

- Work only inside this repo; Dotbot already mirrors it into `~`.
- Run `mise run dotbot` after you add, remove, or rename an entry in
  `dotbot.conf.yaml`.
- Treat `submodules/` as read-only; change it only through
  `mise run submodules:update`.
- Ask first before: changing submodule refs, editing multi-profile files
  (`git/gitconfig*`, `ssh/config`, `zsh/zshrc.work.zsh`), running
  `mise run update` or `mise run submodules:update`, adding a top-level
  directory.

## Commands

```bash
mise tasks                                # list tasks (mise.toml runs scripts/*.sh)
mise run                                  # pick a task interactively
mise run dotbot                           # relink after changing dotbot.conf.yaml
mise run update                           # update everything
mise run nvim:update                      # update Neovim, LSP, plugins
mise run herdr:update                     # update herdr
mise run claude:update                    # update agent tooling
mise run submodules:update                # update submodules
mise run brew:update                      # update Homebrew
mise run mise:update                      # update mise
mise run prune                            # prune everything
mise run brew:prune                       # prune Homebrew to match Brewfile
mise run mise:prune                       # prune mise
mise run claude:prune                     # prune claude to match scripts/claude-update.sh
mise run macos:defaults                   # apply macOS preferences
mise run macos:print-admin-commands      # print admin commands (full-disk-access)
mise run lint                             # lint all configs and scripts
```

### Submodules

```bash
# Add submodule:
git submodule add https://github.com/wfxr/forgit.git submodules/forgit

# Delete submodule (destructive, ask first):
export MODULE=submodules/repo_name && \
  git submodule deinit -f $MODULE && \
  rm -rf .git/modules/$MODULE && \
  git rm -f $MODULE
```

## Validation

- Run `mise run lint` after changes.

## Layout Gotchas

- `neovim/` holds several configs side by side, each linked to
  `~/.config/nvim-<name>` and picked with `NVIM_APPNAME`. `dagadbm/` is the
  legacy hand-rolled config; `lazyvim/` and `astrovim/` are distros (customise
  via their `lua/plugins/`).
- Multi-profile (personal/work): `git/gitconfig` plus `gitconfig_personal` /
  `gitconfig_work`, `ssh/config` plus `ssh/personal` / `ssh/work`, and
  `zsh/zshrc.work.zsh`.
- `scripts/` holds repo scripts, run as tasks from `mise.toml`. Each sources
  `scripts/utils.sh` (cd to repo root, shared helpers); `*-prune.sh` also source
  `scripts/prune-utils.sh`. `bootstrap.sh` runs directly, before mise exists.
- Zsh entry points: `zsh/zshrc.zsh` (interactive), `zsh/zprofile.zsh` (login).
  oh-my-zsh + Powerlevel10k.
- `submodules/` holds tools and zsh plugins not installed via Homebrew, linked
  by `dotbot.conf.yaml`.

## Custom Themes: astrodark

Every tool uses astrodark from the astrotheme Neovim plugin. Take every colour
from upstream sources:

- Palette:
  `~/.local/share/nvim-astrovim/lazy/astrotheme/lua/astrotheme/palettes/astrodark.lua`
- Extras:
  `~/.local/share/nvim-astrovim/lazy/astrotheme/extras/<tool>/*.astrodark.*` (no
  zsh extra; use `fish/` as reference)

When upstream changes, update by class:

### Vendored

Re-copy the extras file unchanged into `ghostty/themes/`, `wezterm/colors/`,
`helix/themes/`, `lazygit/themes/`, `bat/themes/` (from `sublime/`), `git/`
(`delta.astrodark.gitconfig`, from `delta/`; keep the two-line header).

### Patched

Re-copy, then keep local fixes:

- `zsh/fzf.astrodark.zsh`: exports `FZF_THEME`.

### Derived

Edit by hand from the palette, by role. Use `syntax.*` hexes unless noted.

- `zsh/p10k.astrodark.zsh` (named locals at top, each commented with its key):
  dir `ui.accent`, anchor `blue`, shortened `comment`; ruler/gap `ui.border`;
  prompt char and status ok `green`, error `red`; git meta `text`, clean
  `green`, modified `yellow`, untracked `blue` (`P10K_GIT_*`; the
  `VCS_UNTRACKED_FOREGROUND` icon is `green`), conflicted `red`, loading `mute`;
  exec time `yellow`; bg jobs `cyan`; time and todo/task `comment`; context
  `text`, root `red`; mise runtimes and cloud segments one hue each (see file).
- `zsh/fsh.astrodark.ini`: mapped from `fish/astrodark.fish` (mapping in header
  comment); commands/builtins/aliases `cyan`, reserved words and options
  `purple`, quotes `yellow`, separators `orange`, variables/globs/brackets
  `green`, redirection `text`, errors `red`, comments `comment`;
  here-string/paired-bracket backgrounds `ui.selection`.
- `zsh/ls-colors.astrodark.zsh` (palette as `38;2;R;G;B`): dirs (incl.
  sticky/other-writable) bold `blue`, symlinks `cyan`, broken links `red`,
  sockets/pipes/devices `yellow`, executables bold `green`, setuid/setgid bold
  `orange`; by extension: archives `red`, media `purple`, config/data `yellow`,
  docs `text`, logs/backups `comment`.
- `zsh/lsd.astrodark.yaml` (palette as `rgb_(R,G,B)`): user `blue`, group
  `comment`; perms read `green`, write `yellow`, exec `red`, sticky `purple`,
  octal/acl `cyan`; dates hour `green`, day `cyan`, older `comment`; sizes
  small/medium/large `green`/`yellow`/`orange`; links/inodes `purple`; git new
  `green`, modified/typechange `yellow`, renamed `cyan`, deleted/conflicted
  `red`; tree edges `ui.border`; empty/none/invalid/unmodified `mute`.
- `zsh/zshrc.zsh`: `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` is `comment` (fish
  `fish_color_autosuggestion`).
- `zsh/broot.conf.toml` `[skin]` (`rgb(R, G, B)`): default/input `text` over
  `comment` when unfocused; tree `ui.border`; dirs bold `blue`; exe `green`;
  links `cyan`; pruning/`perm__` `mute`; perms r `yellow`, w `red`, x `green`;
  owner/group `yellow`; dates `comment`; git branch `purple`,
  insertions/staged/new `green`, modified `yellow`, deletions/conflicted `red`,
  current/ignored `mute`; matches `green`/`yellow` bold; flags `comment` label,
  `purple` value; count `cyan` on `ui.current_line`; selected line bg
  `ui.selection` (unfocused `ui.current_line`); status bar bg `ui.statusline`.
- `tmux/tmux.conf` (`%hidden` vars): bar `ui.statusline`, accent `ui.accent`,
  text on accent `ui.base`, segments `ui.selection`, inactive windows
  `ui.text_inactive`, prefix/copy prompt fill `ui.yellow`; battery tiers 8..1
  alternate `syntax`/`ui` of green, yellow, orange, red (e.g. `syntax.green`,
  `ui.green`), charging `syntax.green`, discharging `syntax.yellow`, attached
  `ui.accent`, unknown `ui.text`.
- `herdr/config.toml` `[theme.custom]`: accent `ui.accent`; panel/sidebar
  `ui.base`; active row `ui.current_line`; selection `ui.selection`; surface0
  `ui.statusline`, surface1 `ui.border`, surface_dim `ui.float`; overlay0
  `mute`, overlay1 and subtext0 `text`, text `ui.text`; mauve `purple`, teal
  `cyan`, peach `orange`, green/yellow/red/blue same-name `syntax.*`.
- `agents/claude/ccstatusline.settings.json`: `hex:RRGGBB` colours (need
  `colorLevel: 3`). One hue per group, never shared; red reserved for
  errors/warnings; widgets cannot colour by threshold; a label takes its value's
  colour. Model (bold) and thinking-effort `ui.accent`; context-length,
  context-percentage, compaction-counter (dim) `orange`; tokens-* `cyan`;
  cache-* `#38928A`; session-usage, reset-timer, weekly-usage,
  weekly-reset-timer `purple`; git-branch, worktree-branch `green`;
  current-working-dir `#659047`; git-changes `yellow` (as p10k clean/modified);
  clock (custom-command `date`) `text`; separators `mute` (line 3 dir separator
  `ui.border`; line 2 separators, incl. `|`, set none). `#38928A`/`#659047` are
  `cyan`/`green` 25% darker: each RGB channel x0.75, rounded; re-derive from the
  new base hex. Labels on tokens-cached and cache-hit-rate use Nerd Font bolt
  U+F0E7 (private-use, JetBrainsMono Nerd Font Mono) plus a trailing space so it
  does not overlap the value.
