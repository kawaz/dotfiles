[[ $(type -t _known_hosts_real) != function ]] && return

# backup original function
if [[ $(type -t _known_hosts_real_orig) != function ]]; then
  . <(echo "_known_hosts_real_orig()"; type _known_hosts_real | tail -n+3)
fi

# add hook
_known_hosts_real() {
  if [[ $(type -t _known_hosts_real_hook_before) == function ]]; then
    _known_hosts_real_hook_before "$@"
  fi
  _known_hosts_real_orig "$@"
  if [[ $(type -t _known_hosts_real_hook_after) == function ]]; then
    _known_hosts_real_hook_after "$@"
  fi
}
