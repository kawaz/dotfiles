#!/bin/bash

# Mac以外では無視
[[ $OSTYPE == darwin* ]] || return

# shellcheck disable=SC2155,SC1090
{
  # coreutils
  _cache_brew_prefix_coreutils=/usr/local/opt/coreutils # $(brew --prefix coreutils)
  export PATH="$_cache_brew_prefix_coreutils/libexec/gnubin:$PATH"

  # findutils
  alias find=gfind
  alias xargs=gxargs

  # bash_completion
  _cache_brew_prefix=/usr/local # $(brew --prefix)
  if [[ -f "$_cache_brew_prefix/share/bash-completion/bash_completion" ]]; then
    . "$_cache_brew_prefix/share/bash-completion/bash_completion"
  fi
}
