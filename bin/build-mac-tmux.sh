#!/bin/bash
. "`dirname -- "$0"`"/functions.sh || exit

# Mac only
is_mac || exit 1

# install
for app in tmux reattach-to-user-namespace; do
  which $app >/dev/null 2>&1 || brew install $app
done
