# install check
if ! type -P travis >/dev/null 2>&1; then
  travis() {
    if type -P travis >/dev/null 2>&1; then
      unset -f travis
      command travis "$@"
    else
      echo "travis is not installed. Let's install it." 2>&1
      echo ">>> sudo gem install travis --no-rdoc --no-ri" 2>&1
      return 1
    fi
  }
fi

# added by travis gem
if [[ -f /Users/kawaz/.travis/travis.sh ]]; then
  source /Users/kawaz/.travis/travis.sh
fi

