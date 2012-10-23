#!/bin/sh
export LANG="ja_JP.UTF-8"
export PAGER="less -R"
export EDITOR="vim"
export PS1='`[[ "$?" -eq 0 ]]&&echo "\[\e[1;34m\]"||echo "\[\e[1;31m\]"`[`date +%d%a%T` \u@\h \W]\$\[\e[m\] '
for TERM in xterm-256color screen-256color screen xterm vt100; do
  if [ -f /usr/*/terminfo/*/"$TERM" ]; then
    export TERM
    break;
  fi
done

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias du0='du --max-depth=1'
alias du1='du --max-depth=1'

alias dstat-full='dstat -Tclmdrn'
alias dstat-mem='dstat -Tclm'
alias dstat-cpu='dstat -Tclr'
alias dstat-net='dstat -Tclnd'
alias dstat-disk='dstat -Tcldr'

alias last-itumono='last -adixFw'

# cd file でそのfileのあるディレクトリに移動する
function cd() {
  if [ -e "$1" -a ! -d "$1" ]; then
    builtin cd "`dirname "$1"`"
  else
    builtin cd "$@"
  fi
}

# crontab -r を封印する
function crontab() {
  local opt
  for opt in "$@"; do
    if [ "$opt" == "-r" ]; then
      echo '-r is sealed!'
      return 1
    fi
  done
  command crontab "$@"
}
