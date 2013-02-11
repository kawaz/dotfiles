#!/bin/bash
. "`dirname -- "$0"`"/functions.sh || exit

# Mac only
is_mac || exit 1

# install
which tmux >/dev/null 2>&1 || brew install tmux

# install reattach-to-user-namespace
cd_tmpdir && (
  mkdir -p ~/bin/
  git clone https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git
  cd tmux-MacOSX-pasteboard
  make reattach-to-user-namespace &&
    cp reattach-to-user-namespace ~/bin/
)
