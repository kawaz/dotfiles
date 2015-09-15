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

# PS4の設定でシェルスクリプトのデバッグが捗る http://bit.ly/1gncKrn
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME:+$FUNCNAME(): }'

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

# cd fileでそのfileのあるディレクトリに移動する http://bit.ly/1dABtoO
function cd() {
  if [[ -e $1 && ! -d $1 ]]; then
    builtin cd -- "$(dirname -- "$1")"
  else
    builtin cd "$@"
  fi
  # historyにフルパスで履歴を残す http://inaz2.hatenablog.com/entry/2014/12/11/015125
  local ret=$?
  if [[ ($ret -eq 0) && (${#FUNCNAME[*]} -eq 1) ]]; then
    history -s cd $(printf "%q" "$PWD")
  fi
  return $ret
}

# 危険な crontab -r を封印する http://bit.ly/K9zMae
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

# 文字列エスケープ関数を定義しておく http://qiita.com/kawaz/items/f8d68f11d31aa3ea3d1c
sh-escape() {
  local s a=() q="'" qq='"'
  for s in "$@"; do
    a+=("'${s//$q/$q$qq$q$qq$q}'")
  done
  echo "${a[*]}"
}

# 一時作業用コマンド
tmpspace() {
  (
  d=$(mktemp -d) && cd "$d" || exit 1
  bash
  s=$?
  if [[ $s == 0 ]]; then
    rm -rf "$d"
  else
    echo "Directory '$d' still exists." >&2
  fi
  exit $s
  )
}

# history関連 http://bit.ly/JLIvj9
HISTTIMEFORMAT='%Y-%m-%dT%T%z '
HISTSIZE=30000
HISTIGNORE=""
