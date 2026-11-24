#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# The Prompts workflow builds its own prompts (scripts/update in the
# workflow, defaults there)
workflow=macos/alfred-workflows/prompts
update="$workflow/src/prompts.alfredui/scripts/update"

# importable .alfredworkflow (a zip of the workflow folder), built with the
# defaults (no custom prompts) and without my configured values (prefs.plist)
"$update"
out="$PWD/$workflow/Prompts.alfredworkflow"
rm -f "$out"
(cd "$workflow/src" && zip -qr "$out" . -x prefs.plist -x '*.DS_Store')

# then my settings, for the workflow Alfred runs: written to its Configure
# Workflow values (prefs.plist), so ⌘⇧r in Alfred keeps them
# my sources, in place of the defaults
plugins=(
  "claude vercel-labs/agent-skills"
  "claude anthropics/claude-plugins-official superpowers"
  "claude addyosmani/agent-skills agent-skills"
  "claude t3dotgg/tstack"
  "claude cursor/plugins pstack"
  "claude forrestchang/andrej-karpathy-skills"
  "claude anthropics/skills"
  "claude anthropics/claude-plugins-official mattpocock-skills"
)
prompts_plugins="$(printf '%s\n' "${plugins[@]}")"
prompts_custom_dir="$PWD/$workflow/custom"
prompts_custom_name=dagadbm
prefs="$workflow/src/prefs.plist"
plutil -create xml1 "$prefs"
for key in prompts_plugins prompts_custom_dir prompts_custom_name; do
  plutil -insert "$key" -string "${!key}" "$prefs"
done
export prompts_plugins prompts_custom_dir prompts_custom_name
"$update"

# reload workflow
osascript -e 'tell application id "com.runningwithcrayons.Alfred" to reload workflow "com.dagadbm.prompts"'
