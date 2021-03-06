#!/usr/bin/env bash
set -e
[[ -z $DOTFILES_LOCAL ]] && { echo "\$DOTFILES_LOCAL is empty" >&2; exit 1; }
sudo yum -y install libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip git

search_bin() {
  local prog=$1 ver=$2 bin
  bin=$( (compgen -c "$prog$ver" || compgen -c "$prog-$ver") | grep '[0-9]$' | sort -rV | head -n 1 )
  if [[ -n $bin ]]; then
    type -P "$bin"
  fi
}

install_python_neovim() {
  local pip3 python3
  pip3=$(search_bin pip 3)
  if [[ -z $pip3 ]]; then
    python3=$(search_bin python 3)
    if [[ -z $python3 ]]; then
      py3_ver=$(yum list python3\*-devel -q | grep -Eo '^python3[0-9]+' | sort | tail -n1)
      if [[ -n $py3_ver ]]; then
        sudo yum install -y "${py3_ver}"{,-{devel,pip}}
      else
        install_python3
      fi
      python3=$(search_bin python 3)
      pip3=$(search_bin pip 3)
    fi
    if [[ -z $pip3 && -n $python3 ]]; then
      curl https://bootstrap.pypa.io/get-pip.py | sudo "$python3"
      pip3=$(search_bin pip 3)
    fi
  fi
  [[ -z $pip3 ]] && return 1
  sudo "$(type -P "$pip3")" install --upgrade neovim
}

install_python3() {
  tmp=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX")
  [[ -z $tmp ]] && exit 1
  trap "rm -rf $(printf %q "$tmp")" EXIT
  cd "$tmp" || exit 1
  sudo yum -y groupinstall "Development tools"
  sudo yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel
  curl https://www.python.org/ftp/python/3.6.0/Python-3.6.0a1.tgz | tar xz -C . --strip=1
  ./configure --prefix="$DOTFILES_LOCAL"
  make
  make altinstall
  # make symlink for python3
  python3=$(search_bin python 3)
  if [[ -n $python3 && ! -x $DOTFILES_LOCAL/bin/python3 ]]; then
    ln -sfn "$python3" "$DOTFILES_LOCAL/bin/python3"
  fi
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
