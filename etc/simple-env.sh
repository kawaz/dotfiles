# bash
kawaz-env() {
  export DOTFILES_DIR=$(dirname "$(dirname "$BASH_SOURCE")")
  . "$DOTFILES_DIR/etc/skel/.bashrc"
  alias vim="command vim -u '$DOTFILES_DIR/etc/skel/.vimrc' -c 'set rtp+=$DOTFILES_DIR/.env/dest/dot-vim/'"
  return 0
}
