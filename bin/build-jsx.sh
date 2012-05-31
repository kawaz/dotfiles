#!/bin/sh
bin="`dirname "$0"`"
env="$bin/../env"

mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
src="$env/src/jst"
dest="$env/dest/jst"
mkdir -p "$src" || exit 1
ln -sfn ../src/jst "$dest" || exit 1

if [ ! -d "$src/.git" ]; then
  git clone https://github.com/jsx/JSX.git "$src" || exit 1
fi
cd "$src" || exit 1
git pull
make setup || exit 1

mkdir -p ~/.profile.d || exit 1
echo "export PATH=\"$dest/bin:\$PATH\"" > ~/.profile.d/10-dotfiles-jst.sh
