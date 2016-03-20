#!/bin/bash

# $XDG_CONFIG_HOME 対応
_tmux_with_xdg() {
  if [[ -n $XDG_CONFIG_HOME ]]; then
    export TMUX_POWERLINE_RCFILE="$XDG_CONFIG_HOME/tmux-powerline/tmux-powerlinerc"
    export TMUX_PLUGIN_MANAGER_PATH="$XDG_CACHE_HOME/tpm/plugins"
    export TMUX_POWERLINE_DIR_HOME="$TMUX_PLUGIN_MANAGER_PATH/tmux-powerline"
    export TMUX_POWERLINE_SEG_WEATHER_GREP_DEFAULT="grep"
    command tmux -f "$XDG_CONFIG_HOME/tmux/tmux.conf" "$@"
  else
    command tmux "$@"
  fi
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
