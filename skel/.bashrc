# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# include settings
if [ -d ~/.profile.d ]; then
  if [ -n "`find ~/.profile.d/ -maxdepth 1 -type f -name \*.sh`" ]; then
    for f in ~/.profile.d/*.sh; do
      . "$f" || echo -e "\e[1;35m↑This error is in $f\e[1;0m"
    done
  fi
fi

# for local settings
if [ -f ~/.bashrc_local ]; then
  . ~/.bashrc_local
fi

