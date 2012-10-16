#!/bin/sh
if [ -s ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
  if which --skip-alias --skip-functions npm >/dev/null 2>&1; then
    . <(npm completion)
  fi
fi
