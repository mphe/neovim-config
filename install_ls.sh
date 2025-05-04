#!/usr/bin/env bash

sudo pacman -S lua-language-server vint shellcheck jedi-language-server gopls
pip install --user --break-system-packages pylint mypy basedpyright
