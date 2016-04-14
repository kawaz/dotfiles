# bash
kawaz-env() {
  export DOTFILES_DIR=$(cd "$(dirname "$BASH_SOURCE")/.." && pwd)
  . "$DOTFILES_DIR/config/bash/bashrc"
  if [[ ! $XMODIFIERS =~ @iam= ]]; then
    export XMODIFIERS="${XMODIFIERS:+$XMODIFIERS }@iam=kawaz"
  fi
  kawaz-env() { :; }
  return 0
}

if grep -qE '(^| )@iam=kawaz( |$)' <<<"$XMODIFIERS"; then
  kawaz-env
fi
