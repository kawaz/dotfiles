type -P go >/dev/null || return 0

if [[ -z $GOROOT ]]; then
  for GOROOT in /usr/local/opt/go/libexec "${XDG_DATA_HOME:-~/.local/share}/go"; do
    if [[ -d $GOROOT && ":$PATH:" != *":$GOROOT/bin:"* ]]; then
      export GOROOT PATH=$PATH:$GOROOT/bin
      break
    fi
  done
fi
export GOPATH="${XDG_DATA_HOME:-~/.local/share}/gopath"

# $GOPATH/src は $XDG_DATA_HOME/repos へのsymlinkにする
[[ -d $GOPATH ]] || mkdir -p "$GOPATH"
[[ -h $GOPATH/src ]] || ln -sfn ../repos "$GOPATH/src"

# $GOPATH/bin に PATH を通す
if [[ -n $GOPATH && ":$PATH:" != *":$GOPATH/bin:"* ]]; then
  export PATH="$PATH:$GOPATH/bin"
fi
