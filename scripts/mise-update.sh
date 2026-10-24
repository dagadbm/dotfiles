#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# mise
mise plugins update
# caveman is installed with npm by scripts/claude-update.sh
mise upgrade --exclude npm:@caveman-ai/cli
