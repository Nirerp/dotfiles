#!/bin/bash

# Emergency script to force audio to laptop speakers

echo "=== Laptop Audio Fix ==="
echo "This script will forcibly set your laptop speakers as the default audio output"

echo -e "\nAvailable audio devices:"
pactl list sinks short

echo -e "\nFinding Headphones sink..."
HEADPHONES_ID=$(pactl list sinks | grep -B 2 -A 2 "Headphones" | grep "Sink #" | sed 's/Sink #//')

if [ -n "$HEADPHONES_ID" ]; then
    echo "Found Headphones sink with ID: $HEADPHONES_ID"
    
    # Get the name of the sink
    HEADPHONES_SINK=$(pactl list sinks short | grep "^$HEADPHONES_ID" | awk '{print $2}')
    
    echo "Setting $HEADPHONES_SINK as default audio output"
    pactl set-default-sink "$HEADPHONES_SINK"
    
    # Move all current streams to the new sink
    for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
        echo "Moving stream $stream to $HEADPHONES_SINK"
        pactl move-sink-input "$stream" "$HEADPHONES_SINK"
    done
    
    echo "Done! Your audio should now come from laptop speakers"
    echo "Default sink is now: $(pactl get-default-sink)"
    
else
    echo "Could not find Headphones sink. Trying alternate method..."
    
    # Get the first non-HDMI sink
    NON_HDMI_SINK=$(pactl list sinks short | grep -v "HDMI" | head -n 1 | awk '{print $2}')
    
    if [ -n "$NON_HDMI_SINK" ]; then
        echo "Setting $NON_HDMI_SINK as default audio output"
        pactl set-default-sink "$NON_HDMI_SINK"
        
        # Move all current streams to the new sink
        for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
            echo "Moving stream $stream to $NON_HDMI_SINK"
            pactl move-sink-input "$stream" "$NON_HDMI_SINK"
        done
        
        echo "Done! Your audio should now come from laptop audio"
        echo "Default sink is now: $(pactl get-default-sink)"
    else
        echo "ERROR: Could not find any suitable audio output!"
    fi
fi
