# ソースファイルは全部ここに集める
export GHQ_ROOT="${XDG_DATA_HOME:-~/.local/share}/repos"

# peco で移動
ghq-cd() {
  local d
  d=$(cd "$GHQ_ROOT" && for d in */*/*/.git; do echo "${d%/.git}"; done | peco --select-1 --layout bottom-up --query "$READLINE_LINE$*")
  if [[ -n $d ]]; then
    cd "$GHQ_ROOT/$d" || return 1
  fi
}
alias ghcd='ghq-cd'

# C-s で即移動開始（別途 stty stop undef でデフォルトの C-s の機能を殺しておく必要あり）
bind -x '"\C-s": "ghq-cd"'
