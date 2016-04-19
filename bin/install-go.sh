#!/bin/bash
set -e

case "${OSTYPE,,}" in
  linux*) OS=linux;;
  darwin*) OS=darwin;;
  freebsd*) OS=freebsd;;
  cygwin*|win*) OS=windows;;
  *) OS=;;
esac
case "$(uname -m)" in
	x86_64) ARCH=amd64;;
  armv*) ARCH=armv6l;;
  *) ARCH=;;
esac
if [[ -z $OS || -z $ARCH ]]; then
  echo "Can't detect os and archtecture" >&2
  exit 1
fi

TAG=$(git ls-remote --tags https://go.googlesource.com/go | grep -oE 'go[0-9\.]+$' | sort -V | tail -n1)
if [[ -z $TAG ]]; then
  echo "Can't detect latest version" >&2
  exit 1
fi

dest="${XDG_DATA_HOME:-/usr/local}/$TAG"
[[ ! -f $dest ]] && mkdir -p "$dest"
curl -L "https://storage.googleapis.com/golang/$TAG.$OS-$ARCH.tar.gz" | tar xz -C "$dest" --strip 1
ln -sfn "$TAG" "$(dirname "$dest")/go"
