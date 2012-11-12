#!/bin/sh
. "`dirname -- "$0"`"/functions.sh || exit

# install nvm
git clone git://github.com/creationix/nvm.git ~/nvm
( cd ~/nvm && git pull --rebase )
. ~/.nvm/nvm.sh

# install stable node
node_stable=$(curl -s http://nodejs.org/dist/ | egrep -o '[0-9]+\.[0-9]*[02468]\.[0-9]+' | sort -u -k 1,1n -k 2,2n -k 3,3n -t . | tail -n1)
nvm install "v$node_stable"
nvm alias stable "v$node_stable"
nvm alias default stable

# install unstable node
if [ "$1" == "unstable" ]; then
  node_unstable=$(curl -s http://nodejs.org/dist/ | egrep -o '[0-9]+\.[0-9]*[13579]\.[0-9]+' | sort -u -k 1,1n -k 2,2n -k 3,3n -t . | tail -n1)
  nvm install "v$node_unstable"
  nvm alias unstable "v$node_unstable"
fi

# install misc
nvm use "v$node_stable"
npm install -g coffee-script JSONPathCLI forever grunt

# startup script is $DOTFILES_DIR/etc/profile.d/20-nvm.sh
