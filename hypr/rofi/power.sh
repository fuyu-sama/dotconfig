#!/usr/bin/env bash

prompt="rofi -dmenu -theme ~/.config/rofi/power.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

shutdown=" Shutdown"
reboot="󰑓 Restart"
lock=" Lock"
logout="󰍃 Logout"
suspend=" Suspend"
cancel="󰜺 Cancel"

option="$cancel\n$shutdown\n$reboot\n$lock\n$suspend\n$logout"

select="$(echo -e "$option" | $prompt -p "Uptime - $uptime")"

case $select in
	$shutdown)
		systemctl poweroff;;
	$reboot)
		systemctl reboot;;
	$lock)
		loginctl lock-session;;
	$suspend)
		systemctl suspend;;
	$logout)
        hyprctl dispatch exit
esac
