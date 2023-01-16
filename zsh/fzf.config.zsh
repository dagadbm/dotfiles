# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use Ctrl-Z to cd to a different directory using fzf! (similar to using z)
bindkey '^Z' fzf-cd-widget
# Use Ctrl-F to print files using fzf (same as Ctrl-T)
bindkey '^F' fzf-file-widget
# Use Ctrl-R for backward search with fzf
bindkey '^R' fzf-history-widget

# current theme: onedark
# references: https://github.com/junegunn/fzf/blob/master/ADVANCED.md#generating-fzf-color-theme-from-vim-color-schemes
# let g:fzf_colors = {
#   'fg':         ['fg', 'Normal'],
#   'fg+':        ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
#   'bg':         ['bg', 'Normal'],
#   'bg+':        ['bg', 'CursorLine', 'CursorColumn'],
#   'hl':         ['fg', 'Comment'],
#   'hl+':        ['fg', 'Statement'],
#   'info':       ['fg', 'PreProc'],
#   'marker':     ['fg', 'Keyword'],
#   'prompt':     ['fg', 'Conditional'],
#   'spinner':    ['fg', 'Label'],
#   'pointer':    ['fg', 'Exception'],
#   'border':     ['fg', 'Ignore'],
#   'header':     ['fg', 'Comment'] }
#   'preview-bg': ['bg', 'NormalFloat'],
# https://minsw.github.io/fzf-color-picker/
fzf_fg='#abb2bf'
fzf_fg_plus='#abb2bf'
fzf_bg='#282c34'
fzf_bg_plus='#31353f'
fzf_hl='#5c6370'
main_accent_color='#c678dd'; # purple
# main_accent_color='#99c379' # green
fzf_hl_plus=$main_accent_color
fzf_info=$main_accent_color
fzf_marker=$main_accent_color
fzf_prompt=$main_accent_color
fzf_spinner=$main_accent_color
fzf_pointer=$main_accent_color
fzf_header='#5c6370'
# fzf_preview_bg='#31353f'
fzf_preview_bg='-1'

export FZF_THEME=" \
  --color=fg:$fzf_fg,bg:$fzf_bg,hl:$fzf_hl \
  --color=fg+:$fzf_fg_plus,bg+:$fzf_bg_plus,hl+:$fzf_hl_plus \
  --color=info:$fzf_info,prompt:$fzf_prompt,pointer:$fzf_pointer \
  --color=marker:$fzf_marker,spinner:$fzf_spinner,header:$fzf_header,preview-bg:$fzf_preview_bg"

export FZF_DEFAULT_OPTS="$FZF_THEME \
  --layout=reverse \
  --border \
  --height=~50% \
  --bind=',:toggle-preview' \
  --bind='ctrl-p:half-page-up' \
  --bind='ctrl-n:half-page-down' \
  --bind='ctrl-u:preview-page-up' \
  --bind='ctrl-d:preview-page-down' \
  --preview-window='right,60%,wrap' \
  --preview='([[ -d {} ]] && tre -l 2 --color=always {}) || ([[ -f {} ]] && bat --style=plain,numbers --color=always {}) || echo {}'"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'

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
  git branch --sort committerdate -a --color=always | grep -v '/HEAD\s' |
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
