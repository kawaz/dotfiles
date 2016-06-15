if ! type -P diff-highlight >/dev/null 2>&1; then
  (
  for d in /usr/local/share /usr/share; do
    if [[ -x $d/git-core/contrib/diff-highlight/diff-highlight ]]; then
      ln -sfn "$d/git-core/contrib/diff-highlight/diff-highlight" "${XDG_CACHE_HOME:-~/.cache}/dotfiles/bin/"
      exit
    fi
  done
  )
fi
