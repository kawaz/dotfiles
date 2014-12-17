# bash
kawaz-env() {
  export DOTFILES_DIR=$(dirname "$(dirname "$BASH_SOURCE")")
  . "$DOTFILES_DIR/etc/skel/.bashrc"
  alias vim="command vim -u '$DOTFILES_DIR/etc/skel/.vimrc'"
  if [[ ! -e "$HOME/.vim" ]]; then
    ln -s "$DOTFILES_DIR/etc/skel/.vim" "$HOME/.vim"
  fi
  return true
}
