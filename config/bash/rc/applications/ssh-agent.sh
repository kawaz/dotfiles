[[ -S $SSH_AUTH_SOCK ]] && return 0

# shellcheck disable=SC1090
{
  if [[ -f $XDG_CACHE_HOME/ssh-agent-save.sh ]]; then
    . "$XDG_CACHE_HOME/ssh-agent-save.sh"
  fi
  [[ -S $SSH_AUTH_SOCK ]] && return 0
  [[ -d $XDG_CACHE_HOME ]] || mkdir -p "$XDG_CACHE_HOME"
  ssh-agent -s -t "${SSH_AGENT_TIMEOUT:-$((24*3600))}" | grep -v ^echo > "$XDG_CACHE_HOME/ssh-agent-save.sh"
  . "$XDG_CACHE_HOME/ssh-agent-save.sh"
}
