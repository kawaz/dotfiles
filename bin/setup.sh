#!/bin/sh
cd "`dirname "$0"`"/.. || exit
git submodule update --init
sh ./bin/mklink.sh
vim -c ':NeoBundleInstall!' -c ':qa!'
sh ./bin/get-phpmanual.sh
sh ./bin/mkvimdic.sh
#sh ./bin/mkdircolors.sh
