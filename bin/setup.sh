#!/bin/sh
. "`dirname -- "$0"`"/functions.sh || exit

# setup vim
git clone https://github.com/Shougo/neobundle.vim "$DOTFILES_DIR/env/dest/dot-vim/bundle/neobundle.vim"
( cd "$DOTFILES_DIR/env/dest/dot-vim/bundle/neobundle.vim" && git pull --rebase )
ln -sfn "$DOTFILES_DIR/env/dest/dot-vim/" "$DOTFILES_DIR/etc/skel/.vim"

# for ref.vim
mkdir -p "$DOTFILES_DIR/env/dest/php_manual" &&
  curl -L http://jp.php.net/get/php_manual_ja.tar.gz/from/this/mirror |
  tar xz -C "$DOTFILES_DIR/env/dest/php_manual"
ln -sfn "$DOTFILES_DIR/env/dest/php_manual" "$DOTFILES_DIR/env/dest/dot-vim/php_manual"

# PHP補完辞書を作成
mkdir -p "$DOTFILES_DIR/env/dest/dot-vim/dict" &&
  php "$DOTFILES_DIR/bin/setup_vimphpdic.php" \
  > "$DOTFILES_DIR/env/dest/dot-vim/dict/php.dict"

# migemo-dict
cd_tmpdir &&
( set -e
  curl http://cmigemo.googlecode.com/files/cmigemo-default-win32-20110227.zip \
    > cmigemo-default-win32-current.zip
  unzip -p cmigemo-default-win32-current.zip cmigemo-default-win32/dict/utf-8/migemo-dict > migemo-dict
  # コンパクト化
  line_start="`grep -n あーくとう migemo-dict | head -n1 | perl -pe's/:.*//'`"
  line_all="`wc -l migemo-dict | perl -pe's/\s.*//'`"
  tail -n $(($line_all - $line_start + 1)) migemo-dict > migemo-dict.compact
  mkdir -p "$DOTFILES_DIR/env/dest/dot-vim/dict"
  cp migemo-dict.compact "$DOTFILES_DIR/env/dest/dot-vim/dict"
)

# HOMEのドットファイルを置き換える
backupdir="$HOME/dotfiles-backup-`date +%Y%m%dT%H%M%S`"
find "$DOTFILES_DIR/etc/skel" -mindepth 1 -maxdepth 1 -name .\* ! -name .\*.swp |
while read src; do
  dest="$HOME/${src##*/}"
  # 既存の実ファイルが存在したらリネームしてとっておく(srcとdestの実体が同じ場合はスキップ)
  if [ -e "$dest" -a ! "$src" -ef "$dest" ]; then
    mkdir -p "$backupdir"
    mv "$dest" "$backupdir/${src##*/}"
    ln -s "$src" "$dest"
  fi
done
if [ -d "$backupdir" ]; then
  echo -e "既存のドットファイルは \x1b[36m${backupdir}\x1b[0m に移動されました"
fi
