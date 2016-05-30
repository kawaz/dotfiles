#!/usr/bin/env bash
set -e
sudo yum -y install libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip git

tmp=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX")
[[ -n $tmp ]] && cd "$tmp" || exit 1

git clone https://github.com/neovim/neovim.git --depth=1
cd neovim
rm -rf build/
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$DOTFILES_DIR/local"
make install

# cleanup
rm -rf "$tmp"
