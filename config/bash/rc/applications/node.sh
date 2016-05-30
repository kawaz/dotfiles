if [[ -f ~/.nvm/nvm.sh ]]; then
  # nvm.sh の読込みは糞遅いので遅延させる
  node() { _node_lazy_init; "${FUNCNAME[0]}" "$@"; }
  nvm() { _node_lazy_init; "${FUNCNAME[0]}" "$@"; }
  npm() { _node_lazy_init; "${FUNCNAME[0]}" "$@"; }
  _nvm_completion() { _node_lazy_init; "${FUNCNAME[0]}" "$@"; }
  _npm_completion() { _node_lazy_init; "${FUNCNAME[0]}" "$@"; }
  complete -F _nvm_completion nvm
  complete -F _npm_completion npm
  _node_lazy_init() {
    unset -f node nvm npm _nvm_completion _npm_completion
    complete -r nvm npm
    # shellcheck disable=SC1090
    {
      . ~/.nvm/nvm.sh
      . ~/.nvm/bash_completion
      . <(npm completion)
    }
  }
fi
