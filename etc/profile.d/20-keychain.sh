#!/bin/sh
which --skip-alias --skip-function keychain >/dev/null 2>&1
if [[ "$?" == "0" ]]; then
  if [[ -z $SSH_AUTH_SOCK ]]; then
    keychain -q --timeout $((24*60)) --agents ssh >/dev/null
    if [[ -f ~/.keychain/$HOSTNAME-sh ]]; then
      . ~/.keychain/$HOSTNAME-sh
    fi
  fi
fi
