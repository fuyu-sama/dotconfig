#!/usr/bin/env bash

sudo pacman -S \
    i3 mpd python-pywal calc pango feh rofi nm-connection-editor
yay -S polybar betterlockscreen picom-ibhagwan-git autotiling 

./update.sh
