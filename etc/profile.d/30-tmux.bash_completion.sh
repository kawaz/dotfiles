#!/bin/bash

# 分岐を列挙するのは不毛なので tmux list-commands をパースする感じで作ってみた
# 手探りで作った奴だがとりあえず必要十分な感じになった気がする

function _tmux() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local pre="${COMP_WORDS[COMP_CWORD-1]}"
  local command="${COMP_WORDS[1]}"
  local commands=( $(tmux list-commands | sed 's/ .*//') )
  if [ $COMP_CWORD -ge 2 ] && echo " ${commands[*]} " | fgrep -q -- " $command "; then
    COMPREPLY=()
    local IFS=$'\n'
    local help=($( tmux list-commands | egrep "^$command( |\$)" | sed 's/^[^ ]* //' | perl -pe's/\[/\n[/g;s/\]/\n/g' ))
    local opt opts0=() opts1=() opts2=()
    # コマンドのオプションを配列にする
    for opt in "${help[@]}"; do
      if [ "${opt:0:2}" == "[-" ]; then
        opt="${opt:1}"
        if echo "$opt" | grep -q " "; then
          opts2=("$opt")
          continue
        fi
        while :; do
          opt="${opt:1}"
          if echo "${opt:0:1}" | grep -qi '[a-z0-9]'; then
            opts1+=("-${opt:0:1}")
            # 引数なしオプションを確定させる(tmuxのコマンドにロングオプションが無いことが前提)
            if [ "x$cur" == "x-${opt:0:1}" ]; then
              COMPREPLY=("$cur")
              return 0
            fi
          else
            break
          fi
        done
      fi
    done
    # $curにマッチするオプションに絞る
    for opt in "${opts2[@]}"; do
      # 引数付きのオプションを確定させる(tmuxのコマンドにロングオプションが無いことが前提)
      if [ "x$cur" == "x${opt%% *}" ]; then
        COMPREPLY=("$cur")
        return 0
      fi
      # 引数付きオプションの値部分の候補を探す 
      if [ "x$pre" == "x${opt%% *}" ]; then
        local target targets=()
        case "${opt#* }" in
          src-pane|dst-pane|target-pane)
            # COMP_TYPEが何なのかよく分からんが9のときと63の時がある
            [ "$COMP_TYPE" == "63" ] && { echo; tmux list-pane; }
            targets=($( tmux list-pane | grep ^[0-9] | sed 's/:.*//'))
            ;;
          src-window|dst-window|target-window)
            [ "$COMP_TYPE" == "63" ] && { echo; tmux list-window; }
            targets=($( tmux list-window | grep ^[0-9] | perl -pe's/: */\n/;s/\*? *\(.*//' ))
            ;;
          target-session)
            [ "$COMP_TYPE" == "63" ] && { echo; tmux list-session; }
            targets=($( tmux list-session | sed 's/:.*//' ))
            ;;
        esac
      fi
    done
    # 引数の前方一致で探す
    for target in "${targets[@]}"; do
      case "$target" in
        "$cur"*) COMPREPLY+=("$target");;
      esac
    done
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY+=("${targets[@]}")
    fi
    # 関連する補完候補が無ければコマンドのオプションを全部表示
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY+=("${opts1[@]}")
      COMPREPLY+=("${opts2[@]}")
      COMPREPLY+=("")
    fi
  else
    COMPREPLY=( $( compgen -W "${commands[*]}" ${cur} ) )
  fi
}
complete -F _tmux tmux
