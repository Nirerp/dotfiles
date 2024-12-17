#!/bin/bash

# Power menu script for Waybar
entries=(
    " Shutdown"
    " Restart"
    " Suspend"
    " Log Out"
    " Lock"
    " Cancel"
)

selected=$(printf '%s\n' "${entries[@]}" | wofi --show dmenu --prompt "Power Menu" --width 250 --height 250)

case $selected in
    " Shutdown")
        systemctl poweroff
        ;;
    " Restart")
        systemctl reboot
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Log Out")
        hyprctl dispatch exit
        ;;
    " Lock")
        swaylock  # or your preferred lock command
        ;;
    " Cancel")
        exit 0
        ;;
esac
