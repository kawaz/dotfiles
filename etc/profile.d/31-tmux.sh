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
