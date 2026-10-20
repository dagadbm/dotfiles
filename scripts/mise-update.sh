#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=scripts/utils.sh
source "$(dirname "$0")/utils.sh"

# mise
mise plugins update
