#!/bin/sh
bin="`dirname "$0"`"
env="$bin/../env"

mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
src="$env/src/git"
dest="$env/dest/git"
mkdir -p "$src" "$dest" || exit 1

if [ ! -d "$src/.git" ]; then
  git clone git://github.com/gitster/git.git "$src" || exit 1
fi
cd "$src" || exit 1
git pull
sudo yum install -y curl-devel expat-devel perl-ExtUtils-MakeMaker gettext autoconf
make configure && ./configure --prefix="$dest" && make && make install || exit 1

mkdir -p ~/.profile.d || exit 1
( echo "export PATH=\"$dest/bin:\$PATH\""
  echo "if [ -r \"$src/contrib/completion/git-completion.bash\" ]; then "
  echo "  . \"$src/contrib/completion/git-completion.bash\""
  echo "fi"
) > ~/.profile.d/10-dotfiles-git.sh
