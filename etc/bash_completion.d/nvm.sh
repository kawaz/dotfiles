#!/bin/bash

# 初めてnvmの補完を実行するまで読み込みを遅延する
function _nvm_completion() {
  unset _nvm_completion
  complete -r nvm
  if [[ -f ~/.nvm/bash_completion ]]; then
    . ~/.nvm/bash_completion && return 124
  fi
}
complete -F _nvm_completion nvm
