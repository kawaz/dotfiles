#!/bin/bash

# $XDG_CONFIG_HOME 対応
_tmux_with_xdg() {
  local opts=( -u )
  if [[ -n $XDG_CONFIG_HOME ]]; then
    export TMUX_PLUGIN_MANAGER_PATH="$XDG_CACHE_HOME/tpm/plugins"
    opts+=( -f "$XDG_CONFIG_HOME/tmux/tmux.conf" )
  fi
  command tmux "${opts[@]}" "$@"
}

#tmuxで既存セッションがあればnew-sessionせずにアタッチする
if [[ -z $TMUX && -n $PS1 ]]; then
  tmux() {
    if [[ $# == 0 ]] && tmux has-session 2>/dev/null; then
      _tmux_with_xdg attach-session
    else
      _tmux_with_xdg "$@"
    fi
  }
else
  tmux() { _tmux_with_xdg "$@"; }
fi
