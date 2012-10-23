# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# include settings
files=(`
  for f in "${DOTFILES_HOME-$HOME/.dotfiles}"/{etc,env}/profile.d/*.sh ~/.profile.d/*.sh; do
    echo "${f##*/} $f"
  done | sort | while read dummy f; do
    echo "$f"
  done
`)
for f in "${files[@]}"; do
  if [ -f "$f" ]; then
    . "$f" || echo -e "\e[1;35m↑This error is in $f\e[1;0m"
  fi
done
