#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

mosh_server="$(command -v mosh-server)"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add "$mosh_server"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp "$mosh_server"

zsh -ic 'nightshift check'
