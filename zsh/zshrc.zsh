#####################################
# Oh-My-Zsh Setup

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="refined"
ZSH_THEME="spaceship"

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  vi-mode
  gitfast
  zsh-better-npm-completion
  zsh-completions
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Install brew if needed
if ! [ -x "$(command -v brew)" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Brew shell completion for zsh. Must be set before sourcing oh-my-zsh
if [ -x "$(command -v brew)" ]; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

source $ZSH/oh-my-zsh.sh


#####################################
# User Configuration
#

# reset prompt
DEFAULT_USER=$USER
prompt_context() {}

# lang
export LANG=en_US.UTF-8

# zsh-autosuggestions
# colors https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
# bindkey variables https://unix.stackexchange.com/a/117162
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=248'
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
if ! [ -x "$(command -v fzf)" ]; then
  ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

command -v fd > /dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
command -v bat > /dev/null && command -v tree > /dev/null && export FZF_DEFAULT_OPTS="\
  --bind='?:toggle-preview' \
  --bind='ctrl-u:preview-page-up' \
  --bind='ctrl-d:preview-page-down' \
  --preview-window 'right:60%:hidden' \
  --preview '[[ -d {} ]] && tree -C {} || bat --style=full --color=always {}'"

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
# CTRL-GCTRL-F for files
# CTRL-GCTRL-B for branches
# CTRL-GCTRL-T for tags
# CTRL-GCTRL-R for remotes
# CTRL-GCTRL-M for comMit hashes (had to rebind H due to tmux vim navigation
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
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
  sed 's#^remotes/##'
}

fzf-gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

# for commit hashes
fzf-gm() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
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

bind-git-helper f b t r m
unset -f bind-git-helper

# volta
if ! [ -d "$HOME/.volta" ]; then
  curl https://get.volta.sh | bash
fi
export VOLTA_HOME="$HOME/.volta"
[ -s "$VOLTA_HOME/load.sh" ] && . "$VOLTA_HOME/load.sh"
export PATH="$VOLTA_HOME/bin:$PATH"

# bat
command -v bat > /dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# zsh-spaceship-prompt
# https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Options.md
SPACESHIP_PROMPT_ORDER=(
  dir
  git
  line_sep # next line
  char
)
SPACESHIP_RPROMPT_ORDER=(
  battery
  jobs
  exec_time
)
#SPACESHIP_CHAR_SYMBOL="λ"
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="false"
SPACESHIP_USER_SHOW="false"
SPACESHIP_HOST_SHOW="false"
SPACESHIP_TIME_SHOW="true"
SPACESHIP_EXIT_CODE_SHOW="false"
SPACESHIP_BATTERY_SHOW="true"
SPACESHIP_BATTERY_PREFIX=""
SPACESHIP_BATTERY_SUFFIX="🔋 "
SPACESHIP_BATTERY_THRESHOLD="10"
SPACESHIP_BATTERY_SYMBOL_CHARGING=""
SPACESHIP_BATTERY_SYMBOL_DISCHARGING=""
SPACESHIP_BATTERY_SYMBOL_FULL=""
SPACESHIP_DIR_TRUNC_PREFIX=""
SPACESHIP_DIR_LOCK_SYMBOL="🔒"
SPACESHIP_DIR_TRUNC_REPO="true"
SPACESHIP_JOBS_SYMBOL=""

# .gitconfig
git config --global diff.algorithm histogram
git config --global mergetool.keepBackup false
git config --global rerere.enabled true
git config --global alias.lg !"git log --stat --diff-algorithm=minimal --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
git config --global alias.fadd "!git ls-files -m -o --exclude-standard | fzf --print0 -m | xargs -0 -t -o git add"
command -v delta > /dev/null && git config --global core.pager "delta --dark"


#####################################
# Aliases
#

# git
alias g='git'
alias gs='git status'
alias gap='git add --patch'
alias gcop='git checkout --patch'

# misc
alias l='ls -hall'

# use neovim as vim
if [ -x "$(command -v nvim)" ]; then
  alias vim=nvim
  export EDITOR=nvim
fi

#####################################

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
