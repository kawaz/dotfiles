#!/bin/sh
export LANG="ja_JP.UTF-8"
export PAGER="less -R"
export EDITOR="vim"

# 以下はインタラクティブシェルのときだけ適用
[[ -z "$PS1" ]] && return


# プロンプトの設定
export PS1='$(r=$?;x="$(__git_ps1 2>/dev/null) ";echo "${x## }";exit $r)$([[ $? == 0 ]]&&echo "\[\e[1;34m\]"||echo "\[\e[1;31m\]")[$(date +%d%a%T) \u@\h \W]\$\[\e[m\] '
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWDIRTYSTATE=1

# bash -x でスクリプトを実行した際の行頭の +,++,+++ とかの表示をスクリプト情報を付加する
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# 環境に無いTERMを使うと面倒な事になるのでチェックしてから使う
for TERM in xterm-256color screen-256color screen xterm vt100; do
  if [ -f /usr/*/terminfo/*/"$TERM" ]; then
    export TERM
    break;
  fi
done

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ls='ls --color'
alias grep='grep --color'
alias egrep='egrep --color'

alias du0='du --max-depth=1'
alias du1='du --max-depth=1'

alias last-itumono='last -adixFw'

# cd file でそのfileのあるディレクトリに移動する
function cd() {
  if [[ -e $1 && ! -d $1 ]]; then
    builtin cd -- "$(dirname -- "$1")"
  else
    builtin cd "$@"
  fi
}

# crontab -r を封印する
function crontab() {
  local opt
  for opt in "$@"; do
    if [[ $opt == -r ]]; then
      echo 'crontab -r is sealed!'
      return 1
    fi
  done
  command crontab "$@"
}

# history関連
HISTTIMEFORMAT='%Y-%m-%dT%T%z '
HISTSIZE=30000
HISTIGNORE=""

# bash -x の表示をリッチにする
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
