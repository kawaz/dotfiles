ghq-cd() { local d=$(peco --select-1 --layout bottom-up < <(ghq list "$@")); cd "${d:+$HOME/.ghq/$d}"; }
alias ghcd=ghq-cd
# ソースファイルは全部ここに集める
export GHQ_ROOT="${XDG_DATA_HOME:-~/.local/share}/repos"

  fi
}
