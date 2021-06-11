#!/bin/bash
lazycomp() {
  local f="_${FUNCNAME[0]}_$1"
  local q; eval "q=($(printf ' "%q"' "$f" "$@"))" || retrun $?
  if [[ "${!f}" == 1 ]]; then
    case $2 in
      -e)
        complete -r "$1"
        unset -f "$f"
        eval "${@:3}";;
      -c)
        if type "$3" >/dev/null; then
          complete -r "$1"
          unset -f "$f"
          . <("${@:3}")
        fi
        ;;
      -f)
        if eval "[[ -z z $(printf ' || -f %q' "${@:3}") ]]"; then
          complete -r "$1"
          unset -f "$f"
          local f
          for f in "${@:3}"; do
            if [[ -f "$f" ]]; then
              . "$f"
            fi
          done
        fi
    esac
    return $?
  else
    if [[ $2 == -[cef] ]]; then
      eval "$f(){ $f=1 ${FUNCNAME[0]} ${q[*]:1}; }"
      complete -F "$f" "$1"
    else
      echo "Usage: ${FUNCNAME[0]} name [ -e eval [arg...] ] [ -c command [arg...] ] [ -f file... ]" >&2
      echo "    This delays the registration of completions." >&2
      echo "    And when the completion for name is needed, the completion is registered and executed." >&2
      return 1
    fi
  fi
}
