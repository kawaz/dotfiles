#!/bin/bash
. "`dirname -- "$0"`"/functions.sh || exit

# setup vim (etc/skel/.vimを作るのでドットファイルのシンボリックリンク作成前に実行する)
git clone https://github.com/Shougo/neobundle.vim "$DOTFILES_DEST/dot-vim/bundle/neobundle.vim"
( cd "$DOTFILES_DEST/dot-vim/bundle/neobundle.vim" && git pull --rebase )
ln -sfn "$DOTFILES_DEST/dot-vim/" "$DOTFILES_DIR/etc/skel/.vim"
# for ref.vim
if [ ! -d "$DOTFILES_DEST/dot-vim/php_manual/php-chunked-xhtml" ]; then
  mkdir -p "$DOTFILES_DEST/php_manual"
  curl -L http://jp.php.net/get/php_manual_ja.tar.gz/from/this/mirror |
    tar xz -C "$DOTFILES_DEST/php_manual" &&
    ln -sfn "$DOTFILES_DEST/php_manual" "$DOTFILES_DEST/dot-vim/php_manual"
fi
# PHP補完辞書を作成
if [ ! -s "$DOTFILES_DEST/dot-vim/dict/php.dict" ]; then
  mkdir -p "$DOTFILES_DEST/dot-vim/dict"
  php "$DOTFILES_DIR/bin/setup_vimphpdic.php" > "$DOTFILES_DEST/dot-vim/dict/php.dict"
fi
# migemo-dict
if [ ! -s "$DOTFILES_DEST/dot-vim/dict" ]; then
  cd_tmpdir &&
  ( set -e
    curl http://cmigemo.googlecode.com/files/cmigemo-default-win32-20110227.zip \
      > cmigemo-default-win32-current.zip
    unzip -p cmigemo-default-win32-current.zip cmigemo-default-win32/dict/utf-8/migemo-dict > migemo-dict
    # コンパクト化
    line_start="`grep -n あーくとう migemo-dict | head -n1 | perl -pe's/:.*//'`"
    line_all="`wc -l migemo-dict | perl -pe's/\s.*//'`"
    tail -n $(($line_all - $line_start + 1)) migemo-dict > migemo-dict.compact
    mkdir -p "$DOTFILES_DEST/dot-vim/dict"
    cp migemo-dict.compact "$DOTFILES_DEST/dot-vim/dict"
  )
fi
