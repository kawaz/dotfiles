#!/usr/bin/env bash
set -e
set -o pipefail
sudo yum install -y ncurses-devel

tmp=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX")
[[ -z $tmp ]] && exit 1
trap "rm -rf $(printf %q "$tmp")" EXIT

cd $tmp || exit 1
git clone --depth=1 https://github.com/vim/vim.git
cd vim/src
./configure \
  --enable-multibyte \
  --enable-python3interp \
  --enable-luainterp \
  --with-luajit \
  --prefix="$XDG_CACHE_HOME/dotfiles"
make
make install
