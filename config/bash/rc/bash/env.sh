export LANG="ja_JP.UTF-8"
export PAGER="less -R"

if type -p nvim >/dev/null; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi
