#!/bin/sh
bin="`dirname "$0"`"
cd "$bin" && cd .. || exit 1
base="`pwd`"

env="$base/env"
mkdir -p "$env" && cd "$env" || exit 1
src="$env/src/cmigemo-default-win32"
mkdir -p "$src" && cd "$src" || exit 1

dest="$base/skel/.vim/dict/migemo-dict"

# ダウンロード途中で中断されたときにゴミを削除
function on_abort {
  echo 'Aborted! cleanup...'
  #rm -rf xx
  exit 1
}
# シグナルトラップ設定
trap on_abort HUP INT QUIT TERM ABRT

# ダウンロード実行
( set -e
  echo Download phpmanual for ref.vim
  wget http://cmigemo.googlecode.com/files/cmigemo-default-win32-20110227.zip -O cmigemo-default-win32-current.zip
  unzip -p cmigemo-default-win32-current.zip cmigemo-default-win32/dict/utf-8/migemo-dict > migemo-dict
  # コンパクト化
  line_start="`grep -n あーくとう migemo-dict | head -n1 | perl -pe's/:.*//'`"
  line_all="`wc -l migemo-dict | perl -pe's/\s.*//'`"
  tail -n $(($line_all - $line_start + 1)) migemo-dict > migemo-dict.compact
  mkdir -p "`dirname $dest`"
  cp migemo-dict.compact "$dest"
) || on_abort

