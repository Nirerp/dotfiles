#!/bin/bash

VOLUME=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)

if [ "$MUTED" = "true" ]; then
    ICON=""
    OUTPUT="Muted"
else
    if [ "$VOLUME" -lt 30 ]; then
        ICON=""
    elif [ "$VOLUME" -lt 70 ]; then
        ICON=""
    else
        ICON=""
    fi
    OUTPUT="$VOLUME"
fi

echo -e "{\"icon\":\"$ICON\", \"output\":\"$OUTPUT\"}"