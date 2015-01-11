# bash

# brew install go されたMac用
if [[ -d /usr/local/opt/go/libexec ]]; then
  [[ -d ~/.gopath ]] || mkdir -p ~/.gopath
  export GOROOT=/usr/local/opt/go/libexec
  export GOPATH=~/.gopath
  export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
fi
