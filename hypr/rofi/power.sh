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

select=${1:-`echo -e "$option" | $prompt -p "Uptime - $uptime"`}

function confirm() {
    select="$(echo -e "󰸞 Yes\n No" | $prompt_confirm -p "$1?")"
    if [[ $select == "󰸞 Yes" ]]; then
        exec $2
    else
        bash $HOME/.config/rofi/power.sh
    fi
}

function sleep_lock() {
    hyprlock &
    while pidof hyprlock; do
        sleep 120
        pidof hyprlock && hyprctl dispatch dpms off
    done
}

case $select in
    $logout)
        confirm "Logout" "hyprctl dispatch exit";;
    $sleep)
        hyprctl dispatch dpms off;;
    $lock)
        sleep_lock;;
    $reboot)
        confirm "Reboot" "systemctl reboot";;
    $power)
        confirm "Power off" "systemctl poweroff"
esac
