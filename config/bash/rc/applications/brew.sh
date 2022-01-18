# Mac以外では無視
[[ $OSTYPE == darwin* ]] || return 0

brew_prefix=$(brew --prefix)

# brew
brew() {
  "$(PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin command brew --prefix)"/bin/brew "$@"
}

# Gatekeeperを抑制するオプション(このファイルはXXからダウンロードされましたっていうダイアログが出ないようにする)
export HOMEBREW_CASK_OPTS="--no-quarantine"

# coreutils
export PATH="$brew_prefix/opt/coreutils/libexec/gnubin:$PATH"

# findutils
alias find=gfind
alias xargs=gxargs

# bash_completion
if [[ -f "$brew_prefix/etc/bash_completion" ]]; then
  # shellcheck disable=SC1090
  . "$brew_prefix/etc/bash_completion"
fi

unset -v brew_prefix
