ghq-cd() { local d=$(peco --select-1 --layout bottom-up < <(ghq list "$@")); cd "${d:+$HOME/.ghq/$d}"; }
alias ghcd=ghq-cd
# ソースファイルは全部ここに集める
export GHQ_ROOT="${XDG_DATA_HOME:-~/.local/share}/repos"

  fi
}

# C-s で即移動開始（別途 stty stop undef でデフォルトの C-s の機能を殺しておく必要あり）
bind -x '"\C-s": "ghq-cd"'
