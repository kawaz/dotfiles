#!/bin/sh

#tmuxで既存セッションがあればnew-sessionせずにアタッチする
if [[ -z $TMUX && -n $PS1 ]]; then
  function tmux() {
    if [[ $# == 0 ]] && tmux has-session 2>/dev/null; then
      command tmux attach-session
    else
      command tmux "$@"
    fi
  }
fi

#ウィンドウネームを変更しつつsshする
t-ssh() { tmux new-window -n "$1" "ssh $*"; }
complete -F _ssh t-ssh

tssh() {
  local ssh_opts=()
  if [[ $1 =~ ^- ]]; then
    for opt in "$@"; do
      shift
      [[ $opt == -- ]] && break
      ssh_opts+=("$opt")
    done
  fi
  if [[ -z $1 ]]; then
    echo "Usage: $FUNCNAME [[ssh_opts...] --] host [hosts...]" 1>&2
    return 1
  fi
  if [[ -n $TMUX ]]; then
    command tmux new-window "ssh $(sh-escape "${ssh_opts[@]}" "$1")"
    shift
    for h in "$@"; do
      command tmux split-window "ssh $(sh-escape "${ssh_opts[@]}" "$h")"
      command tmux select-layout tiled >/dev/null
    done
    command tmux set-window-option -q synchronize-panes on
  else
    local session="tmux-ssh-$(date +%Y%m%dT%H%M%S)-$RANDOM"
    command tmux start-server
    command tmux new-session -d -s "$session" "ssh $(sh-escape "${ssh_opts[@]}" "$1")"
    shift
    for h in "$@"; do
      command tmux split-window -t "$session" "ssh $(sh-escape "${ssh_opts[@]}" "$h")"
      command tmux select-layout -t "$session" tiled >/dev/null
    done
    command tmux set-window-option -t "$session" -q synchronize-panes on
    command tmux attach-session -t $session
  fi
}
