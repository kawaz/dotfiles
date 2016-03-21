#!/bin/bash
. "`dirname -- "$0"`"/functions.sh || exit

# ~/.profile.d を作る
mkdir -p ~/.profile.d

# 環境に合わせたtmuxの追加設定を配備
if is_mac; then
  ln -sfn "$DOTFILES_DIR/etc/tmux/tmux-platform-mac.conf" "$DOTFILES_DEST/tmux-platform.conf"
else
  ln -sfn "$DOTFILES_DIR/etc/tmux/tmux-platform-default.conf" "$DOTFILES_DEST/tmux-platform.conf"
fi

# 新環境やつを取り込む
bash "$DOTFILES_DIR/bin/setup-opt.sh"
