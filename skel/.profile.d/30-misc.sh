#!/bin/sh
export LANG="ja_JP.UTF-8"
export PAGER="less -R"
export EDITOR="vim"
export PS1='`[[ "$?" -eq 0 ]]&&echo "\[\e[1;34m\]"||echo "\[\e[1;31m\]"`[`date +%d%a%T` \u@\h \W]\$\[\e[m\] '
export TERM="screen-256color"

alias du0='du --max-depth=1'
alias du1='du --max-depth=1'

alias dstat-full='dstat -Tclmdrn'
alias dstat-mem='dstat -Tclm'
alias dstat-cpu='dstat -Tclr'
alias dstat-net='dstat -Tclnd'
alias dstat-disk='dstat -Tcldr'
