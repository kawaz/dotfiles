#!/bin/sh
bin="`dirname "$0"`"
env="$bin/../env"

mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
src="$env/src/git"
dest="$env/dest/git"
profile_d="$env/profile.d"
mkdir -p "$src" "$dest" "$profile_d" || exit 1

requires="expat-devel perl-ExtUtils-MakeMaker gettext autoconf zlib-devel libcurl-devel"
if ! rpm -q $requires; then
  echo "yum install $requires"
  exit 1
fi

if [ ! -d "$src/.git" ]; then
  git clone git://github.com/gitster/git.git "$src" || exit 1
fi
cd "$src" || exit 1
git pull --rebase

make configure && ./configure --prefix="$dest" && make && make install || exit 1

( echo "export PATH=\"$dest/bin:\$PATH\""
  echo "if [ -r \"$src/contrib/completion/git-completion.bash\" ]; then "
  echo "  . \"$src/contrib/completion/git-completion.bash\""
  echo "fi"
) > "$profile_d"/10-git.sh
