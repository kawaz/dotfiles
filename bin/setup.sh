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

# HOMEのドットファイルを置き換える
backupdir="$HOME/dotfiles-backup-`date +%Y%m%dT%H%M%S`"
echo "export DOTFILES_DIR=\"$DOTFILES_DIR\"" > "$DOTFILES_DEST/.dotfilesrc"
( echo "$DOTFILES_DEST/.dotfilesrc"
  find "$DOTFILES_DIR/etc/skel" -mindepth 1 -maxdepth 1 -name .\* ! -name .\*.swp
) |
while read src; do
  dest="$HOME/${src##*/}"
  # 既存の実ファイルが存在したらリネームしてとっておく(srcとdestの実体が同じ場合はスキップ)
  if [ -e "$dest" -a ! "$src" -ef "$dest" ]; then
    mkdir -p "$backupdir"
    mv "$dest" "$backupdir/${src##*/}"
  fi
  # シンボリックリンクを作る
  ln -sfn "$src" "$dest"
done
if [ -d "$backupdir" ]; then
  echo -e "既存のドットファイルは \x1b[36m${backupdir}\x1b[0m に移動されました"
fi

# 環境に合わせたtmuxの追加設定を配備
if is_mac; then
  ln -sfn "$DOTFILES_DIR/etc/tmux-mac.conf" "$DOTFILES_DEST/tmux-platform.conf"
else
  ln -sfn "$DOTFILES_DIR/etc/tmux-default.conf" "$DOTFILES_DEST/tmux-platform.conf"
fi


# vim のバージョンチェック
vim_version="$(vim --version | egrep -o '[0-9]+\.[0-9]+' | head -n 1)"
if [ "$((echo $vim_version; echo 7.1) | sort -k1,1n -k2,2n | head -n 1)" != "7.1" ]; then
  echo "~/.vimrcはvim7.1以上が必要なので以下を実行してください"
  echo "sh '$DOTFILES_DIR/bin/build-vim.sh'"
fi
