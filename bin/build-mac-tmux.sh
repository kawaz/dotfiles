#!/bin/bash
set -e
. "$(dirname -- "$0")"/functions.sh

# Mac only
is_mac || exit 1

# install
for app in tmux reattach-to-user-namespace; do
  type -p "$app" >/dev/null || brew install "$app"
done
