#!/bin/sh

# 装飾
esc_reset="\x1b[0m"
esc_bold="\x1b[1m"
esc_italic="\x1b[3m"
esc_underline="\x1b[4m"
esc_blink="\x1b[5m"
# 文字色
esc_black="\x1b[30m"
esc_red="\x1b[31m"
esc_green="\x1b[32m"
esc_yellow="\x1b[33m"
esc_blue="\x1b[34m"
esc_magenta="\x1b[35m"
esc_cyan="\x1b[36m"
esc_white="\x1b[37m"
# 背景色
esc_black_bg="\x1b[40m"
esc_red_bg="\x1b[41m"
esc_green_bg="\x1b[42m"
esc_yellow_bg="\x1b[43m"
esc_blue_bg="\x1b[44m"
esc_magenta_bg="\x1b[45m"
esc_cyan_bg="\x1b[46m"
esc_white_bg="\x1b[47m"

# 関数化
function echo_reset()     { __esc_echo "$@"; }
function echo_bold()      { __esc_echo "$@"; }
function echo_italic()    { __esc_echo "$@"; }
function echo_underline() { __esc_echo "$@"; }
function echo_blink()     { __esc_echo "$@"; }
function echo_black()     { __esc_echo "$@"; }
function echo_red()       { __esc_echo "$@"; }
function echo_green()     { __esc_echo "$@"; }
function echo_yellow()    { __esc_echo "$@"; }
function echo_blue()      { __esc_echo "$@"; }
function echo_magenta()   { __esc_echo "$@"; }
function echo_cyan()      { __esc_echo "$@"; }
function echo_white()     { __esc_echo "$@"; }
function __esc_echo()     { eval "echo -en \$esc_${FUNCNAME[1]#*_}"; echo "$@"; echo -en "$esc_reset"; }
# ログ系
function echo_info()   { echo_bold -n; echo_cyan   "$@"; }
function echo_notice() { echo_bold -n; echo_green  "$@"; }
function echo_warn()   { echo_bold -n; echo_yellow "$@"; }
function echo_error()  { echo_bold -n; echo_red    "$@"; }
# 画面制御系
function echo_cursor_up()    { echo -en "\x1b[$1A"; }
function echo_cursor_down()  { echo -en "\x1b[$1B"; }
function echo_cursor_right() { echo -en "\x1b[$1C"; }
function echo_cursor_left()  { echo -en "\x1b[$1D"; }
function echo_cursor_goto()  { echo -en "\x1b[${1:-1};${2:-1}H"; }
function echo_clear_screen() { echo -en "\x1b[2J"; }
#function echo_kill_line() { echo -en "\x1b[K"; }
