# Mac以外では無視
[[ "${OSTYPE:0:6}" != "darwin" ]] && return

# coreutils
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# findutils
alias find=gfind
alias xargs=gxargs

# bash_completion
if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  . $(brew --prefix)/share/bash-completion/bash_completion
fi

# DOCKER_HOSTを設定する
if type boot2docker >/dev/null 2>&1; then
  export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375
fi

# awscli completion
if [[ -x /usr/local/bin/aws_completer ]]; then
  complete -C '/usr/local/bin/aws_completer' aws
fi
