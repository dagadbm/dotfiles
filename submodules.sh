#!/usr/bin/env bash

git submodule foreach --recursive git reset --hard
git submodule update --init --remote
git submodule update --recursive --remote
git submodule foreach --recursive git reset --hard
