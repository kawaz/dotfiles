# Mac以外では無視
[[ $OSTYPE == darwin* ]] || return 0

if [[ -z $HOMEBREW_PREFIX ]]; then
  # shellcheck disable=SC1090
  . <(brew shellenv)
  # this is set HOMEBREW_PREFIX HOMEBREW_CELLAR HOMEBREW_REPOSITORY
  # and add PATH MANPATH INFOPATH
fi

# Gatekeeperを抑制するオプション(このファイルはXXからダウンロードされましたっていうダイアログが出ないようにする)
export HOMEBREW_CASK_OPTS="--no-quarantine"

# coreutils
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin${PATH+:$PATH}"

# findutils
alias find=gfind
alias xargs=gxargs

# bash_completion
if [[ -f "$HOMEBREW_PREFIX/etc/bash_completion" ]]; then
  # shellcheck disable=SC1090,SC1091
  . "$HOMEBREW_PREFIX/etc/bash_completion"
fi
