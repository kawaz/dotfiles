#!/bin/sh
[[ -n $TMUX || -z $PS1 ]] && return

function tmux() {
  if [[ $# == 0 ]] && tmux has-session 2>/dev/null; then
    command tmux attach-session
  else
    command tmux "$@"
  fi
}
