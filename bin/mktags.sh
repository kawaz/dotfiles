#!/bin/sh
bin="`dirname "$0"`"
skel="$bin/../skel" || exit 1
test -d "$skel" || exit 1

mkdir -p "$skel/.vim/tags" || exit 1
# PEAR
ctags -f "$skel/.vim/tags/pear.tags" --langmap=PHP:.php --php-types=c+f `find /usr/share/pear/ -name '*.php' | egrep -v '/(example|test)'`
