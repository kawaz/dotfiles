# Mac以外では無視
[[ $OSTYPE == darwin* ]] || return 0

brew_prefix="/usr/local" # $(brew --prefix)

# brew
brew() {
  PATH=/usr/bin:/bin:/usr/sbin:/sbin "$(command brew --prefix)"/bin/brew "$@"
}

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
