#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

sudo pacman -S \
    i3 mpd python-pywal calc pango feh rofi
yay -S polybar i3lock-fancy-git 

ln -f $DIR/config $HOME/.config/i3

[ -d $HOME/.config/polybar ] && rm $HOME/.config/polybar
ln -f -s $DIR/polybar $HOME/.config/polybar
