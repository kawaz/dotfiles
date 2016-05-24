ssh-over-r3() { ssh -o 'ProxyCommand ssh -W %h:%p r3' "$@"; }; complete -F _ssh ssh-over-r3
ssh-over-r16() { ssh -o 'ProxyCommand ssh -W %h:%p r16' "$@"; }; complete -F _ssh ssh-over-r16
ssh-over-r17() { ssh -o 'ProxyCommand ssh -W %h:%p r17' "$@"; }; complete -F _ssh ssh-over-r17
