# bash

# brew install go されたMac用にPATHを通す
if [[ -d /usr/local/opt/go/libexec/bin && ":$PATH:" != *":/usr/local/opt/go/libexec/bin:"* ]]; then
  export PATH=$PATH:/usr/local/opt/go/libexec/bin
fi

if [[ -z $GOPATH ]] && type -p go >/dev/null; then
  export GOPATH="${XDG_DATA_HOME:-~/.local/share}/gopath"
fi

if [[ -n $GOPATH && ":$PATH:" != *":$GOPATH/bin:"* ]]; then
  export PATH="$PATH:$GOPATH/bin"
fi
