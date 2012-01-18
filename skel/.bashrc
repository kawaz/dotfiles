# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

alias du0='du --max-depth=1'
alias du1='du --max-depth=1'

export LANG=ja_JP.UTF-8
export PAGER="less -R"
export EDITOR=vim
export PS1='`[[ "$?" -eq 0 ]]&&echo "\[\e[1;34m\]"||echo "\[\e[1;31m\]"`[`date +%d%a%T` \u@\h \W]\$\[\e[m\] '

if [ -s ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
fi

