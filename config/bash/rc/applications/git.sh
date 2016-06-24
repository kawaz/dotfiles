# git 2.9 の Beautiful diffs を活かす設定
# http://qiita.com/kawaz/items/a8485f3fbe449c248f9c
if ! type -P diff-highlight >/dev/null 2>&1; then
  (
  for d in /usr/local /usr "$DOTFILES_LOCAL"; do
    if [[ -x $d/share/git-core/contrib/diff-highlight/diff-highlight ]]; then
      ln -sfn "$d/share/git-core/contrib/diff-highlight/diff-highlight" "$DOTFILES_LOCAL/bin/"
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
