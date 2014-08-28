# bash

# brew install go されたMac用
if [[ -d /usr/local/opt/go/libexec ]]; then
  export GOROOT=/usr/local/opt/go/libexec
  export GOPATH=~/.gopath
  export PATH=$GOPATH/bin:$PATH
fi
