#!/bin/bash
. "`dirname -- "$0"`"/functions.sh || exit

# install nvm
git clone git://github.com/creationix/nvm.git ~/.nvm
( cd ~/.nvm && git pull )
. ~/.nvm/nvm.sh

# install stable node
node_stable=$(curl -s http://nodejs.org/dist/ | egrep -o '[0-9]+\.[0-9]*[02468]\.[0-9]+' | sort -u -k 1,1n -k 2,2n -k 3,3n -t . | tail -n1)
if ls /lib/libc.so* -l | egrep -q 'libc-2\.[0-5]\.'; then
  # 最近のnvmはバイナリを落とそうとするがglibcが2.5以下だと動かないので該当する場合はソースビルドさせる
  has_rpm_packages gcc-c++ || exit 1
  if python -V 2>&1 | grep -q ' 2\.4' && which python26 2>/dev/null; then
    # nodeのビルドスクリプトがpython2.4だと動かないのでpython26があればそれを使わせる
    cd_tmpdir && (ln -s `which python26` python; PATH="`pwd`:$PATH" nvm install -s "v$node_stable")
  else
    nvm install -s "v$node_stable"
  fi
else
  nvm install "v$node_stable"
fi
nvm alias stable "v$node_stable"
nvm alias default stable

# install unstable node
if [[ "$1" == "unstable" ]]; then
  node_unstable=$(curl -s http://nodejs.org/dist/ | egrep -o '[0-9]+\.[0-9]*[13579]\.[0-9]+' | sort -u -k 1,1n -k 2,2n -k 3,3n -t . | tail -n1)
  nvm install "v$node_unstable"
  nvm alias unstable "v$node_unstable"
fi

# install misc
nvm use "v$node_stable"
npm install -g coffee-script JSONPathCLI forever grunt-cli bower yo

# startup script is $DOTFILES_DIR/etc/profile.d/20-nvm.sh
