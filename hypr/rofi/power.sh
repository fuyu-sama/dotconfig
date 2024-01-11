#!/usr/bin/env bash

prompt="rofi -dmenu -theme ~/.config/rofi/power.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

cancel="󰜺 Cancel"
sleep="⏾ Sleep"
logout="󰍃 Logout"
reboot="󰑓 Reboot"
power=" Power"

option="$cancel\n$sleep\n$logout\n$reboot\n$power"

select="$(echo -e "$option" | $prompt -p "Uptime - $uptime")"

case $select in
	$logout)
        hyprctl dispatch exit;;
    $sleep)
        hyprctl dispatch dpms off;;
	$reboot)
		systemctl reboot;;
	$power)
		systemctl poweroff
esac
