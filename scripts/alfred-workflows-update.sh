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
# my sources: the defaults plus my own
prompts_plugins="$("$(dirname "$update")/plugins")
t3dotgg/tstack
anthropics/skills claude-api
anthropics/skills academy-guide
anthropics/skills discernment-nudge"
prompts_custom_dir="$PWD/$workflow/custom"
prompts_custom_name=dagadbm
prefs="$workflow/src/prefs.plist"
plutil -create xml1 "$prefs"
for key in prompts_plugins prompts_custom_dir prompts_custom_name; do
  plutil -insert "$key" -string "${!key}" "$prefs"
done
export prompts_plugins prompts_custom_dir prompts_custom_name
"$update"
