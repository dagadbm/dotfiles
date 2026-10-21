# claude-fzf
typeset -g _CLAUDE_FZF_SRC=${${(%):-%x}:A}

_claude_data() {
  local -a catalog=($HOME/.claude/cache/model-catalog/*.json(N.om[1]))
  case $1 in
    catalog) print -r -- $catalog ;;
    models) (( $#catalog )) && jq -r '.catalog.config.models[] | "\(.id)\t\(.name)"' $catalog ;;
    efforts) (( $#catalog )) && jq -r --arg m "$2" '.catalog.config.models[] | select(.id == $m) | .thinking.effort_options[]?.id' $catalog ;;
    sessions)
      local dir="$HOME/.claude/projects/${PWD//[^a-zA-Z0-9]/-}"
      local -a files=($dir/*.jsonl(N.om))
      (( $#files )) || { print -u2 "claude: no sessions for $PWD"; return 1 }

      # description: latest ai-title, else first string user prompt; grep+sed only, jq startup alone is ~0.15s per file
      local title
      for f in $files; do
        title=$(grep -F '"type":"ai-title"' "$f" | tail -n 1 | sed -nE 's/.*"aiTitle":"([^"\\]*).*/\1/p')
        [[ -z $title ]] && title=$(grep -F '"role":"user","content":"' "$f" | grep -v -m 1 -F -e '"content":"<local-command-caveat>' -e '"content":"<local-command-stdout></local-command-stdout>"' | sed -nE 's/.*"role":"user","content":"([^"\\]*).*/\1/p' | sed -E 's#</?(command-name|local-command-stdout)>##g')
        print -r -- "$f"$'\t'"${title:-(no description)}"
      done
      ;;
    *) print -u2 "claude: unknown data $1"; return 1 ;;
  esac
}

claude-fzf() {
  local -a flags=("$@" --permission-mode auto)
  if [[ -z "$(_claude_data catalog)" ]]; then
    command claude "${flags[@]}"
    return
  fi

  local model=$(_claude_data models | fzf --prompt='claude model> ' --height=~40% --no-preview --with-nth '2..' | cut -f1)
  [[ -z "$model" ]] && return

  local -a model_flags=(--model "$model")
  local efforts=$(_claude_data efforts "$model")
  if [[ -n "$efforts" ]]; then
    local effort=$(print -l $efforts | fzf --prompt='claude effort> ' --height=~30% --no-preview)
    [[ -z "$effort" ]] && return
    model_flags+=(--effort "$effort")
  fi

  command claude "${model_flags[@]}" "${flags[@]}"
}

_claude_fzf_resume() {
  local transcript='select(.type=="user" or .type=="assistant") | (.message.content | if type=="string" then . else [.[]? | select(.type=="text") | .text] | join("\n") end | split("\n") | map(select(test("<command-message>|<command-args>") | not) | gsub("</?(command-name|local-command-stdout)>"; "")) | join("\n")) as $t | select($t != "" and ($t | startswith("<local-command-caveat>") | not)) | (if .type=="user" then "## You" else "## Claude" end) + "\n\n" + $t + "\n"'
  local pick=$(
    fzf --prompt='claude session> ' --height=~90% --layout=reverse --delimiter=$'\t' --with-nth=2 \
      --bind "start:reload(zsh -fc 'source $_CLAUDE_FZF_SRC; _claude_data sessions')" \
      --preview="jq -r ${(q)transcript} {1} 2>/dev/null | bat -l md --color=always --style=plain" \
      --preview-window='right:60%:wrap' </dev/null | cut -f1
  )
  [[ -z "$pick" ]] && return
  command claude --resume "${pick:t:r}" --permission-mode auto
}

_claude_fzf_worktree() {
  claude-fzf --worktree
}

_claude() {
  case $1 in
    '') claude-fzf ;;
    r|resume) _claude_fzf_resume ;;
    t|worktree) _claude_fzf_worktree ;;
    *) print -u2 "usage: c [r|resume|t|worktree]"; return 1 ;;
  esac
}
