#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# brew
scripts/brew-prune.sh

# mise
scripts/mise-prune.sh

# claude
scripts/claude-prune.sh
