# only interactive
[[ $- == *i* ]] || return 0

if [[ -z $INPUTRC ]]; then
  export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
  bind -f "$INPUTRC"
fi
