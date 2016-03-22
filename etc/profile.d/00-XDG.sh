#!/usr/bin/env bash
if [[ -n $DOTFILES_DIR ]]; then
  export XDG_CONFIG_HOME=$DOTFILES_DIR/config
  export XDG_CACHE_HOME=$DOTFILES_DIR/cache
  export XDG_DATA_HOME=$DOTFILES_DIR/local
  export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
fi
