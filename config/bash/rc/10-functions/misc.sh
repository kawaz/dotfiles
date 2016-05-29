# vim:foldmethod=syntax:

println() {
  printf "%s\n" "$*"
}

quote () {
  local q=()
  for _ in "$@"; do
    q+=("$(printf %q "$_")")
  done
  printf "%s\n" "${q[*]}"
}

scriptdir() {
  # ${BASH_SOURCE[0]} のディレクトリのフルパスを取得
  (cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)
}

nsec() {
  local d
  d=$(PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/bin:/bin type -p date)
  if [[ $("$d" +%N) == [0-9]* ]]; then
    eval "nsec() { $d +%s%9N; }"
  else
    nsec() { date +%s000000000; }
  fi
  nsec
}

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

fnpatch() {
  # 既存関数を書き換える
  # Usage: fnpatch patch_end_matk [ glob_pattern replacement ].. [ --- args.. ]
  local t f p r
  t=$1; shift
  f=$(declare -f "${FUNCNAME[1]}")
  local n=$'\n'
  echo "${#FUNCNAME[@]} BEFORE ================= $n$f$n"
  f=${f//()*"$t"[;]/()\{ }
  while
    p=$1; shift
    if [[ $p == -- ]]; then
      # -- 以降は呼び出しの引数なのでwhile終了
      false
    else
      # pとセットのrを読む
      r=$1; shift
    fi
  do
    # パターンは生のまま使う、リプレースは単純文字列扱い
    eval "f=\${f//$p/$(printf %q "$r")}"
  done
  # 関数の書き換え実行
  # unset -f "${FUNCNAME[1]}"
  eval "$f"
  echo "${#FUNCNAME[@]} AFTER ================== $n$f$n"
  # 元々の関数を再実行
  ${FUNCNAME[1]} "$@"
}

digest() {
  # パッチ版を作ってみたもののサブシェルで使われた場合はパッチが毎回やり直しににあるので気をつけること
  # XSUM を使えそうなハッシュコマンドに書き換える
  fnpatch ===1 XSUM "$(type -p sha1sum || type -p shasum || type -p md5sum || echo 'openssl dgst -sha1')" -- "$@";
  return $?;
  ===========1;
  local TRIM_D;
  if [[ $(echo | XSUM) == *= ]]; then
    TRIM_D='{d##*= }';
  else
    TRIM_D='{d%% *}';
  fi;
  # 変数 $d からハッシュ値を取り出す変数式を使用コマンドの出力に合わせて書き換える
  fnpatch ====2 TRIM_D "$TRIM_D" -- "$@";
  return $?;
  ============2;
  local d;
  d=$(if [[ $# != 0 ]]; then printf %s "$1"; else cat; fi | XSUM);
  d=$TRIM_D;
  echo "$d"
}
