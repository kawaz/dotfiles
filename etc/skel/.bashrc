# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# include settings
for f in "${DOTFILES_HOME-$HOME/.dotfiles}/etc/profile.d/"*.sh ~/.profile.d/*.sh; do
  if [ -f "$f" ]; then
    . "$f" || echo -e "\e[1;35m↑This error is in $f\e[1;0m"
  fi
done
