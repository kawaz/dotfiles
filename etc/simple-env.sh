# bash
kawaz-env() {
  export DOTFILES_DIR=$(cd "$(dirname "$BASH_SOURCE")/.." && pwd)
  . "$DOTFILES_DIR/etc/skel/.bashrc"
  return 0
}
