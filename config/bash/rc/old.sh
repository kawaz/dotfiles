for f in "$(dirname "${BASH_SOURCE[0]}")"/old/*.sh; do
  f=$(printf %q "$f")
  eval ". $f"' || echo -e "\e[1;35mError in '"$f"'\e[1;0m" >&2'
done
