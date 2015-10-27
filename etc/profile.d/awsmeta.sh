# bash

# AWSのメタデータ取得コマンド
awsmeta() {
  local v ret=0
  for v in "$@"; do
    curl --connect-timeout 2 -sf "http://169.254.169.254/latest/meta-data/$v" 2>/dev/null | perl -pe's/\n*$/\n/'
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
    local f; while read f; do
      [[ -n $f && $f == $basename* ]] && COMPREPLY+=("$path$f")
    done < <(awsmeta "$path")
    # 確定候補が/終わりなら次の補完を継続できるように空白挿入を抑止する
    [[ ${#COMPREPLY[@]} == 1 && $COMPREPLY =~ /$ ]] && compopt -o nospace
    # メニュー補完の場合はパス部分を除いたリストで表示する
    if [[ $COMP_TYPE == 63 ]]; then
      local i; for ((i = 0; i < ${#COMPREPLY[@]}; i++)); do
        COMPREPLY[$i]="${COMPREPLY[i]:${#path}}"
      done
    fi
  }
  complete -F _awsmeta awsmeta
fi
