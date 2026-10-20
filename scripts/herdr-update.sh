#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

# integrations
herdr integration uninstall claude
herdr integration install claude

# plugins
herdr plugin uninstall dagadbm/herdr-dagadbm || true
herdr plugin install --yes dagadbm/herdr-dagadbm
