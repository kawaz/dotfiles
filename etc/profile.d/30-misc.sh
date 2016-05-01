#!/usr/bin/env bash
export LANG="ja_JP.UTF-8"
export PAGER="less -R"
if type -p nvim >/dev/null; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi


# 以下はインタラクティブシェルのときだけ適用
[[ -z "$PS1" ]] && return

# プロンプトの設定
export PS1='$(r=$?;x="$(__git_ps1 2>/dev/null) ";echo "${x## }";exit $r)$([[ $? == 0 ]]&&echo "\[\e[1;34m\]"||echo "\[\e[1;31m\]")[\u@\h \W]\$\[\e[m\] '
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWDIRTYSTATE=1

# PS4の設定でシェルスクリプトのデバッグが捗る http://bit.ly/1gncKrn
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME:+$FUNCNAME(): }'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ls='ls --color'
alias grep='grep --color'
alias egrep='egrep --color'

alias du0='du --max-depth=1'
alias du1='du --max-depth=1'

alias last-itumono='last -adixFw'

ghq-cd() { local d=$(peco --select-1 --layout bottom-up < <(ghq list "$@")); cd "${d:+$HOME/.ghq/$d}"; }
alias ghcd=ghq-cd

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

# 一時作業用コマンド http://bit.ly/22GF66y
tmpspace() {
  (
  d=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX") && cd "$d" || exit 1
  "$SHELL"
  s=$?
  if [[ $s == 0 ]]; then
    rm -rf "$d"
  else
    echo "Directory '$d' still exists." >&2
  fi
  exit $s
  )
}
# typoで補完が出てこないのもストレスなのでaliasも作っておくことにした
alias tempspace=tmpspace

# history関連 http://bit.ly/JLIvj9
HISTTIMEFORMAT='%Y-%m-%dT%T%z '
HISTSIZE=50000
HISTFILESIZE=-1
HISTIGNORE=""

#
inject_current_terminal() {
  local keyseq=$*
}
readline_search_history_hack() {
    local histline=$(
      # 時間表示と履歴番号を削除
      HISTTIMEFORMAT= history | perl -pe's/^ *[0-9]+ *//' |
      # tac が使えなかったら代替でperl使う
      if type taxc >/dev/null 2>&1; then tac; else perl -pe'print reverse <>'; fi |
      # 重複行を削除
      awk '!x[$0]++' |
      # 既に何か入力中でかつ行末カーソルなら先頭一致でフィルタ
      if [[ -n $READLINE_LINE && ${#READLINE_LINE} == $READLINE_POINT ]]; then
        while read -r line; do
          [[ $line == $READLINE_LINE* ]] && printf $'%s\n' "$line"
        done |
        # フィルタ済みなのでデフォルトクエリ無しでpecoる
        peco --select-1 --layout=bottom-up
      else
        # 入力済みの文字をデフォルトクエリに入れてpecoる
        peco --select-1 --layout=bottom-up --query "${READLINE_LINE:+$READLINE_LINE }"
      fi |
      # １行で十分です
      head -n1
    )
    # なんか選択されてたらターミナルに反映
    if [[ -n $histline ]]; then
      READLINE_LINE=$histline
      READLINE_POINT=${#histline}
    fi
  }
  # キーバインド登録（pecoがある時のみ）
  if type peco >/dev/null 2>&1; then
    bind -x '"\C-r": readline_search_history_hack'
  fi
