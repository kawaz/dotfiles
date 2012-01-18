#!/bin/sh
cd "`dirname "$0"`"/../skel || exit 1

find "`pwd`" -mindepth 1 -maxdepth 1 -name .\* |
while read f; do
  ln -sfn "$f" ~/"`basename $f`"
done
