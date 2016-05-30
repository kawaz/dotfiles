# 一時作業用コマンド http://bit.ly/22GF66y
tmpspace() {
  (
  d=$(mktemp -d "${TMPDIR:-/tmp}/${1:-tmpspace}.XXXXXXXXXX") && cd "$d" || exit 1
  "$SHELL"
  s=$?
  if [[ $s == 0 ]]; then
    rm -rf "$d"
  else
    echo "Directory '$d' still exists." >&2
  fi
  exit $s
  )
}
# typoで補完が出てこないのもストレスなのでaliasも作っておくことにした
alias tempspace=tmpspace

