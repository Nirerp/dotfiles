#!/bin/bash

#    ___           __
#   / _ \___  ____/ /__
#  / // / _ \/ __/  '_/
# /____/\___/\__/_/\_\

config="$HOME/.config/gtk-3.0/settings.ini"

if [ ! -f "$HOME/.config/ml4w/settings/dock-disabled" ]; then
    killall nwg-dock-hyprland 2>/dev/null
    sleep 0.5

    # Get theme preference
    prefer_dark_theme="$(grep 'gtk-application-prefer-dark-theme' "$config" | sed 's/.*=\s*//')"
    if [ "$prefer_dark_theme" == "0" ]; then
        style="style-light.css"
    else
        style="style-dark.css"
    fi

    # Detect connected monitors
    connected=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

    # Default fallback
    output="DP-6"

    if echo "$connected" | grep -q "HDMI-A-1"; then
        output="HDMI-A-1"
    elif echo "$connected" | grep -q "DP-6"; then
        output="DP-6"
    fi

    # Launch dock on the detected main display
    nwg-dock-hyprland -i 35 -w 5 -mb 10 -ml 10 -mr 10 -s "$style" -c "rofi -show drun" -o "$output" -x
else
    echo ":: Dock disabled"
fi

