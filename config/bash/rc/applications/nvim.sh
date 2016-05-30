if type -p nvim >/dev/null; then
  alias vim=nvim
  alias vim0='command vim -u "$XDG_CONFIG_HOME/vim/vimrc"'
else
  alias vim='command vim -u "$XDG_CONFIG_HOME/vim/vimrc"'
fi
