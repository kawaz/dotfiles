_known_hosts_real_hook_before() {
  #echo ==========; set | egrep '^(C|c)' | grep -v cursor; return 0
  return 0
  echo; echo "$FUNCNAME"
  set | grep ^COMP
}
_known_hosts_real_hook_after()
{
  _zunlib_completion_select_with_peco -s -u
}

# select complete target by peco
_zunlib_completion_select_with_peco() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  # check: peco exists
  type peco >/dev/null 2>&1 || return 0
  # check: occasion
  [[ $COMP_TYPE == 9 && ${#COMPREPLY[@]} -gt 1 ]] || return 0
  # check: can still auto completion?
  _zunlib_equals_all_same_index_char "${#cur}" "${COMPREPLY[@]}" && return 0
  # main logic
  local opt filter="cat"
  while getopts us opt; do
    case "$opt" in
      s)  filter="sort";;
      u)  filter="sort -u"; break;;
    esac
  done
  local IFS0=$IFS IFS=$'\n'
  COMPREPLY=($(eval "$filter" <<< "${COMPREPLY[*]}" | peco --query "$cur"))
  IFS=$IFS0
  # Call recursive, because peco's result may be multiple.
  "$FUNCNAME"
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
