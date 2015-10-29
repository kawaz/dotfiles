_known_hosts_real_hook_before() {
  #echo ==========; set | egrep '^(C|c)' | grep -v cursor; return 0
  return 0
  echo; echo "$FUNCNAME"
  set | grep ^COMP
}
_known_hosts_real_hook_after() {
  if [[ $COMP_TYPE == 9 && ${#COMPREPLY[@]} -gt 1 ]]; then
    if ! _zunlib_equals_all_same_index_char "${#COMP_WORDS[COMP_CWORD]}" "${COMPREPLY[@]}"; then
      local IFS=$'\n'
      local pecoout=$(sort -u<<<"${COMPREPLY[*]}"|peco --query "$cur")
      if [[ -n $pecoout ]]; then
        COMPREPLY=($pecoout)
      fi
    fi
  fi
}

_zunlib_equals_all_same_index_char() {
  local pos=$1; shift
  local c=${1:$pos:1} w=
  for w in "$@"; do
    if [[ $c != ${w:$pos:1} ]]; then
      return 1
    fi
  done
  return 0
}
