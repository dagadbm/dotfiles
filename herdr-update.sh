#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# herdr has no update feature for now

herdr integration uninstall claude
herdr integration install claude

herdr plugin uninstall yankewei/herdr-focus-notify
herdr plugin install --yes yankewei/herdr-focus-notify

herdr plugin uninstall Somliga/herdr-context
herdr plugin install --yes Somliga/herdr-context
