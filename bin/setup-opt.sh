#!/bin/bash
. "`dirname -- "$0"`"/functions.sh || exit

# 新環境
mkdir -p "$DOTFILES_DIR/.env/repos"
mkdir -p "$DOTFILES_DIR/.env/opt/bin"
mkdir -p "$DOTFILES_DIR/.env/opt/etc/profile.d"
mkdir -p "$DOTFILES_DIR/.env/opt/etc/bash_completion.d"
export PATH="$DOTFILES_DIR/.env/opt/bin:$PATH"

# 分割管理してるのを集める
for url in https://github.com/kawaz/awsmeta.git; do
  repopath="$DOTFILES_DIR/.env/repos/$(perl -pe's/^https?:\/\/.*?//;s/.*?\@//;s/:/\//;s/\.git$//'<<<"$url")"
  # checkout
  if [[ -d $repopath ]]; then
    (cd "$repopath" && ( git pull -f --recurse-submodules; git submodule update --init --recursive -f) )
  else
    git clone --recursive --recurse-submodules "$url" "$repopath"
  fi
  # make symlink
  ( cd "$repopath" || exit 1;
  find {bin,etc} -type d -exec mkdir -p "$DOTFILES_DIR/.env/opt/"{} \;
  find {bin,etc} -type f -exec ln -sfn "$repopath/"{} "$DOTFILES_DIR/.env/opt/"{} \;
  )
done

if is_mac; then
  brew install hub
fi
