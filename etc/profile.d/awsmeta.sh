# bash

# AWSのメタデータ取得コマンド
awsmeta() {
  local v ret=0
  for v in "$@"; do
    curl -sf "http://169.254.169.254/latest/meta-data/$v" 2>/dev/null | perl -pe's/\n*$/\n/'
    [[ $PIPESTATUS != 0 ]] && { ret=1; echo; }
  done
  return $ret
}

# 補間関数
if [[ -n "$PS1" ]]; then
  _awsmeta() {
    # :で引数が分割されないようにする（）
    local COMP_WORDBREAKS0=$COMP_WORDBREAKS
    COMP_WORDBREAKS=${COMP_WORDBREAKS//:/}
    # COMP系変数をパースする
    local cur prev words cword
    _get_comp_words_by_ref cur prev words cword
    # curからCOMPREPLYを作る
    COMPREPLY=()
    local path=$(perl -pe's/[^\/]+?$//'<<<"$cur")
    local basename=${cur##*/}
    local f
    while read f; do
      [[ "$path$f" == $cur* ]] && COMPREPLY+=("$path$f")
    done < <(awsmeta "$path")
    # 確定ワードが/終わりの時はスペースを足さない
    [[ ${#COMPREPLY[@]} == 1 && $COMPREPLY =~ /$ ]] && compopt -o nospace
  }
  complete -F _awsmeta awsmeta
fi
