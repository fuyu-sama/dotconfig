#!/usr/bin/env bash

prompt="rofi -dmenu -theme $HOME/.config/rofi/power.rasi"
prompt_confirm="rofi -dmenu -theme $HOME/.config/rofi/confirm.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

cancel="󰜺 Cancel"
lock=" Lock"
sleep="⏾ Sleep"
logout="󰍃 Logout"
reboot="󰑓 Reboot"
power=" Power"

option="$cancel\n$lock\n$logout\n$reboot\n$power"

if [[ -z $1 ]]; then
    select=`echo -e "$option" | $prompt -p "Uptime - $uptime"`
    env="rofi"
else
    select=$1
    env="waybar"
fi

function confirm() {
    select="$(echo -e "󰸞 Yes\n No" | $prompt_confirm -p "$1?")"
    if [[ $select == "󰸞 Yes" ]]; then
        exec $2
    else
        if [[ $env == "rofi" ]]; then
            bash $HOME/.config/rofi/power.sh
        fi
    fi
}

function lock() {
    hypridle &
    hyprlock
    kill `pidof hypridle`
}

case $select in
    $logout)
        confirm "Logout" "hyprctl dispatch exit";;
    $sleep)
        hyprctl dispatch dpms off;;
    $lock)
        lock;;
    $reboot)
        confirm "Reboot" "systemctl reboot";;
    $power)
        confirm "Power off" "systemctl poweroff"
esac
