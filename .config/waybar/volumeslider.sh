#!/bin/bash

# Get the current volume
VOLUME=$(pamixer --get-volume)

# Get the mouse coordinates
eval $(xdotool getmouselocation --shell)

# Display a slider dialog using yad
yad --scale --value="$VOLUME" --min-value=0 --max-value=100 \
    --vertical --no-buttons --undecorated --skip-taskbar \
    --close-on-unfocus --on-top --width=30 --height=200 \
    --mouse --posx=$X --posy=$Y \
    --tooltip-text="Volume Control" \
    --command="pamixer --set-volume %value" \
    >/dev/null &