#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
find rc rc.after -name \*.sh.test | \
  while read -r f; do
    bash "$f" >/dev/null 2>&1
    if [[ $? == 0 ]]; then
      echo "OK $f"
    else
      echo "NG $f"
    fi
  done
