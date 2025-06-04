#!/bin/bash

# Audio output switcher dialog
# Shows a rofi dialog to choose audio output

# Get available sinks
SINKS=$(pactl list short sinks | awk '{print $1 " - " $2}')

# Show dialog
SELECTED=$(echo "$SINKS" | rofi -dmenu -i -p "Select audio output:")

# Get the sink ID
SINK_ID=$(echo $SELECTED | awk '{print $1}')

if [ -n "$SINK_ID" ]; then
    # Set as default sink
    pactl set-default-sink "$SINK_ID"
    
    # Move all current audio streams to the new sink
    for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$stream" "$SINK_ID"
    done
    
    notify-send "Audio Output" "Changed to $(echo $SELECTED | cut -d'-' -f2-)"
fi
