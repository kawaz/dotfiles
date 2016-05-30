#!/usr/bin/env bash
set -e
sudo yum install -y perl-ExtUtils-MakeMaker expat-devel gettext autoconf zlib-devel
sudo yum install -y libcurl-devel || sudo yum install -y curl-devel

tmp=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX")
[[ -n $tmp ]] && cd "$tmp" || exit 1

git clone --depth=1 git://github.com/gitster/git.git
cd git
make configure
./configure --prefix="$DOTFILES_DIR/local"
make
make install

# cleanup
rm -rf "$tmp"
