#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

source "$(dirname "$0")/prune-utils.sh"

BREWFILE="macos/Brewfile"

_check_dependency brew
_check_dependency fzf
_check_file "$BREWFILE"

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

_uninstall_formulae() {
  _section "Formulae not in Brewfile"
  local -a extra
  mapfile -t extra < <(comm -23 \
    <(_installed_formulae) \
    <(_brewfile_entries brew | sed 's|.*/||' | sort -u))
  if [[ ${#extra[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra[@]}"
  _warn "anything depending on the selected formulae may break."

  local -a picked
  mapfile -t picked < <(_pick "Uninstall formulae" "${extra[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  brew uninstall "${picked[@]}"
}

_uninstall_casks() {
  _section "Casks not in Brewfile"
  local -a extra
  mapfile -t extra < <(comm -23 \
    <(_installed_casks) \
    <(_brewfile_entries cask | sed 's|.*/||' | sort -u))
  if [[ ${#extra[@]} -eq 0 ]]; then
    echo "(none)"
    return 0
  fi
  printf '  %s\n' "${extra[@]}"

  local -a picked
  mapfile -t picked < <(_pick "Uninstall casks" "${extra[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  brew uninstall --cask "${picked[@]}"
}

_untap_taps() {
  _section "Taps not in Brewfile"
  local -a extra
  mapfile -t extra < <(comm -23 \
    <(_installed_taps) \
    <(_brewfile_entries tap))
  if [[ ${#extra[@]} -eq 0 ]]; then
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
  for tap in "${extra[@]}"; do
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
  _warn "untapping a tap that still provides installed packages
blocks future upgrades of those packages until you tap it again."

  local -a picked
  mapfile -t picked < <(_pick "Untap" "${extra[@]}")
  if [[ ${#picked[@]} -eq 0 ]]; then
    echo "Skipped. Nothing removed."
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
  _section "Orphaned dependencies"
  local out
  out="$(brew autoremove --dry-run 2>&1)"
  if [[ -z "$out" ]]; then
    echo "(none)"
    return 0
  fi
  echo "$out"
  _warn "these formulae will be uninstalled."

  if ! _confirm "Run brew autoremove?"; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  brew autoremove
}

_cleanup_cache() {
  _section "Stale downloads and old versions"
  local out
  out="$(brew cleanup --prune=all --dry-run 2>&1)"
  if [[ -z "$out" ]]; then
    echo "(none)"
    return 0
  fi
  echo "$out"
  _warn "this deletes old versions and the whole download cache."

  if ! _confirm "Run brew cleanup --prune=all?"; then
    echo "Skipped. Nothing removed."
    return 0
  fi
  brew cleanup --prune=all
}

_uninstall_formulae
_uninstall_casks
_untap_taps
_autoremove
_cleanup_cache

_done
