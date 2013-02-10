#!/bin/bash

# bashとshの違いを吸収 http://bit.ly/S2LWDQ
set +o posix

# ベースディレクトリを取得
if [ ! -d "$DOTFILES_DIR" ]; then
  DOTFILES_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
fi

# 終了時に一時ディレクトリを削除する
declare -a DOTFILES_TMPDIR=()
function clean_tmpdir() {
  for d in "${DOTFILES_TMPDIR[@]}"; do
    if [ -d "$d" ]; then
      rm -rf "$d"
    fi
  done
}

# トラップを一手に引き受ける
trap on_abort HUP INT QUIT TERM ABRT EXIT
function on_abort() {
  clean_tmpdir
}

# 一時ディレクトリを作ってcdする
function cd_tmpdir() {
  local prefix="${1:-make_tmpdir}"; shift
  local t="$DOTFILES_DIR/env/tmp/${prefix##*/}-`date +%Y%m%dT%H%M%S`.$$"
  DOTFILES_TMPDIR+=("$t")
  mkdir -p "$t" && cd "$t"
}

# 自動 source されるスクリプトを作成する
function make_profile_script() {
  local fname="$1"; shift
  mkdir -p "$DOTFILES_DIR/env/dest/profile.d"
  cat > "$DOTFILES_DIR/env/dest/profile.d/$fname"
}

# 自動 source されるスクリプトを読み込む
function load_profile_script() {
  local fname="$1"; shift
  if [ -f "$DOTFILES_DIR/env/dest/profile.d/$fname" ]; then
    . "$DOTFILES_DIR/env/dest/profile.d/$fname"
  fi
}

# Macチェック
function is_mac() {
  uname | grep -qi darwin
}

# 必要なrpmが入ってるかどうかチェックする
function has_rpm_packages() {
  if ! rpm -q "$@" >/dev/null 2>&1; then
    echo "必要なパッケージが足りません、以下を実行してください"
    echo "sudo yum install $*"
    return 1
  fi
}

# Perlモジュールチェック
function has_perl_modules() {
  local needs=()
  for m in "$@"; do
    perl -M"$m" -e '' && continue
    needs+=("$m")
  done
  if [ ${#needs[@]} -gt 0 ]; then
    echo "必要なPerlモジュールが足りません"
    echo "${needs[*]}"
    return 1
  fi
}
