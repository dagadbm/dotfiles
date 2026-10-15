#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# integrations
herdr integration uninstall claude
herdr integration install claude

# plugins
herdr plugin uninstall dagadbm/herdr-dagadbm || true
herdr plugin install --yes dagadbm/herdr-dagadbm
