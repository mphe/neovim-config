#!/usr/bin/env bash
cd "$(dirname "$(readlink -f "$0")")" || exit 1

mv autoload/plug.vim plug.vim.bak
curl -fLo autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
