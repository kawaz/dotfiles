#!/bin/sh
if [ -s ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
  . <(npm completion)
fi
