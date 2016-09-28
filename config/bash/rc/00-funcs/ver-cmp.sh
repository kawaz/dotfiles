ver-cmp() {
  local ls=(${1//[^0-9]/ }) rs=(${3//[^0-9]/ }) i op1 op2
  [[ -z ${ls[0]}${rs[0]} ]] && return 1
  case "$2" in
    eq|==) op1='' op2===;;
    ge|\>=) op1=\> op2=\>=;;
    le|\<=) op1=\< op2=\<=;;
    ne|\!=) ! "${FUNCNAME[0]}" "$1" eq "$3"; return;;
    gt|\>) ! "${FUNCNAME[0]}" "$1" le "$3"; return;;
    lt|\<) ! "${FUNCNAME[0]}" "$1" ge "$3"; return;;
    *) return 1
  esac
  for (( i = 0; i < ${#ls[@]} || i < ${#rs[@]}; i++ )); do
    [[ -n $op1 ]] && { eval "(( 10#\${ls[i]} $op1 10#\${rs[i]} ))" && return 0; } #十分条件
    [[ -n $op2 ]] && { eval "(( 10#\${ls[i]} $op2 10#\${rs[i]} ))" || return 1; } #必要条件
  done
}
# 引数が1つなら $BASH_VERSION と比較
ver-eq() { [[ $# == 1 ]] && set -- "$BASH_VERSION" "$1"; ver-cmp "$1" eq "$2"; }
ver-ne() { [[ $# == 1 ]] && set -- "$BASH_VERSION" "$1"; ver-cmp "$1" ne "$2"; }
ver-ge() { [[ $# == 1 ]] && set -- "$BASH_VERSION" "$1"; ver-cmp "$1" ge "$2"; }
ver-gt() { [[ $# == 1 ]] && set -- "$BASH_VERSION" "$1"; ver-cmp "$1" gt "$2"; }
ver-le() { [[ $# == 1 ]] && set -- "$BASH_VERSION" "$1"; ver-cmp "$1" le "$2"; }
ver-lt() { [[ $# == 1 ]] && set -- "$BASH_VERSION" "$1"; ver-cmp "$1" lt "$2"; }
