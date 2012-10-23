#!/bin/sh
cd "`dirname "$0"`"/../etc/skel || exit 1
if [ -d .vim/phpmanual-cache ]; then
  exit;
fi

# ダウンロード途中で中断されたときにゴミを削除
function on_abort {
  echo 'Aborted! cleanup...'
  rm -rf .vim/phpmanual-cache
  exit 1
}
# シグナルトラップ設定
trap on_abort HUP INT QUIT TERM ABRT

# ダウンロード実行
( mkdir -p .vim/phpmanual-cache || exit 1
  cd       .vim/phpmanual-cache || exit 1
  echo Download phpmanual for ref.vim
  curl -L --progress-bar http://jp.php.net/get/php_manual_ja.tar.gz/from/this/mirror | tar xfz -
) || on_abort

