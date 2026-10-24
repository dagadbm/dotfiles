#!/bin/bash

if ! input=$(jq -e . 2>&1); then
  echo "Error: Invalid JSON input: $input" >&2
  exit 1
fi

# Only validate Bash commands
[ "$(jq -r '.tool_name // ""' <<<"$input")" = "Bash" ] || exit 0

command=$(jq -r '.tool_input.command // ""' <<<"$input")
[ -n "$command" ] || exit 0

block() {
  echo "SECURITY BLOCK: $1" >&2
  exit 2
}

# Block rm -rf / rm -r -f patterns
if grep -Eq '(^|[^[:alnum:]_])rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r)([^[:alnum:]_]|$)' <<<"$command"; then
  block "rm -rf is blocked. Use explicit rm commands with specific file paths."
fi

# Block rm -r at root/home level
if grep -Eq '(^|[^[:alnum:]_])rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*[[:space:]]+[/~]' <<<"$command"; then
  block "Recursive deletion at root/home level is blocked."
fi

exit 0
