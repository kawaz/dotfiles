# ~/.bashrc から ./bashrc を直接読むといつもの環境が一発で出来るが、
# 他の人もログインする共用サーバの共用ユーザとかだと個人的な設定はしづらい。
# その場合はこの dotfiles.sh を ~/.bashrc から読むようにすれば自動適用されないので便利です。
dotfiles-on() {
  eval "${FUNCNAME[0]}() { :; }"
  # shellcheck disable=SC1090
  . "$(dirname "${BASH_SOURCE[0]}")/bashrc"
}

# $XMODIFIERS に @dotfiles=on を含んでいたら自動適用します。
# この環境変数は ssh の接続元から引き継げるので自動的用に利用しています。
# bashrc 無いで
if [[ $XMODIFIERS == *"@dotfiles=on"* ]]; then
  dotfiles-on
fi
