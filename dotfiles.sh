#!/usr/bin/env bash

set -e

CONFIG="dotbot.conf.yaml"
DOTBOT_DIR="dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

# symlink all zsh-theme files under custom/themes folder
# this operation cannot be done using dotbot unfortunately
for f in $(find $ZSH/custom/themes -name "*.zsh-theme"); do ln -f -s $f $ZSH/custom/themes; done
