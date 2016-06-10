alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# 可能な限り好みのls出力にする
if ls -d -N >/dev/null 2>&1; then
  # 最近の gnubin/ls が勝手にファイル名をクオート出力してくるのを抑止
  alias ls='ls --color --time-style +%Y-%m-%d\ %H:%M:%S.%3N -N'
elif ls -d --time-style +%Y-%m-%d\ %H:%M:%S.%3N >/dev/null 2>&1; then
  # デフォの時間表示は見難いのでISOぽくする(full-iso,long-iso,isoは帯に短し襷に長しなのでカスタム)
  alias ls='ls --color --time-style +%Y-%m-%d\ %H:%M:%S.%3N'
elif ls -d --color >/dev/null 2>&1; then
  # せめて色だけでも…
  alias ls='ls --color'
fi

alias grep='grep --color'
alias egrep='egrep --color'

alias du0='du --max-depth=1'
alias du1='du --max-depth=1'

alias last-itumono='last -adixFw'
