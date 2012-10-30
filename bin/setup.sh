#!/bin/sh
cd "`dirname "$0"`"/.. || exit
git submodule update --init

git submodule add -f https://github.com/Shougo/neobundle.vim env/dot-vim/bundle/neobundle.vim
ln -sfn ../../env/dot-vim/bundle/neobundle.vim etc/skel/.vim
sh ./bin/mklink.sh
vim -c ':NeoBundleInstall' -c ':qa!'
sh ./bin/get-phpmanual.sh
sh ./bin/mkvimdic.sh
