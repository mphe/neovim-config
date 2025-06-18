#!/usr/bin/env bash

if [[ "$(vint --version 2>&1 | head -n 1)" == *"UserWarning: pkg_resources is deprecated as an API."* ]]; then
    vint "$@" 2>&1 | tail -n +3
else
    vint "$@"
fi
