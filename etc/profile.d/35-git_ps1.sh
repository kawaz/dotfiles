if [ "`type -t __git_ps1`" == "function" ]; then
  function __dotfiles_git_ps1() {
    local git_ps1="$(__git_ps1)"
    if [ "$git_ps1" != "" ]; then
      echo "${git_ps1# } "
    fi
  }
  export PS1="\$(__dotfiles_git_ps1)$PS1"
  GIT_PS1_SHOWUPSTREAM=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWDIRTYSTATE=1
fi
