#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

[ -d $HOME/.config/hypr ] && rm -rf $HOME/.config/hypr
ln -s $DIR/hypr $HOME/.config

[ -d $HOME/.config/waybar ] && rm -rf $HOME/.config/waybar
ln -s $DIR/waybar $HOME/.config

[ -d $HOME/.config/rofi ] && rm -rf $HOME/.config/rofi
ln -s $DIR/rofi $HOME/.config

[ -d $HOME/.config/swaync ] && rm -rf $HOME/.config/swaync
ln -s $DIR/swaync $HOME/.config

ln $DIR/alacritty.yml $HOME/.alacritty.yml
