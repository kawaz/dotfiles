#!/usr/bin/env bash
set -e
sudo yum -y install libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip git

pip3_path() {
  local pip3 py3_ver
  if type -P pip3 >/dev/null 2>&1; then
    pip3=pip3
  else
    py3_ver=$(yum list python3\*-devel -q | grep -Eo '^python3[0-9]+' | sort | tail -n1)
    [[ -z $py3_ver ]] && return 1
    sudo yum install -y "${py3_ver}"-devel
    if yum list "${py3_ver}-pip" >/dev/null 2>&1; then
      sudo yum install -y "${py3_ver}"-pip
      pip3=$(rpm -ql "${py3_ver}-pip" | grep -Eo '^([/a-z]*)/bin/pip.*?3.*' | head -n1)
    else
      curl https://bootstrap.pypa.io/get-pip.py | sudo "$py3_ver"
      if type -P pip3 2>/dev/null; then
        pip3=pip3
      fi
    fi
  fi
  [[ -z $pip3 ]] && return 1
  type -P "$pip3"
}

# build nvim
{
  tmp=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX")
  [[ -z $tmp ]] && exit 1
  trap "rm -rf $(printf %q "$tmp")" EXIT
  cd "$tmp" || exit 1
  git clone https://github.com/neovim/neovim.git --depth=1
  cd neovim
  rm -rf build/
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$DOTFILES_DIR/local" CMAKE_BUILD_TYPE=Release
  make install
}

# pip install neovim
sudo "$(pip3_path)" install --upgrade neovim
