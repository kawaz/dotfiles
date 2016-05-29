# bash
function cursor_move() { echo -ne "\033[${1:-1};${2:-1}H"; }
function cursor_up() { echo -ne "\033[${1:-1}A"; }
function cursor_down() { echo -ne "\033[${1:-1}B"; }
function cursor_right() { echo -ne "\033[${1:-1}C"; }
function cursor_left() { echo -ne "\033[${1:-1}D"; }
function cursor_save() { echo -ne "\033[${1:-1}s"; }
function cursor_load() { echo -ne "\033[${1:-1}u"; }
