#!/usr/bin/env bash
set -x

git submodule foreach --recursive git reset --hard
git submodule update --init --recursive --remote
git submodule foreach --recursive git reset --hard
