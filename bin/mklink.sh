#!/bin/sh
cd "`dirname "$0"`"/../skel || exit 1
backupdir="$HOME/dotfiles-backup-`date +%Y%m%dT%H%M%S`"

find "`pwd`" -mindepth 1 -maxdepth 1 -name .\* ! -name .\*.swp |
while read f; do
  link="$HOME/${f##*/}"
  # 既存の実ファイルが存在したらリネームしてとっておく(symlinkは上書きするので放置)
  if [ -e "$link" -a ! -L "$link" ]; then
    mkdir -p "$backupdir"
    mv "$link" "$backupdir/${f##*/}"
  fi
  ln -sfn "$f" "$link"
done

if [ -d "$backupdir" ]; then
  echo -e "既存のドットファイルは \x1b[36m${backupdir}\x1b[0m に移動されました"
fi
