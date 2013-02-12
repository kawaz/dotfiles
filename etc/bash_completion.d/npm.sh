#!/bin/bash

# 初めてnpmの補完を実行するまで読み込みを遅延する
function _npm_completion() {
  if which npm >/dev/null 2>&1; then
    # 補完設定を再定義
    unset _npm_completion
    complete -r npm
    . <(npm completion)
  fi
}
complete -F _npm_completion npm

