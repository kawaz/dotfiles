#!/bin/bash
if [ -s ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh

  # bash-completion 設定を追加
  if which --skip-alias --skip-functions npm >/dev/null 2>&1; then
    . <(npm completion)
  fi

  # npm ls で2階層以上のtree表示したくないときに使う
  function npm_ls() {
    npm ls "$@" | egrep -v '^[│  ]'
  }
fi
