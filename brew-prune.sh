#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

BREWFILE="macos/Brewfile"

_check_dependency() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: $cmd not found" >&2
    exit 1
  fi
}

_check_dependency brew
_check_dependency fzf

if [[ ! -f "$BREWFILE" ]]; then
  echo "Error: $BREWFILE not found" >&2
  exit 1
fi

# Names declared in the Brewfile, one per line.
_brewfile_entries() {
  local kind="$1"
  sed -n "s/^[[:space:]]*${kind}[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$BREWFILE" | sort -u
}

# Formulae: only top-level (leaves), so dependencies are not flagged.
# Taps are normalized away so "homebrew/core/git" matches "git".
_installed_formulae() {
  brew leaves | sed 's|.*/||' | sort -u
}

# Short names only; the Brewfile side is normalized the same way.
_installed_casks() {
  brew list --cask -1 | sort -u
}

# Taps are reported as "owner/name" with no tap prefix, so they match the
# Brewfile spelling directly and need no normalization.
_installed_taps() {
  brew tap | sort -u
}

declare -a extra_formulae extra_casks extra_taps

mapfile -t extra_formulae < <(comm -23 \
  <(_installed_formulae) \
  <(_brewfile_entries brew | sed 's|.*/||' | sort -u))

mapfile -t extra_casks < <(comm -23 \
  <(_installed_casks) \
  <(_brewfile_entries cask | sed 's|.*/||' | sort -u))

mapfile -t extra_taps < <(comm -23 \
  <(_installed_taps) \
  <(_brewfile_entries tap))

_confirm() {
  local prompt="$1" reply
  read -r -p "$prompt [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

_PICK_SKIP="[skip] keep everything, move on"
_PICK_ALL="[all] select every entry"

# Multi-select entries with fzf and print the chosen ones, one per line.
# Prints nothing when the user picks skip or aborts with Esc.
_pick() {
  local prompt="$1" out
  shift
  out="$(printf '%s\n' "$_PICK_SKIP" "$_PICK_ALL" "$@" | fzf \
    --multi \
    --reverse \
    --height=~50% \
    --prompt="$prompt> " \
    --header='TAB toggle, ctrl-a select all, Enter confirm, Esc skip' \
    --bind='ctrl-a:select-all')" || return 0

  if grep -qxF "$_PICK_ALL" <<<"$out"; then
    printf '%s\n' "$@"
  elif ! grep -qxF "$_PICK_SKIP" <<<"$out"; then
    printf '%s\n' "$out"
  fi
}

_uninstall_formulae() {
  echo
  echo "== Formulae not in Brewfile =="
  if [[ ${#extra_formulae[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra_formulae[@]}"
  echo
  echo "WARNING: anything depending on the selected formulae may break."

  local -a picked
  mapfile -t picked < <(_pick "Uninstall formulae" "${extra_formulae[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  brew uninstall "${picked[@]}"
}

_uninstall_casks() {
  echo
  echo "== Casks not in Brewfile =="
  if [[ ${#extra_casks[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra_casks[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Uninstall casks" "${extra_casks[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  brew uninstall --cask "${picked[@]}"
}

_untap_extras() {
  echo
  echo "== Taps not in Brewfile =="
  if [[ ${#extra_taps[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi

  # Packages from third-party taps are listed as "owner/tap/name".
  local installed tap pkg
  local -a pkgs
  installed="$(
    brew list --formula --full-name 2>/dev/null
    brew list --cask --full-name 2>/dev/null
  )"
  for tap in "${extra_taps[@]}"; do
    mapfile -t pkgs < <(grep "^${tap}/" <<<"$installed" | sed 's|.*/||')
    if [[ ${#pkgs[@]} -eq 0 ]]; then
      echo "  $tap (no installed packages)"
    else
      echo "  $tap (still provides ${#pkgs[@]} installed package(s)):"
      for pkg in "${pkgs[@]}"; do
        echo "    - $pkg"
      done
    fi
  done

  echo
  echo "WARNING: untapping a tap that still provides installed packages"
  echo "blocks future upgrades of those packages until you tap it again."

  local -a picked
  mapfile -t picked < <(_pick "Untap" "${extra_taps[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing untapped."
    return 0
  fi

  # `brew untap` loads every tap formula whose name matches an installed
  # formula (e.g. core "sshpass" vs "hudochenkov/sshpass/sshpass"), and
  # Homebrew refuses to load formulae from untrusted taps. Trust the tap just
  # long enough to untap it, then drop the trust entry again.
  for tap in "${picked[@]}"; do
    brew trust --tap "$tap" >/dev/null
    brew untap "$tap" || echo "Failed to untap $tap, continuing." >&2
    brew untrust --tap "$tap" >/dev/null
  done
}

_autoremove() {
  echo
  echo "== Orphaned dependencies =="
  local out
  out="$(brew autoremove --dry-run 2>&1)"
  if [[ -z "$out" ]]; then
    echo "(none)"
    return 0
  fi
  echo "$out"
  echo
  echo "WARNING: these formulae will be uninstalled."
  if _confirm "Run brew autoremove?"; then
    brew autoremove
  else
    echo "Skipped."
  fi
}

_cleanup() {
  echo
  echo "== Stale downloads and old versions =="
  local out
  out="$(brew cleanup --prune=all --dry-run 2>&1)"
  if [[ -z "$out" ]]; then
    echo "(none)"
    return 0
  fi
  echo "$out"
  echo
  echo "WARNING: this deletes old versions and the whole download cache."
  if _confirm "Run brew cleanup --prune=all?"; then
    brew cleanup --prune=all
  else
    echo "Skipped."
  fi
}

_uninstall_formulae
_uninstall_casks
_untap_extras
_autoremove
_cleanup

echo
echo "Done."
