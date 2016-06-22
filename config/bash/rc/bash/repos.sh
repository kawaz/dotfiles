# only intaractive
[[ $- == *i* ]] || return 0

# peco で移動
cd-repos() {
  local d
  local repos="${XDG_DATA_HOME:-~/.local/share}/repos"
  d=$(cd "$repos" && for d in */*/*/.git; do echo "${d%/.git}"; done | peco --select-1 --layout bottom-up --query "$READLINE_LINE$*")
  if [[ -n $d ]]; then
    READLINE_LINE="cd $(printf %q "$repos/$d")"
    READLINE_POINT=${#READLINE_LINE}
  fi
}

# C-s で即移動開始（別途 stty stop undef でデフォルトの C-s の機能を殺しておく必要あり）
bind -x '"\C-s": "cd-repos"'

