#!/bin/sh
bin="`dirname "$0"`"
env="$bin/../env"

mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
src="$env/src/vim7"
dest="$env/dest/vim"

if [ ! -d "$src/.svn" ]; then
  svn co https://vim.svn.sourceforge.net/svnroot/vim/vim7 "$src" || exit 1
fi
cd "$src" || exit 1
svn up || exit 1
./configure --prefix="$dest" --enable-multibyte --enable-pythoninterp --with-features=big && make && make install || exit 1

mkdir -p ~/.profile.d || exit 1
echo "export PATH=\"$dest/bin:\$PATH\"" > ~/.profile.d/10-dotfiles-vim.sh
