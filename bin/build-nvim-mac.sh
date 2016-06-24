#!/usr/bin/env bash
[[ $OSTYPE != darwin* ]] && exit 1

brew update
for p in neovim python3; do
  if brew list "$p"; then
    brew upgrade "$p"
  else
    brew install "$p"
  fi
done
brew cleanup
pip3 install neovim --upgrade
