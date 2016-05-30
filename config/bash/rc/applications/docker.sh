if [[ -z $XDG_CONFIG_HOME ]]; then
  export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
fi
