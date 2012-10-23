#!/bin/sh
bin="`dirname "$0"`"
env="$bin/../env"

mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
dest="$env/dest/bash-completion"
profile_d="$env/profile.d"

bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
if [ $bmajor -lt 4 ] || [ $bmajor -eq 4 -a $bminor -lt 1 ]; then
  # bash < 4.1
  mkdir -p "$profile_d"
  mkdir -p "$env/src"
  cd "$env/src" || exit 1
  curl http://bash-completion.alioth.debian.org/files/bash-completion-1.3.tar.bz2 | tar xfj -
  cd bash-completion-1.3 || exit 1
  ./configure --prefix="$dest" && make && make install
  ( echo '#!/bin/sh'
    echo "BASH_COMPLETION=\"$dest/etc/bash_completion\""
    echo "BASH_COMPLETION_DIR=\"$dest/etc/bash_completion.d\""
    echo "BASH_COMPLETION_COMPAT_DIR=\"$dest/etc/bash_completion.d\""
    echo "if [ -r \"$dest/etc/bash_completion\" ]; then"
    echo "  . \"$dest/etc/bash_completion\""
    echo "fi"
  ) > "$profile_d"/10-dotfiles-bash-completion.sh
fi
