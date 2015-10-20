# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# DOTFILES_DIRの設定があれば読み込む
if [ -f "$HOME/.dotfilesrc" ]; then
  . "$HOME/.dotfilesrc"
fi

# include settings (ファイル名順に読み込む)
while IFS= read fpath; do
  if [[ -f $fpath ]]; then
    . "$fpath" || echo -e "\e[1;35mAbove error is in $fpath\e[1;0m" >&2
  fi
done < <(
  for f in \
    "${DOTFILES_DIR:-$HOME/.dotfiles}"/etc/profile.d/*.sh \
    "${DOTFILES_DIR:-$HOME/.dotfiles}"/.env/dest/profile.d/*.sh \
    "${DOTFILES_DIR:-$HOME/.dotfiles}"/.env/opt/etc/profile.d/*.sh \
    ~/.profile.d/*.sh
  do
    echo "${f##*/}/$f"
  done | sort | cut -d/ -f2-
)
