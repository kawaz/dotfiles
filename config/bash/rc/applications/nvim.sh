if type -P nvim >/dev/null; then
  alias vim='nvim -p'
  alias vim0='command vim -p -u "$XDG_CONFIG_HOME/vim/vimrc"'
else
  alias vim='command vim -p -u "$XDG_CONFIG_HOME/vim/vimrc"'
fi
