#!/usr/bin/env bash

# submodules
git submodule foreach git remote prune origin
git submodule foreach --recursive git reset --hard
git submodule update --init --recursive --remote
git submodule foreach --recursive git reset --hard
