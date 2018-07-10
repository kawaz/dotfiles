[[ $OSTYPE == darwin* ]] || return 0

alias netstat-enpt='lsof -nP -iTCP -sTCP:ESTABLISHED'
alias netstat-lnpt='lsof -nP -iTCP -sTCP:LISTEN'
alias netstat-anpt='lsof -nP -iTCP'
alias netstat-unp='lsof -nP -iUDP'
