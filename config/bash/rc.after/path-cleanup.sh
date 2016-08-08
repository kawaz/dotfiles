#!/bin/bash
_() {
  local p0=() p1=() p2=() p3=() p ps
  while read -r p; do
    if [[ $ps != *":$p:"* ]]; then
      case "$p" in
        "$HOME"/bin)  p0+=("$p");;
        "$HOME"/*)    p1+=("$p");;
        /usr/local/*) p2+=("$p");;
        *)            p3+=("$p");;
      esac
      ps+=":$p:"
    fi
  done <<<"${PATH//:/$'\n'}"
  # 優先度付きでPATHをマージしてexport
  p=("${p0[@]}" "${p1[@]}" "${p2[@]}" "${p3[@]}")
  IFS=: eval 'export PATH="${p[*]}"'
}
_; unset -f _
