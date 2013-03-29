#!/bin/bash

# 初めてrvmの補完を実行するまで読み込みを遅延する
function _rvm_completion() {
  unset _rvm_completion
  complete -r rvm
  if [[ -f ~/.rvm/scripts/completion ]]; then
    . ~/.rvm/scripts/completion && return 124
  fi
}
complete -F _rvm_completion rvm

