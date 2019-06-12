#!/bin/bash
cd "$(dirname "$0")" || exit 1
curl -sL https://github.com/jwilm/alacritty/raw/master/alacritty.yml > alacritty-default.yml
