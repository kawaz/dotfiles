#!/bin/sh
bin="`dirname "$0"`"
env="$bin/../env"

mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
src="$env/src/tmux-1.6"
dest="$env/dest/tmux"

if [ ! -d "$src/.svn" ]; then
  svn co https://tmux.svn.sourceforge.net/svnroot/tmux/tags/TMUX_1_6 "$src" || exit 1
fi
cd "$src" || exit 1
svn up || exit 1
sudo yum install -y automake libevent-devel ncurses-devel || exit 1
sh autogen.sh || exit 1
./configure --prefix="$dest" && make && make install || exit 1

mkdir -p ~/.profile.d || exit 1
echo "export PATH=\"$dest/bin:\$PATH\"" > ~/.profile.d/10-dotfiles-tmux.sh
