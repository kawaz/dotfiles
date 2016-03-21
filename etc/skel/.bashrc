# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# include settings (ファイル名順に読み込む)
while IFS= read -r fpath; do
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
