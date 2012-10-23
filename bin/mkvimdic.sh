#!/bin/sh
bin="`dirname "$0"`"
skel="$bin/../etc/skel" || exit 1
test -d "$skel" || exit 1

# PHP保管辞書を作成
mkdir -p "$skel/.vim/dict" || exit 1
php "$bin/mkvimdic.php" > "$skel/.vim/dict/php.dict"
