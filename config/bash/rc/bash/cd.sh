# cd fileでそのfileのあるディレクトリに移動する http://bit.ly/1dABtoO
function cd() {
  if [[ -e $1 && ! -d $1 ]]; then
    builtin cd -- "$(dirname -- "$1")"
  else
    builtin cd "$@"
  fi
  # historyにフルパスで履歴を残す http://inaz2.hatenablog.com/entry/2014/12/11/015125
  local ret=$?
  if [[ ($ret -eq 0) && (${#FUNCNAME[*]} -eq 1) ]]; then
    history -s "cd $(printf "%q" "$PWD")"
  fi
  return $ret
}

