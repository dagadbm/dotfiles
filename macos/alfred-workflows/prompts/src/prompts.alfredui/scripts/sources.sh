# shellcheck shell=bash
# Shared by the scripts that read or write the prompt sources (sourced)

# Alfred does not load the shell profile: git and jq from Homebrew
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
# a missing repo fails instead of asking for a login
export GIT_TERMINAL_PROMPT=0

# the ⌘⇧. settings: plugins (saved sources), draft (the sheet's text),
# found.json (the last lookup)
data="$HOME/Library/Application Support/Alfred/Workflow Data/com.dagadbm.prompts"

# _repo <repo>: sets repo, ref and path from [https://github.com/]<owner>/<repo>
# [.git][@<ref>], a link to a folder (…/tree/<ref>/<path>), or a local folder
# (starting with / or ~, kept as repo)
_repo() {
  local src="$1" rest
  repo="" ref="" path=""
  if [[ "$src" == /* || "$src" == "~"* ]]; then
    repo="${src/#\~/$HOME}"
    repo="${repo%/}"
    return
  fi
  src="${src#https://}"
  src="${src#http://}"
  src="${src#github.com/}"
  src="${src%/}"
  if [[ "$src" == *@* ]]; then
    ref="${src#*@}"
    src="${src%%@*}"
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

# _parse <line>: sets type, repo, ref, globs and plugin from a source line (a
# blank line leaves type empty). Forms:
# - claude <repo> [plugin]: every plugin of a Claude marketplace, or one; a
#   repo that is no marketplace is one plugin (its skills/<name>/SKILL.md)
# - markdown <repo|folder> [glob,...]: its Markdown files, or those matching
#   a glob (from the repo root; a folder gives its Markdown files); a link to
#   a folder is that folder's glob
_parse() {
  local line="$1" src arg
  type="" repo="" ref="" path="" globs="" plugin=""
  read -r type src arg _ <<<"$line" || true
  [[ -n "${type:-}" ]] || return 0
  _repo "${src:-}"
  case "$type" in
    claude) plugin="${arg:-}" ;;
    markdown) globs="${arg:-$path}" ;;
  esac
}

# _clone <url> <dir> [ref] [sha]
_clone() {
  git clone --quiet --filter=blob:none ${3:+--branch "$3"} "$1" "$2" || return
  if [[ -n "${4:-}" ]]; then
    git -C "$2" checkout --quiet "$4"
  fi
}

# The settings sheet's right pane, "side" under its Details title: the looked-up plugins (a dataview)
# or a note (a markdownarea: help, test results, errors), swapped with replace.
# $data/pane remembers which, for ⌘⇧h to toggle; the caller writes it.
# A replaced component brings its own constraints.
side_constraints='{"region": "centre"}'


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
