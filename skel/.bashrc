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

if [ -d ~/.profile.d ]; then
  if [ -n "`find ~/.profile.d -maxdepth 1 -type f -name \*.sh`" ]; then
    for f in ~/.profile.d/*.sh; do
      . "$f" || echo -e "\e[1;35m↑This error is in $f\e[1;0m"
    done
  fi
fi

if [ -s ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
fi

keychain -q --agents ssh 2>/dev/null
if [ -f ~/.keychain/$HOSTNAME-sh ]; then
  . ~/.keychain/$HOSTNAME-sh
fi

