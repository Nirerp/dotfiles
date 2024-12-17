#!/bin/bash

selected=$(echo -e "Lock\nLogout\nReboot\nShutdown" | wofi --dmenu --width 200 --height 250)

case $selected in
  Lock)
    swaylock ;;
  Logout)
    hyprctl dispatch exit ;;
  Reboot)
    systemctl reboot ;;
  Shutdown)
    systemctl poweroff ;;
esac
