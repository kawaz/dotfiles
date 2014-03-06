#!/bin/bash
. "`dirname -- "$0"`"/functions.sh || exit

# setup vim (etc/skel/.vimを作るのでドットファイルのシンボリックリンク作成前に実行する)
bash $DOTFILES_DIR/bin/setup-vim.sh

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
  ln -sfn "$DOTFILES_DIR/etc/tmux/tmux-platform-mac.conf" "$DOTFILES_DEST/tmux-platform.conf"
else
  ln -sfn "$DOTFILES_DIR/etc/tmux/tmux-platform-default.conf" "$DOTFILES_DEST/tmux-platform.conf"
fi


# vim のバージョンチェック
vim_version="$(vim --version | egrep -o '[0-9]+\.[0-9]+' | head -n 1)"
if [ "$((echo $vim_version; echo 7.1) | sort -k1,1n -k2,2n | head -n 1)" != "7.1" ]; then
  echo "~/.vimrcはvim7.1以上が必要なので以下を実行してください"
  echo "sh '$DOTFILES_DIR/bin/build-vim.sh'"
fi
