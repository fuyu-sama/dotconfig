#!/usr/bin/env bash

prompt="rofi -dmenu -theme ~/.config/rofi/power.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

shutdown=" Shutdown"
reboot="󰑓 Restart"
lock=" Lock"
logout="󰍃 Logout"
sleep="⏾ Sleep"
cancel="󰜺 Cancel"

option="$cancel\n$sleep\n$shutdown\n$reboot\n$logout"

select="$(echo -e "$option" | $prompt -p "Uptime - $uptime")"

case $select in
	$shutdown)
		systemctl poweroff;;
	$reboot)
		systemctl reboot;;
	$logout)
        hyprctl dispatch exit;;
    $sleep)
        hyprctl dispatch dpms off
esac
