#!/bin/sh
bin="`dirname "$0"`"
env="$bin/../env"
mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
profile_d="$env/profile.d"
mkdir -p "$profile_d"

# for Mac
if uname | grep -qi darwin; then
  brew install xz binutils coreutils findutils
  ( echo '#!/bin/sh'
    echo
    echo '# coreutils'
    echo 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"'
    echo '# findutils'
    echo 'alias find=gfind'
    echo 'alias xargs=gxargs'
  ) > "$profile_d"/10-mac-coreutils.sh
  exit
fi
