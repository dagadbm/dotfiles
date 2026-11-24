# shellcheck shell=bash
# Shared by the scripts that read or write the prompt sources (sourced)

# Alfred does not load the shell profile: git and jq from Homebrew
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
# a missing repo fails instead of asking for a login
export GIT_TERMINAL_PROMPT=0

# the ⌘⇧. settings: plugins (saved sources), draft (the sheet's text),
# found.json (the last lookup)
data="$HOME/Library/Application Support/Alfred/Workflow Data/com.dagadbm.prompts"

# _parse <line>: sets repo, ref, path, pattern and plugin from a source line
# (a comment or blank line leaves repo empty). Forms:
# - [https://github.com/]<owner>/<repo>[.git]: a repo; a Claude marketplace
#   gives every plugin, else its skills
# - ... <plugin> or ...::<plugin>: one plugin of a marketplace
# - [https://github.com/]<owner>/<repo>/tree/<ref>/<path>, or
#   <owner>/<repo>/<path>, each optionally :<pattern>: Markdown files
_parse() {
  local line="${1%%#*}" src rest
  repo="" ref="" path="" pattern="" plugin=""
  read -r src plugin _ <<<"$line" || true
  [[ -n "${src:-}" ]] || return 0
  if [[ "$src" == *::* ]]; then
    plugin="${src#*::}"
    src="${src%%::*}"
  fi
  src="${src#https://}"
  src="${src#http://}"
  src="${src#github.com/}"
  src="${src%/}"
  if [[ "$src" == *:* ]]; then
    pattern="${src#*:}"
    src="${src%%:*}"
  fi
  src="${src%.git}"
  repo="$(cut -d/ -f1-2 <<<"$src")"
  rest="${src#"$repo"}"
  rest="${rest#/}"
  if [[ "$rest" == tree/* || "$rest" == blob/* ]]; then
    rest="${rest#*/}"
    ref="${rest%%/*}"
    [[ "$rest" == */* ]] && rest="${rest#*/}" || rest=""
  fi
  path="$rest"
}

# _clone <url> <dir> [ref] [sha]
_clone() {
  git clone --quiet --filter=blob:none ${3:+--branch "$3"} "$1" "$2" || return
  if [[ -n "${4:-}" ]]; then
    git -C "$2" checkout --quiet "$4"
  fi
}

# The settings sheet's right pane, "side": the looked-up plugins (a dataview)
# or a note (a markdownarea: help, test results, errors), swapped with replace.
# $data/pane remembers which, for ⌘⇧h to toggle; the caller writes it.
# A replaced component brings its own constraints.
side_constraints='{"grid": {"col": 1, "row": 1}, "size": {"width": 560, "height": 448}}'


# _pane_list: the looked-up rows, ☑ when the draft has them
_pane_list() {
  jq -c --rawfile text "$data/draft" --argjson c "$side_constraints" '($text | split("\n")) as $lines | {
    constraints: $c, type: "dataview", id: "side",
    placeholder: "Look up a repo to pick its plugins here, ⌘⇧h for help",
    data: {type: "basic", src: [.[] | {
      uid: .line,
      "name.text": ((if (.line | IN($lines[])) then "☑ " else "☐ " end) + .name),
      "description.text": .description
    }]},
    cell: {
      height: 56,
      init: {"cell.background": null},
      selected: {"cell.background": "alfredSelectedResultBackgroundColor"},
      root: {
        id: "cell", type: "view", layout: "flex", cols: 1, rows: 2, padding: 8, cornerradius: 8,
        events: [{triggers: "doubleclicked",
          action: {type: "script", src: "scripts/settings-toggle", args: "{data:uid}"}}],
        components: [
          {constraints: {grid: {row: 0, col: 0}}, id: "name", type: "label", font: {size: 16}},
          {constraints: {grid: {row: 1, col: 0}}, id: "description", type: "label", colour: "secondaryLabelColor"}
        ]
      }
    }
  }' "$data/found.json"
}

# _pane_note <markdown>: a note in the pane
_pane_note() {
  jq -nc --arg text "$1" --argjson c "$side_constraints" \
    '{constraints: $c, type: "markdownarea", id: "side", text: $text}'
}

# _pane <component json> [update json]: the action that shows it
_pane() {
  jq -nc --argjson side "$1" --argjson update "${2:-{\}}" \
    '{replace: {ids: {side: $side}}} + (if $update == {} then {} else {update: $update} end)'
}
