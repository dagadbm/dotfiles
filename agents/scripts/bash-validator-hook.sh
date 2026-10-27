#!/bin/bash
# PreToolUse hook for Bash. Complements the permissions in
# agents/claude/settings.json, whose Read() denies do not cover shell reads and
# whose Bash() rules only match command prefixes, not pipes or arguments.
# block: exit 2, the command never runs. ask: forces a permission prompt, even
# in auto mode.

if ! input=$(jq -e . 2>&1); then
  echo "Error: Invalid JSON input: $input" >&2
  exit 1
fi

# Only validate Bash commands
[ "$(jq -r '.tool_name // ""' <<<"$input")" = "Bash" ] || exit 0

command=$(jq -r '.tool_input.command // ""' <<<"$input")
[ -n "$command" ] || exit 0

# word boundary before a command name: start, whitespace or ; & | ( `
start='(^|[[:space:];&|(`])'

block() {
  echo "SECURITY BLOCK: $1" >&2
  exit 2
}

ask() {
  jq -n --arg reason "$1" '{hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "ask",
    permissionDecisionReason: $reason
  }}'
  exit 0
}

matches() {
  grep -Eq -- "$1" <<<"$command"
}

# destructive deletes
if matches "${start}rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r)([^[:alnum:]_]|$)"; then
  block "rm -rf is blocked. Use explicit rm commands with specific file paths."
fi
if matches "${start}rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*[[:space:]]+[/~]"; then
  block "Recursive deletion at root/home level is blocked."
fi

# privilege escalation and disk/permission wrecking
if matches "${start}(sudo|doas|su)[[:space:]]"; then
  block "Privilege escalation is blocked. Ask the user to run it."
fi
if matches "${start}(mkfs[.[:alnum:]]*|diskutil[[:space:]]+(erase|partition|zero))|${start}dd[[:space:]].*of=/dev/"; then
  block "Disk formatting or raw device writes are blocked."
fi
if matches "${start}chmod[[:space:]]+(-[a-zA-Z]*R[a-zA-Z]*[[:space:]]+)?0?777"; then
  block "chmod 777 is blocked."
fi

# remote code execution: download piped into an interpreter
if matches "${start}(curl|wget)[[:space:]].*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z|fi)?sh([[:space:]]|$)|${start}(curl|wget)[[:space:]].*\|[[:space:]]*(python3?|node|perl|ruby)([[:space:]]|$)"; then
  block "Piping a download into an interpreter is blocked. Download, read, then run."
fi

# secrets: the Read() denies in settings.json do not stop cat/grep/sed/...
# .env.example/.sample/.template are not secrets; .envrc (direnv) often is
secrets='(\.env(rc|[.][a-zA-Z0-9_-]+)?|\.ssh/|id_(rsa|ed25519|ecdsa|dsa)|\.pem|\.p12|\.pfx|\.ppk|\.gpg|\.aws/credentials|\.azure/|gcloud/|\.kube/config|\.netrc|\.npmrc|\.pypirc|\.pgpass|\.my\.cnf|\.git-credentials|\.docker/config\.json|\.(bash|zsh)_history|vault_pass|secrets\.(ya?ml|json)|credentials\.json|\.tfstate|\.jks|\.keystore)([[:space:]"'"'"'/;|&)]|$)'
if grep -Eo -- "$secrets" <<<"$command" | grep -Evq '^\.env\.(example|sample|template)'; then
  ask "Command references a secret file."
fi
if matches "${start}security[[:space:]]+(find|dump)-|${start}(printenv|env)([[:space:]]*$|[[:space:]]*\|)"; then
  ask "Command reads the keychain or the full environment."
fi

# exfiltration: uploading local files
if matches "${start}(curl|wget)([[:space:]].*)?([[:space:]](-d|--data[a-z-]*|-F|--form)[[:space:]]*['\"]?[^[:space:]]*@|[[:space:]](-T|--upload-file|--post-file)[[:space:]=])"; then
  ask "Command uploads a local file."
fi
if matches "${start}(scp|rsync|sftp|nc|ncat|netcat)[[:space:]]"; then
  ask "Command transfers data over the network."
fi

# git history loss
if matches "${start}git[[:space:]]+push([[:space:]].*)?([[:space:]]--force([[:space:]]|$)|[[:space:]]-[a-zA-Z]*f([[:space:]]|$)|[[:space:]]\+[^[:space:]]+)"; then
  ask "Force push rewrites remote history."
fi
if matches "${start}git[[:space:]]+(reset[[:space:]]+--hard|clean[[:space:]]+-[a-zA-Z]*f|checkout[[:space:]]+(--[[:space:]]+)?\.([[:space:]]|$)|restore[[:space:]]+(--[a-z]+[[:space:]]+)*\.([[:space:]]|$)|stash[[:space:]]+(drop|clear)|branch[[:space:]]+-D|filter-branch|filter-repo)"; then
  ask "Command discards uncommitted work or rewrites history."
fi

exit 0
