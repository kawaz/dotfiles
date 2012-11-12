# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# include settings (ファイル名順に読み込む)
for f in $(
  for f in "${DOTFILES_DIR:-$HOME/.dotfiles}"/{etc,env/dest}/profile.d/*.sh ~/.profile.d/*.sh; do
    echo "${f##*/} $f"
  done | sort | while read dummy f; do
    if [ -f "$f" ]; then
      #echo "$f" 1>&2
      echo "$f"
    fi
  done
); do
  . "$f" || echo -e "\e[1;35m↑This error is in $f\e[1;0m"
done
