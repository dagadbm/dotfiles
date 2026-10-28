# https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html

# Oh-My-Zsh Pre-Setup {{{
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# brew
# references: https://docs.brew.sh/Shell-Completion
if [ -x "$(command -v brew)" ]; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1

# mise
eval "$(mise activate zsh)"

# }}}
# Oh-My-Zsh Setup {{{
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="refined"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy/mm/dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  fzf-tab
  zsh-completions
  zsh-autosuggestions
  forgit
  fast-syntax-highlighting
  # https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/vi-mode/README.md
  vi-mode
)

source $ZSH/oh-my-zsh.sh
# }}}
# Oh-My-Zsh Post-Setup {{{
# history size
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
# ignore duplicates on history
setopt hist_ignore_all_dups

# remove all beeps
unsetopt BEEP

# lang
export LANG=en_US.UTF-8

# vi-mode
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true


# fzf
source "$HOME/fzf.config.zsh"

# zsh-autosuggestions
# colors https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
# bindkey variables https://unix.stackexchange.com/a/117162
# astrodark theme, derived
# legend: <palette key>: <variables set>
# syntax.comment: ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#696C76'
# accept suggestion word by word (ctrl+w)
bindkey '^w' forward-word
# accept all suggestions (ctrl+space)
bindkey '^ ' autosuggest-accept
# execute suggestion (ctrl+e)
bindkey '^e' autosuggest-execute

# LS_COLORS
source "$HOME/.config/shell/ls-colors.astrodark.zsh"

# fzf-tab
# reference: https://github.com/Aloxaf/fzf-tab/wiki/Configuration
# this is needed since fzf overrides ^I
bindkey '^I' fzf-tab-complete
# re-use fzf theme (FZF_THEME defined on fzf.config.zsh)
FZF_TAB_OPTS="$FZF_THEME \
  --layout=reverse \
  --border=none
  --preview-window=hidden"
zstyle ':fzf-tab:*' fzf-flags $(echo "$FZF_TAB_OPTS")
# pop up setting
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size 60 0
zstyle ':fzf-tab:*' popup-smart-tab false
# execute suggestion (ctrl+e)
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-e:accept' 'ctrl-w:accept' ',:toggle-preview'
zstyle ':fzf-tab:*' accept-line ctrl-e
# continuous suggestion (ctrl+w)
zstyle ':fzf-tab:*' continuous-trigger ctrl-w
# groups setup
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:*' single-group header
# remove prefix else its added because of groups
zstyle ':fzf-tab:*' prefix ''
# use ctrl-h to go back and ctrl-l to go forward
zstyle ':fzf-tab:*' switch-group ctrl-h ctrl-l
# previews
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [[ -d $realpath ]]; then
    tre -l 2 --color=always $realpath
  elif [[ -f $realpath ]]; then
      bat --style=plain,numbers --color=always $realpath
  fi'

# zoxide
eval "$(zoxide init zsh)"

# bat
command -v bat > /dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME=astrodark

# lazygit
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/themes/astrodark.yml"

# Aliases {{{
# git
alias lg='lazygit'
alias g='git'
#
# real git blame ignoring moves and refactors
# git blame -w -C -C -C -L 1,100 /path/to/file
#
# find in git log commits/code that contain pattern
# git log -S pattern -p
#
# makes git faster
# git maintenance start
#
# forgit aliases (set by default)
# forgit_add=ga
# forgit_reset_head=grh
# forgit_restore=grs
# forgit_log=glo
# forgit_reflog=grl
# forgit_diff=gd
# forgit_show=gso
# forgit_ignore=gi
# forgit_attributes=gat
# forgit_checkout_file=gcf
# forgit_checkout_file_from_commit=gcff
# forgit_checkout_branch=gcb
# forgit_switch_branch=gsw
# forgit_checkout_commit=gco
# forgit_checkout_tag=gct
# forgit_branch_delete=gbd
# forgit_revert_commit=grc
# forgit_clean=gclean
# forgit_stash_show=gss
# forgit_stash_push=gsp
# forgit_cherry_pick=gcp
# forgit_rebase=grb
# forgit_fixup=gfu
# forgit_squash=gsq
# forgit_reword=grw
# forgit_blame=gbl
forgit_worktree=gt
forgit_worktree_add=gta
forgit_worktree_delete=gtd

# utils
alias restart='exec zsh'
alias l='lsd -hal'
# restores tmux without creating an empty session on startup
alias tmux-restore='pgrep -vxq tmux && tmux new -d -s tmp && tmux run-shell "$HOME/.tmux/plugins/tmux-resurrect/scripts/restore.sh" && tmux kill-session -t tmp && tmux attach || tmux attach'
alias t="tmux-restore"

# alternatives
alias ls='lsd'
alias du='dust'
alias cat='bat'
alias cloc='tokei'
alias top='btm'
alias htop='zenith'
alias tldr='tealdeer'
alias tree='tre'
alias mkdn='glow'

# neovim
## distros
alias avim='NVIM_APPNAME=nvim-astrovim command nvim'
alias lvim='NVIM_APPNAME=nvim-lazyvim command nvim'
alias dvim='NVIM_APPNAME=nvim-dagadbm command nvim'
alias vvim='NVIM_APPNAME=nvim command nvim'

## default
export NVIM_APPNAME="nvim-astrovim"
export EDITOR="nvim"
export GIT_EDITOR="nvim"

alias vim="nvim"
alias vi="nvim"
alias v="nvim"

nvim-fzf() {
  local distros=($HOME/.config/nvim-*(N:t:s/nvim-//))

  if [[ -z "$distros" ]]; then
    command nvim "$@"
    return
  fi

  local distro=$(print -l $distros | fzf --prompt='nvim distro> ' --height=~30% --no-preview)
  if [[ -n "$distro" ]]; then
    NVIM_APPNAME="nvim-$distro" command nvim "$@"
  fi
}

alias nvims="nvim-fzf"
alias vims="nvim-fzf"
alias vis="nvim-fzf"
alias vs="nvim-fzf"

## bob
export PATH="$HOME/Library/Application Support/bob/nvim-bin:$PATH"

# broot
source "$HOME/.config/broot/launcher/zsh/br"

# herdr
alias h=herdr

# nightshift
source "$HOME/.config/shell/nightshift.zsh"

alias n=nightshift

#claude
typeset -ga CLAUDE_FZF_CMD=(cave claude)
source "$HOME/.config/shell/claude-fzf.zsh"

alias c="_claude"
alias cr='_claude_fzf_resume'
alias ct='_claude_fzf_worktree'

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
[[ -f "$HOME/.config/shell/p10k.mise.zsh" ]] && source "$HOME/.config/shell/p10k.mise.zsh"
[[ -f "$HOME/.config/shell/p10k.astrodark.zsh" ]] && source "$HOME/.config/shell/p10k.astrodark.zsh"
# }}}}}}
source "$HOME/zshrc.work.zsh"
