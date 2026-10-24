#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/utils.sh"

CONFIG="dotbot.conf.yaml"
DOTBOT_DIR="submodules/dotbot"
DOTBOT_BIN="bin/dotbot"

(cd "${DOTBOT_DIR}" && git submodule update --init --recursive)
"${PWD}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${PWD}" -c "${CONFIG}" "${@}"
