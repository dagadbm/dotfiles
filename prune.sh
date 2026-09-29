#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# brew
./brew-prune.sh

# mise
./mise-prune.sh
