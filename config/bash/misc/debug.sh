msec() {
  local d
  d=$(PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/bin:/bin type -p date)
  if [[ $("$d" +%N) == [0-9]* ]]; then
    eval "msec() { $d +%s%3N; }"
  else
    msec() { date +%s000; }
  fi
  msec
}

source() {
  local s ts te
  ts=$(msec)
  eval 'builtin . "$@"'
  s=$?
  te=$(msec)
  printf "%5d %q\n" $((te-ts)) "$1"
  return "$s"
}
eval '.() { source "$@"; }'

unset -v BASHRC_DEBUG
for _ in "$@"; do
  # shellcheck disable=SC1090
  . "$_"
done
unset -f source .
