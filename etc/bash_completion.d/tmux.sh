#!/bin/bash

# 分岐を列挙するのは不毛なので tmux list-commands をパースする感じで作ってみた
# 手探りで作った奴だがとりあえず必要十分な感じになった気がする
# Author: Yoshiaki Kawazu ( http://twitter.com/kawaz )

function _tmux_list_commands() {
  # tmux起動済み
  tmux list-commands 2>/dev/null && return
  # tmux未起動
  echo "attach-session new-session start-server" | perl -pe's/ /\n/g'
  # --help的なオプションが無いのでありえないオプション時のエラーからusageを取得する
  tmux -. 2>&1 | perl -pe's/\n/ /' | perl -pe's/.*tmux //' | _tmux_parse_opts
}

function _tmux_parse_opts() {
  local opt
  ([[ $# -eq 0 ]] && cat || echo "$1") |
  perl -pe's/\[/\n[/g;s/\]/\n/g' | egrep -v $'^[ \t]*$' |
  while read opt; do
    if [ "${opt:0:2}" == "[-" ]; then
      # 引数付きオプション
      echo "$opt" | grep -q " " && { echo "${opt:1}"; continue; }
      # 引数なしオプション
      echo "$opt" | perl -pe's/[^a-z0-9]//ig;s/./-$&\n/g'
    else
      # その他
      #echo "$opt"
      continue
    fi
  done
}

function _tmux() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local pre="${COMP_WORDS[COMP_CWORD-1]}"
  local command="${COMP_WORDS[1]}"
  local commands=( $(_tmux_list_commands | sed 's/ .*//') )
  if [[ $COMP_CWORD -ge 2 ]] && echo " ${commands[*]} " | fgrep -q -- " $command "; then
    COMPREPLY=()
    # コマンドのオプションを配列にする
    local IFS=$'\n'
    local opts=($( _tmux_list_commands | egrep "^$command( |\$)" | sed 's/^[^ ]* //' | _tmux_parse_opts ))
    local opts2=($( echo "${opts[*]}" | grep " " ))
    local target targets=()
    # $curにマッチするオプションに絞る
    for opt in "${opts2[@]}"; do
      # 引数付きのオプションを確定させる(tmuxのコマンドにロングオプションが無いことが前提)
      [[ "x$cur" == "x${opt%% *}" ]] && { COMPREPLY=("$cur"); return 0; }
      # 引数付きオプションの値部分の候補を探す
      if [[ "x$pre" == "x${opt%% *}" ]]; then
        case "${opt#* }" in
          src-pane|dst-pane|target-pane)
            # COMP_TYPEが何なのかよく分からんが9のときと63の時がある（63が二回目？）
            [[ "$COMP_TYPE" == "63" ]] && { echo; tmux list-pane; }
            targets=($( tmux list-pane | grep ^[0-9] | sed 's/:.*//'))
            ;;
          src-window|dst-window|target-window)
            [[ "$COMP_TYPE" == "63" ]] && { echo; tmux list-window; }
            targets=($( tmux list-window | grep ^[0-9] | perl -pe's/: */\n/;s/\*? *\(.*//' ))
            ;;
          target-session)
            [[ "$COMP_TYPE" == "63" ]] && { echo; tmux list-session; }
            targets=($( tmux list-session | sed 's/:.*//' ))
            ;;
        esac
      fi
    done
    # targetsを前方一致で絞る
    COMPREPLY=($(compgen -W "${targets[*]}" "$cur"))
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY+=("${targets[@]}")
    fi
    # 関連する補完候補が無ければコマンドのオプションを全部表示
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY+=("${opts[@]}")
      # 何も入力してないときに勝手に補完されちゃうのを防止するために空候補を1個足す
      if [ "$cur" == "" ]; then
        COMPREPLY+=("")
      fi
    fi
  else
    COMPREPLY=( $( compgen -W "${commands[*]}" ${cur} ) )
  fi
}
complete -F _tmux tmux
