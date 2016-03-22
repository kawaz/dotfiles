# bash
kawaz-env() {
  export DOTFILES_DIR=$(cd "$(dirname "$BASH_SOURCE")/.." && pwd)
  . "$DOTFILES_DIR/config/bash/bashrc"
  return 0
}
