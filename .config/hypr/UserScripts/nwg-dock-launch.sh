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

    # Auto-detect monitors and set appropriate output
    if hyprctl monitors | grep -q "DP-5"; then
        # Work setup (3 monitors) - Use the middle Dell monitor
        output="DP-5"
        echo ":: Work setup detected, using DP-5 (middle monitor)"
    elif hyprctl monitors | grep -q "HDMI-A-1"; then
        # Home setup (2 monitors) - Use HDMI external monitor
        output="HDMI-A-1"
        echo ":: Home setup detected, using HDMI-A-1"
    else
        # Fallback to laptop display if nothing else is available
        output="eDP-1"
        echo ":: Only laptop display detected, using eDP-1"
    fi

    # Launch dock on the detected main display
    nwg-dock-hyprland -i 32 -w 5 -mb 10 -ml 10 -mr 10 -s "$style" -c "rofi -show drun" -o "$output" -x
else
    echo ":: Dock disabled"
fi
