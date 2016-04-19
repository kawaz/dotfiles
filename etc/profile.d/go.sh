# bash

for GOROOT in /usr/local/opt/go/libexec "${XDG_DATA_HOME:-~/.local/share}/go"; do
  echo $GOROOT
  if [[ -d $GOROOT && ":$PATH:" != *":$GOROOT/bin:"* ]]; then
    export PATH=$PATH:$GOROOT/bin
    break
  fi
done
unset GOROOT

if [[ -z $GOPATH ]] && type -p go >/dev/null; then
  export GOPATH="${XDG_DATA_HOME:-~/.local/share}/gopath"
fi

if [[ -n $GOPATH && ":$PATH:" != *":$GOPATH/bin:"* ]]; then
  export PATH="$PATH:$GOPATH/bin"
fi
