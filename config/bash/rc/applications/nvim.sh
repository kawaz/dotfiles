if type -P nvim >/dev/null; then
  alias nvim='nvim -p'
  alias vim='nvim'
  alias vim0='command vim -p -u "$XDG_CONFIG_HOME/vim/vimrc"'
else
  alias vim='command vim -p -u "$XDG_CONFIG_HOME/vim/vimrc"'
fi
