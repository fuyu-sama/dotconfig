#!/usr/bin/env sh

dist==`awk -F= '$1=="ID" { print $2 ;}' /etc/os-release`

if [[ $dist == "debian" ]] || [[ $dist == "ubuntu" ]]
then
    apt update
    apt install git zsh tmux make cmake neofetch
elif [[ $dist == "opensuse-leap" ]] 
then
    zypper install git zsh tmux make cmake neofetch
elif [[ $dist == "arch" ]]
then
    pacman -S git zsh tmux make cmake neofetch
fi
