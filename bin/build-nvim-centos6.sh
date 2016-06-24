#!/usr/bin/env bash
set -e
[[ -z $DOTFILES_LOCAL ]] && { echo "\$DOTFILES_LOCAL is empty" >&2; exit 1; }
sudo yum -y install libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip git

install_python_neovim() {
  local pip3 python3
  pip3=$(compgen -c pip3 || compgen -c pip-3 | sort -rV | head -n 1)
  if [[ -z $pip3 ]]; then
    py3_ver=$(yum list python3\*-devel -q | grep -Eo '^python3[0-9]+' | sort | tail -n1)
    if [[ -z $py3_ver ]]; then
      return 1
    fi
    sudo yum install -y "${py3_ver}"{,-{devel,pip}}
    python3=$(compgen -c python3 || compgen -c python-3 | sort -rV | head -n 1)
    pip3=$(compgen -c pip3 || compgen -c pip-3 | sort -rV | head -n 1)
    if [[ -z $pip3 && -n $python3 ]]; then
      curl https://bootstrap.pypa.io/get-pip.py | sudo "$python3"
      pip3=$(compgen -c pip3 || compgen -c pip-3 | sort -rV | head -n 1)
    fi
  fi
  [[ -z $pip3 ]] && return 1
  sudo "$(type -P "$pip3")" install --upgrade neovim
}

install_neovim() {
  tmp=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX")
  [[ -z $tmp ]] && exit 1
  trap "rm -rf $(printf %q "$tmp")" EXIT
  cd "$tmp" || exit 1
  git clone https://github.com/neovim/neovim.git --depth=1
  cd neovim
  rm -rf build/
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$DOTFILES_LOCAL" CMAKE_BUILD_TYPE=Release
  make install
}

install_python_neovim
install_neovim
