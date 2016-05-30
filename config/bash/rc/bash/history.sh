# ! の入力で変な挙動になるのを防止する（History Expantion機能の無効化）
set +H

# 履歴にコマンド実行時刻を記録する http://qiita.com/kawaz/items/92457e3d1664383b18bc
HISTTIMEFORMAT='%Y-%m-%dT%T%z '

# 履歴の最大保存行数(オンメモリの行数) (default:500)
HISTSIZE=50000

# 履歴の最大保存行数(~/.bash_historyに保存される行数)
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

# 履歴ファイルを日付で分割保存
if [[ -n $XDG_DATA_HOME ]]; then
  test -d "$XDG_DATA_HOME/bash/history" || mkdir -p "$_"
  HISTFILE="$_/bash_history-$(date +%Y%m%d)"
fi
