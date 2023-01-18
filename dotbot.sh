#!/usr/bin/env bash
set -e

CONFIG="dotbot.conf.yaml"
DOTBOT_DIR="submodules/dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"

(cd "${DOTBOT_DIR}" && git submodule update --init --recursive)
"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
