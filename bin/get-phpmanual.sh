#!/bin/sh
cd "`dirname "$0"`"/../skel || exit 1
mkdir -p .vim/phpmanual-cache || exit 1
cd       .vim/phpmanual-cache || exit 1
echo Download phpmanual for ref.vim
curl -L --progress-bar http://jp.php.net/get/php_manual_ja.tar.gz/from/this/mirror | tar xfz -
