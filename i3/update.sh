#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

[ -d $HOME/.config/i3 ] && rm -rf $HOME/.config/i3
mkdir $HOME/.config/i3
ln -f $DIR/config $HOME/.config/i3

[ -d $HOME/.config/i3status ] && rm -rf $HOME/.config/i3status
mkdir $HOME/.config/i3status
ln -f $DIR/i3status.config $HOME/.config/i3status/config

[ -d $HOME/.config/polybar ] && rm -rf $HOME/.config/polybar
ln -f -s $DIR/polybar $HOME/.config/polybar

[ -d $HOME/.config/picom ] && rm -rf $HOME/.config/picom
ln -f -s $DIR/picom $HOME/.config/picom
