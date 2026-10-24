#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

# hk
mise upgrade hk
## keep the hk.pkl package on the installed hk version
version=$(mise exec -- hk --version | awk '{print $2}')
sed -i '' -E "s#(releases/download/v)[0-9.]+(/hk@)[0-9.]+#\1${version}\2${version}#g" hk.pkl
mise exec -- hk validate

# git hooks
mise exec -- hk install --mise
