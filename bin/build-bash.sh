#!/usr/bin/env bash
install_bash() {
  cache_dir=$1; shift
  tmp_dir=$1; shift
  if [[ -z $cache_dir || -z $tmp_dir || $# == 0 ]]; then
    echo "Usage: $0 dest_dir tmp_dir version [version..]" >&2
    echo "list remote:" >&2
    curl -sL http://ftp.gnu.org/gnu/bash/|grep -oE 'bash-[0-9][0-9]*\.[0-9a-z]+'|sed 's/.*-//'|sort|uniq >&2
    exit 1
  fi

  set -e

  [[ -d $cache_dir ]] || mkdir -p "$cache_dir"
  cache_dir=$(cd "$cache_dir" && pwd)
  [[ -n $cache_dir ]]

  [[ -d $tmp_dir ]] || mkdir -p "$tmp_dir"
  tmp_dir=$(cd "$tmp_dir" && pwd)
  [[ -n $tmp_dir ]]

  for v in "$@"; do
    bash_src="$tmp_dir/bash-${v}"
    bash_dest="$cache_dir/bash-${v}"
    [[ -x $bash_dest/bin/bash ]] && continue
    (
    set -e
    # download source
    rm -rf "$bash_src"
    mkdir -p "$bash_src"
    cd "$bash_src"
    curl -sL "http://ftp.gnu.org/gnu/bash/bash-$v.tar.gz" | tar xz -C "$bash_src" --strip=1
    # patches
    seq -w 999 |
    while read -r p; do
      pfile="bash${v//./}-$p"
      [[ -s $pfile ]] && continue
      wget -qO "$pfile" "http://ftp.gnu.org/gnu/bash/bash-$v-patches/$pfile" || :
      if [[ ! -s "$pfile" ]]; then
        rm -f "$pfile"
        break
      fi
      patch -p0 < "$pfile"
    done
    # build
    ./configure --prefix="${bash_dest}"
    make
    make install
    ) || :
  done
}

tmp=$(mktemp -d "${TMPDIR:-/tmp}/build-bash.XXXXXXXXXX")
ver=4.4
install_bash "${XDG_CACHE_HOME:-~/.cache}" "$tmp" "$ver"
ln -sfn "${XDG_CACHE_HOME:-~/.cache}/bash-$ver/bin/bash" "${XDG_CACHE_HOME:-~/.cache}/dotfiles/bin/bash"
