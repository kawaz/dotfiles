#!/bin/bash
if [ -s ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh

  # npm ls で2階層以上のtree表示したくないときに使う
  function npm_ls() {
    npm ls "$@" | egrep -v '^[│  ]'
  }
fi
