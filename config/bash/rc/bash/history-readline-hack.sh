readline_search_history_hack() {
  local histline=$(
    # 時間表示と履歴番号を削除
    HISTTIMEFORMAT= history | perl -pe's/^ *[0-9]+ *//' |
    # tac が使えなかったら代替でperl使う
    if type taxc >/dev/null 2>&1; then tac; else perl -pe'print reverse <>'; fi |
    # 重複行を削除
    awk '!x[$0]++' |
    # 既に何か入力中でかつ行末カーソルなら先頭一致でフィルタ
    if [[ -n $READLINE_LINE && ${#READLINE_LINE} == $READLINE_POINT ]]; then
      while read -r line; do
        [[ $line == $READLINE_LINE* ]] && printf $'%s\n' "$line"
      done |
      # フィルタ済みなのでデフォルトクエリ無しでpecoる
      peco --select-1 --layout=bottom-up
    else
      # 入力済みの文字をデフォルトクエリに入れてpecoる
      peco --select-1 --layout=bottom-up --query "${READLINE_LINE:+$READLINE_LINE }"
    fi |
    # １行で十分です
    head -n1
  )
  # なんか選択されてたらターミナルに反映
  if [[ -n $histline ]]; then
    READLINE_LINE=$histline
    READLINE_POINT=${#histline}
  fi
}
# キーバインド登録（pecoがある時のみ）
if type peco >/dev/null 2>&1; then
  bind -x '"\C-r": readline_search_history_hack'
fi
