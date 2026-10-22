# claude-fzf
# launcher command; set CLAUDE_FZF_CMD before sourcing to override
(( $#CLAUDE_FZF_CMD )) || typeset -ga CLAUDE_FZF_CMD=(claude)

# Message filters: what never shows in session titles or previews.
# Messages flagged "isMeta":true (skill bodies, caveats, images, agent messages) are always dropped.
# Plain regexes valid in both awk ERE (titles) and jq (preview).
typeset -g _CLAUDE_FZF_DROP_MESSAGE='^(<local-command-caveat>|<system-reminder>|<task-notification>|<new-diagnostics>|<user-prompt-submit-hook>)' # drop the whole message
typeset -g _CLAUDE_FZF_DROP_LINE='<command-message>' # drop matching lines
typeset -g _CLAUDE_FZF_UNWRAP_TAG='</?(command-name|command-args|local-command-stdout|bash-input|bash-stdout|bash-stderr)>' # remove tag, keep text

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
      local title_key='"aiTitle":"'
      local prompt_key='"role":"user","content":"'
      local titles_awk='
        function emit_until(f) {
          while (next_file <= nfiles) {
            cur = files[next_file++]
            t = (cur in title) ? title[cur] : (cur in prompt) ? prompt[cur] : "(no description)"
            print cur "\t" t
            if (cur == f) break
          }
          fflush()
        }
        function value(line, key) {
          if (!match(line, key "[^\"\\\\]*")) return ""
          return substr(line, RSTART + length(key), RLENGTH - length(key))
        }
        BEGIN { nfiles = split(ENVIRON["CLAUDE_FZF_FILES"], files, "\n"); next_file = 1 }
        {
          i = index($0, ":"); f = substr($0, 1, i - 1); line = substr($0, i + 1)
          if (f != last) { if (last != "") emit_until(last); last = f }
          if (t = value(line, title_key)) { title[f] = t; next }
          if ((f in prompt) || index(line, "\"isMeta\":true")) next
          t = value(line, prompt_key)
          if (t == "" || t ~ drop_message) next
          gsub(unwrap_tag, "", t)
          if (t != "" && t !~ drop_line) prompt[f] = t
        }
        END { emit_until("") }
      '
      rg --no-config -j1 --with-filename --no-line-number --no-heading -F -e "$title_key" -e "$prompt_key" $files |
        CLAUDE_FZF_FILES=${(F)files} awk -v title_key="$title_key" -v prompt_key="$prompt_key" \
          -v drop_message="$_CLAUDE_FZF_DROP_MESSAGE" -v drop_line="$_CLAUDE_FZF_DROP_LINE" -v unwrap_tag="$_CLAUDE_FZF_UNWRAP_TAG" \
          "$titles_awk"
      ;;
    *) print -u2 "claude: unknown data $1"; return 1 ;;
  esac
}

_claude_fzf_default() {
  local -a flags=("$@" --permission-mode auto)
  if [[ -z "$(_claude_data catalog)" ]]; then
    command "${CLAUDE_FZF_CMD[@]}" "${flags[@]}"
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

  command "${CLAUDE_FZF_CMD[@]}" "${model_flags[@]}" "${flags[@]}"
}

_claude_fzf_resume() {
  local transcript_jq='
    select((.type == "user" or .type == "assistant") and .isMeta != true)
    | (.message.content | if type == "string" then . else [.[]? | select(.type == "text") | .text] | join("\n") end) as $raw
    | select($raw | test($drop_message) | not)
    | ($raw | split("\n") | map(select(test($drop_line) | not) | gsub($unwrap_tag; "")) | join("\n")) as $t
    | select($t != "")
    | (if .type == "user" then "## You" else "## Claude" end) + "\n\n" + $t + "\n"
  '
  local preview="jq -r --arg drop_message ${(q)_CLAUDE_FZF_DROP_MESSAGE} --arg drop_line ${(q)_CLAUDE_FZF_DROP_LINE}"
  preview+=" --arg unwrap_tag ${(q)_CLAUDE_FZF_UNWRAP_TAG} ${(q)transcript_jq} {1} 2>/dev/null"
  preview+=" | bat -l md --color=always --style=plain"
  local pick=$(
    _claude_data sessions |
      fzf --prompt='claude session> ' --height=~90% --layout=reverse --delimiter=$'\t' --with-nth=2 \
        --preview="$preview" --preview-window='right:60%:wrap' | cut -f1
  )
  [[ -z "$pick" ]] && return
  command "${CLAUDE_FZF_CMD[@]}" --resume "${pick:t:r}" --permission-mode auto
}

_claude_fzf_worktree() {
  _claude_fzf_default --worktree
}

_claude() {
  case $1 in
    '') _claude_fzf_default ;;
    r|resume) _claude_fzf_resume ;;
    t|worktree) _claude_fzf_worktree ;;
    *) print -u2 "usage: c [r|resume|t|worktree]"; return 1 ;;
  esac
}
