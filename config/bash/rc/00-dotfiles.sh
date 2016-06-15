# リポジトリルートを使いまわし用に環境変をセット
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)
export DOTFILES_DIR

# リモート環境との連携用に XMODIFIERS をセット
if [[ $XMODIFIERS != *@dotfiles=* ]]; then
  export XMODIFIERS="${XMODIFIERS:+"$XMODIFIERS "}@dotfiles=on"
fi

# XDG Config Directory
if [[ -n $DOTFILES_DIR ]]; then
  export XDG_CONFIG_HOME=$DOTFILES_DIR/config
  export XDG_CACHE_HOME=$DOTFILES_DIR/cache
  export XDG_DATA_HOME=$DOTFILES_DIR/local/share
else
  export XDG_CONFIG_HOME=~/.config
  export XDG_CACHE_HOME=~/.cache
  export XDG_DATA_HOME=~/.local/share
fi

# Add PATH
if ! [[ -d $XDG_CACHE_HOME/dotfiles/bin ]]; then
  mkdir -p "$XDG_CACHE_HOME/dotfiles/bin"
fi
export PATH=$XDG_CACHE_HOME/dotfiles/bin:$PATH
