#!bash
#
# bash completion support for ghq(https://github.com/motemen/ghq)
#

_ghq() {
  local cur prev
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}
  COMPREPLY=()
  if (( $COMP_CWORD <= 1)) || [[ "$cur" == -* ]]; then
    COMPREPLY=( $(compgen -W "$(ghq help | sed -n -e '/COMMANDS:/,/GLOBAL OPTIONS:/p' | sed -n -e 's/   \([a-z]*\).*/\1/p')" -- $cur) );
    return 0;
  elif [ $COMP_CWORD = 2 ]; then
    if [ "$prev" = "look" ]; then
      COMPREPLY=( $(compgen -W "$(ghq list)" -- $cur) );
      return 0;
    fi
  fi
}
complete -F _ghq -o default ghq
