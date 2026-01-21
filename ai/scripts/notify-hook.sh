#!/bin/bash

cli_tool_name="$1"
message_override="$2"

case "$cli_tool_name" in
  "gemini")
    cli_name="Gemini CLI"
    group_name="gemini"
    default_message="Gemini CLI needs attention"
    ;;
  "claude")
    cli_name="Claude Code"
    group_name="claude"
    default_message="Claude Code needs attention"
    ;;
  *)
    exit 1
    ;;
esac

message="${message_override:-$default_message}"
input=$(cat)

case "$cli_tool_name" in
  "gemini")
    cwd=$(echo "$input" | jq -r '.session.cwd')
    ;;
  "claude")
    cwd=$(echo "$input" | jq -r '.cwd')
    ;;
esac

if [[ -z "$cwd" || "$cwd" == "null" ]]; then
  exit 1
fi

project=$(basename "$cwd")

pane_info=$(tmux list-panes -a -F '#{pane_current_path}|#{session_name}' | grep "^$cwd|" | head -1)

if [[ -n "$pane_info" ]]; then
  session=$(echo "$pane_info" | cut -d'|' -f2)

  terminal-notifier \
    -title "$cli_name 📁 $project 📺 $session" \
    -message "$message" \
    -group "$group_name-$project" \
    -activate com.github.wez.wezterm
else
  terminal-notifier \
    -title "$cli_name: 📁 $project" \
    -message "$message" \
    -activate com.github.wez.wezterm
fi
