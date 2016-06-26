# only interactive
[[ $- == *i* ]] || return 0

# ! の入力で変な挙動になるのを防止する（History Expantion機能の無効化）
set +H

# 履歴にコマンド実行時刻を記録する http://qiita.com/kawaz/items/92457e3d1664383b18bc
HISTTIMEFORMAT='%Y-%m-%dT%T%z '

# 履歴の最大保存行数(オンメモリの行数) (default:500)
HISTSIZE=50000

# 履歴の最大保存行数($HISTFILEに保存される行数)
HISTFILESIZE=50000

# 以下の3つの値が設定可能（空or不正値は無視される）
# - ignorespace: スペースで始まっている行は履歴に保存しないようにする
# - ignoredups: 全く同じコマンドが連続して実行された場合に履歴は一つしか保存しないようにする
# - ignoreboth: ignorespaceとignoredupsの両方を設定したのと同じ意味
# ホントは邪魔なので消したいとこだが、トラブル時のセルフ監査で情報欠落は困るので基本全部残す
HISTCONTROL=

# 履歴に保存しないパターンをコロン区切りで書く
# ファイルに保存しないだけなら積極的に消してくんだがオンメモリの履歴にも残らないのはこまるので未指定一択
# 例えば df を無視すると df<Enter> して <Up><Enter> とかで同じコマンドの繰り返しが出来なくなる…
HISTIGNORE=

# 自前の history_push で保存するのでデフォルトの ~/bash_history 保存は無効化
HISTFILE=

# 履歴をタイムスタンプ付きで綺麗に保存する
history_push() {
  local s=$?
  if [[ -z $history_push_current_session ]]; then
    history_push_current_session="$(date +%s)_$$_$BASH_SUBSHELL"
  fi
  if [[ $(HISTTIMEFORMAT='' history 1) =~ ^\ *([0-9]+)[$' \t\n']+(.+)$ ]]; then
    if [[ ${BASH_REMATCH[1]} != "$history_push_prev" ]]; then
      history_push_prev=${BASH_REMATCH[1]}
      local ms ymd d f
      read -r ms ymd <<<"$(date +%s%3N\ %Y%m%d)"
      d="${XDG_DATA_HOME:-~/.local/share}/bash/history"
      f="$d/history-$ymd.$history_push_current_session"
      [[ -d $d ]] || mkdir -p "$d"
      echo "$ms $(printf %q "${BASH_REMATCH[2]}")" >> "$f"
    fi
  fi
  return $s
}

if [[ ";$PROMPT_COMMAND;" != *";history_push;"* ]]; then
  PROMPT_COMMAND="history_push${PROMPT_COMMAND:+";$PROMPT_COMMAND"}"
fi

# C-r の履歴検索をハック
if type peco >/dev/null 2>&1; then
  readline_search_history_hack_select() {
    local f ts line count allline=$'\n'
    # tac が使えなかったら代替でperl使えるようにしておく
    if ! type tac >/dev/null 2>&1; then
      tac() { perl -pe'print reverse <>'; }
    fi
    { # 新しい順に並べる（ただしカレントセッション優先）
      for f in "$XDG_DATA_HOME"/bash/history/history-*."$history_push_current_session"; do
        echo "$f"
      done | tac
      for f in "$XDG_DATA_HOME"/bash/history/history-*; do
        [[ $f != *."$history_push_current_session" ]] && echo "$f"
      done | tac
    } |
    { # HISTSIZEの数だけ取り出す
      count=0
      while (( count < ${HISTSIZE:-500} )) && read -r f; do
        [[ -f $f ]] || continue
        while (( count < ${HISTSIZE:-500} )) && read -r ts line; do
          eval "line=$line"
          if [[ $line == *$'\n'* ]]; then
            line="$(printf %q "$line") #MULTILINE_HISOTRY"
          fi
          # どうでも良い行は除外
          [[ $line =~ ^(ls|pwd|ps|top|fg|df)(\ [^;\|<>]*)?$ ]] && continue
          # 重複削除
          [[ $allline == *$'\n'"$line"$'\n'* ]] && continue
          allline+="$line"$'\n'
          (( count += 1 ))
          # 時間を見やすくすると遅いので対策検討中
          echo "$ts $line"
        done < <(tac "$f")
      done
    } |
    # 既に何か入力中でかつ行末カーソルなら先頭一致でフィルタ

    if [[ -n $READLINE_LINE && ${#READLINE_LINE} == "$READLINE_POINT" ]]; then
      while read -r line; do
        [[ ${line#* } == "$READLINE_LINE"* ]] && printf '%s\n' "$line"
      done |
      # フィルタ済みなのでデフォルトクエリ無しでpecoる
      peco --select-1 --layout=bottom-up
    else
      # 入力済みの文字をデフォルトクエリに入れてpecoる
      peco --select-1 --layout=bottom-up --query "${READLINE_LINE:+$READLINE_LINE }"
    fi |
    # １行で十分です
    head -n1 |
    # タイムスタンプ除去
    perl -pe's/^.*? //'
  }
  readline_search_history_hack() {
    local histline
    histline=$(readline_search_history_hack_select 2>/dev/null)
    if [[ $histline == *" #MULTILINE_HISOTRY" ]]; then
      eval "histline=${histline% #MULTILINE_HISOTRY}"
    fi
    # なんか選択されてたらターミナルに反映
    if [[ -n $histline ]]; then
      READLINE_LINE=$histline
      READLINE_POINT=${#histline}
    fi
  }
  # キーバインド登録
  bind -x '"\C-r": readline_search_history_hack'
fi
