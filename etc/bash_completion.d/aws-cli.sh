#!/bin/bash
if type -p aws_completer >/dev/null; then
  complete -C "$(type -p aws_completer)" aws
fi
