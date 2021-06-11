# プロンプトの設定
if command -v starship >/dev/null; then
  . <(starship init bash)
else
  export PS1='$(r=$?;x="$(__git_ps1 2>/dev/null) ";echo "${x## }";exit $r)$([[ $? == 0 ]]&&echo "\[\e[1;34m\]"||echo "\[\e[1;31m\]")[\u@\h \W]\$\[\e[m\] '
  GIT_PS1_SHOWUPSTREAM=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWDIRTYSTATE=1
fi
