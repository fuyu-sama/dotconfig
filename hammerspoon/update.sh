#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

[ -d $HOME/.hammerspoon ] && rm -rf $HOME/.hammerspoon
ln -s $DIR/hammerspoon $HOME/.hammerspoon
