#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

[ -d $HOME/.config/hypr ] && rm -rf $HOME/.config/hypr
ln -s $DIR/hypr $HOME/.config

[ -d $HOME/.config/waybar ] && rm -rf $HOME/.config/waybar
ln -s $DIR/waybar $HOME/.config

[ -d $HOME/.config/wofi ] && rm -rf $HOME/.config/wofi
ln -s $DIR/wofi $HOME/.config
