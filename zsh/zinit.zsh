if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "$HOME/.zinit/bin/zinit.zsh"
# Brew shell completion for zsh. Must be set before sourcing oh-my-zsh
if [ -x "$(command -v brew)" ]; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi


# asdf must be sourced before compinit
. $HOME/.asdf/asdf.sh
# fpath=(${ASDF_DIR}/completions $fpath)
# export PATH="$HOME/.asdf/bin:$PATH"
# Hook direnv into your shell.
export DIRENV_LOG_FORMAT=
eval "$(asdf exec direnv hook zsh)"
# set global node version for coc to be the node LTS
export NVIM_COC_NODE_VERSION=12.18.3

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

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

HISTSIZE=999999999
SAVEHIST=$HISTSIZE
# ignore duplicates on history
setopt hist_ignore_all_dups

# remove all beeps
unsetopt BEEP

# lang
export LANG=en_US.UTF-8

# zsh-autosuggestions
# colors https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
# bindkey variables https://unix.stackexchange.com/a/117162
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
# accept suggestion word by word (ctrl+w)
bindkey '^w' forward-word
# accept all suggestions (ctrl+space)
bindkey '^ ' autosuggest-accept
# execute suggestion (ctrl+e)
bindkey '^e' autosuggest-execute

# z
export _Z_DATA=~/.z.datafile
. ~/.z/z.sh

# fzf
source ~/.fzf.zsh

FZF_COMMON_OPTIONS="
  --bind='?:toggle-preview'
  --bind='ctrl-p:half-page-up'
  --bind='ctrl-n:half-page-down'
  --bind='ctrl-u:preview-page-up'
  --bind='ctrl-d:preview-page-down'
  --preview-window 'right:60%:hidden:wrap'
  --preview '([[ -d {} ]] && tree -C {}) || ([[ -f {} ]] && bat --style=full --color=always {}) || echo {}'"

command -v fd > /dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
command -v bat > /dev/null && command -v tree > /dev/null && export FZF_DEFAULT_OPTS="$FZF_COMMON_OPTIONS"
command -v fd > /dev/null && export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
command -v fd > /dev/null && export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'

# Use Ctrl-Z to cd to a different directory using fzf! (similar to using z)
bindkey '^z' fzf-cd-widget
# Use Ctrl-F to print files using fzf (same as Ctrl-T)
bindkey '^f' fzf-file-widget

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# fzf git integration from https://junegunn.kr/2016/07/fzf-git/
# CTRL-G CTRL-F for files
# CTRL-G CTRL-B for branches
# CTRL-G CTRL-T for tags
# CTRL-G CTRL-R for remotes
# CTRL-G CTRL-G for commit hashes
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 40% "$@"
}

fzf-gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

fzf-gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/origin/##'
}

fzf-gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

# for commit hashes
fzf-gg() {
  is_in_git_repo || return
  git log --reflog --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

fzf-gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(fzf-g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}

bind-git-helper f b t r g
unset -f bind-git-helper

# bat
command -v bat > /dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# kubectl
command -v kubectl > /dev/null && source <(kubectl completion zsh)

export PATH=~/.local/bin:$PATH

# git
alias t='tig status'
alias g='git'
alias gs='git status'
alias gap='git add --patch'
alias gcop='git checkout --patch'

# misc
alias l='ls -hal'

alias vi=vim
alias v=vim
# use neovim as vim
if [ -x "$(command -v nvim)" ]; then
  alias vim=nvim
  alias ovim=vim # to use vim type ovim
  export EDITOR=nvim
  export GIT_EDITOR=nvim
fi

# k8s
alias k=kubectl

# restores tmux without creating an empty session on startup
alias tmux-restore='pgrep -vxq tmux && tmux new -d -s tmp && tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh && tmux kill-session -t tmp && tmux attach || tmux attach'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit cdreplay -q # <- execute compdefs provided by rest of plugins
zinit cdlist
### End of Zinit's installer chunk