#!/bin/sh
which --skip-alias --skip-function keychain >/dev/null 2>&1
if [ "$?" == "0" ]; then
  keychain -q --agents ssh >/dev/null
  if [ -f ~/.keychain/$HOSTNAME-sh ]; then
    . ~/.keychain/$HOSTNAME-sh
  fi
fi
