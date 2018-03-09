#!/bin/bash

export XDG_CACHE_HOME="/tmp/${USER}/.cache"
mkdir -p "${XDG_CACHE_HOME}" >/dev/null 2>&1
ln -sf "${HOME}/.winetricks-cache/" "${XDG_CACHE_HOME}/winetricks" \
   >/dev/null 2>&1
