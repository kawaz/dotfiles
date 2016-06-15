# git 2.9 の Beautiful diffs を活かす設定
# http://qiita.com/kawaz/items/a8485f3fbe449c248f9c
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

# ローカル環境用設定を生成
if [[ ! -f ${XDG_CACHE_HOME:-~/.cache}/gitconfig.local || ${BASH_SOURCE[0]} -nt "${XDG_CACHE_HOME:-~/.cache}/gitconfig.local" ]]; then
  {
    echo "[core]"
    echo "  hooksPath = ${XDG_CONFIG_HOME:-~/.config}/git/hooks"
  } > "${XDG_CACHE_HOME:-~/.cache}/gitconfig.local"
fi
