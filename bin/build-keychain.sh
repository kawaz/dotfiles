#!/bin/sh
bin="`dirname "$0"`"
env="$bin/../env"

mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
src="$env/src/keychain"
dest="$env/dest/keychain"
mkdir -p "$src" "$dest" || exit 1

if [ ! -d "$src/.git" ]; then
  git clone git://github.com/funtoo/keychain.git "$src" || exit 1
fi
cd "$src" || exit 1
git pull
make || exit 1
mkdir -p "$dest/bin"
mkdir -p "$dest/man/man1"
cp -ap "$src/keychain" "$dest/bin/"
cp -ap "$src/keychain.1" "$dest/man/man1/"
mkdir -p ~/.profile.d || exit 1
echo "export PATH=\"$dest/bin:\$PATH\"" > ~/.profile.d/dotfiles-keychain.sh
