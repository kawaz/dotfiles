# Mac以外では無視
[[ $OSTYPE == darwin* ]] || return

brew_prefix="/usr/local" # $(brew --prefix)

# coreutils
brew_prefix_coreutils="$brew_prefix/opt/coreutils" # $(brew --prefix coreutils)
export PATH="$brew_prefix_coreutils/libexec/gnubin:$PATH"
unset -v brew_prefix_coreutils

# findutils
alias find=gfind
alias xargs=gxargs

# bash_completion
if [[ -f "$brew_prefix/share/bash-completion/bash_completion" ]]; then
  # shellcheck disable=SC1090
  . "$brew_prefix/share/bash-completion/bash_completion"
fi

unset -v brew_prefix
