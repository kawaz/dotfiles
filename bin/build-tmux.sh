#!/bin/sh
base="`dirname "$0"`/.."; base="`cd "$base";pwd`"
env="$base/env"

mkdir -p "$env" && cd "$env" || exit 1
env="`pwd`"
src="$env/src/tmux"
dest="$env/dest/tmux"
profile_d="$env/profile.d"
mkdir -p "$profile_d"

requires="automake libevent-devel ncurses-devel"
if ! rpm -q $requires >/dev/null 2>&1; then
  echo "yum install $requires"
  exit 1
fi

# develop version
rm -rf "$src"
git clone git://tmux.git.sourceforge.net/gitroot/tmux/tmux "$src"
cd "$src" || exit 1

# 参考：罫線パッチ http://d.hatena.ne.jp/emonkak/20110521/1305970697
patch -p1 < "$base/bin/build-tmux.sh.border_patch"

#libevent2が必要なので1.xしか無い場合はソースで入れる
if rpm -q libevent-devel-1.\* >/dev/null 2>&1; then
  ( src="$env/src/libevent2"; mkdir -p "$src" && cd "$src" || exit 1
    curl -L https://github.com/downloads/libevent/libevent/libevent-2.0.20-stable.tar.gz | tar xz
    cd libevent-2.0.20-stable || exit 1
    ./configure --prefix="$env/dest/libevent2" && make && make install
  ) || exit 1
  export CPPFLAGS="-I$env/dest/libevent2/include"
  export LDFLAGS="-L$env/dest/libevent2/lib"
  echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:$env/dest/libevent2/lib\"" > "$profile_d"/10-tmux-libevent2.sh
  . "$profile_d"/10-tmux-libevent2.sh
fi

sh autogen.sh || exit 1
./configure --prefix="$dest" && make && make install

echo "export PATH=\"$dest/bin:\$PATH\"" > "$profile_d"/10-tmux.sh
