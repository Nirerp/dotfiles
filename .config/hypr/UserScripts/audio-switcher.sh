#!/bin/bash

# Audio output switcher script
# This script detects the current monitor setup and sets the appropriate audio output

# Log file for debugging
LOG_FILE="$HOME/.config/hypr/UserScripts/audio-switcher.log"
echo "Audio switcher running: $(date)" > "$LOG_FILE"

# Print current audio devices for debugging
echo "Available audio devices:" >> "$LOG_FILE"
pactl list sinks short >> "$LOG_FILE"

# Function to set laptop speakers as default
set_laptop_speakers() {
    # Direct approach - explicitly find the laptop headphones/speaker sink
    # First look for specific pattern in the description that identifies laptop audio
    echo "Finding laptop audio device..." >> "$LOG_FILE"
    
    # Get the ID of the Headphones sink
    HEADPHONES_SINK=$(pactl list sinks | grep -B 5 -A 5 "Headphones" | grep "Name:" | head -n 1 | sed 's/.*Name: //')
    
    if [ -n "$HEADPHONES_SINK" ]; then
        echo "Found Headphones sink: $HEADPHONES_SINK" >> "$LOG_FILE"
        echo "Setting as default sink..." >> "$LOG_FILE"
        pactl set-default-sink "$HEADPHONES_SINK"
        
        # Move all current audio streams to the new sink
        for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
            echo "Moving stream $stream to $HEADPHONES_SINK" >> "$LOG_FILE"
            pactl move-sink-input "$stream" "$HEADPHONES_SINK"
        done
        
        echo "Successfully switched to laptop speakers" >> "$LOG_FILE"
        return 0
    fi
    
    # If not found, try with broader pattern match
    INTERNAL_SINK=$(pactl list sinks short | grep -i -v "hdmi\|bluetooth" | head -n 1 | awk '{print $2}')
    
    if [ -n "$INTERNAL_SINK" ]; then
        echo "Using first non-HDMI/non-Bluetooth sink: $INTERNAL_SINK" >> "$LOG_FILE"
        pactl set-default-sink "$INTERNAL_SINK"
        
        # Move all current audio streams to the new sink
        for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
            pactl move-sink-input "$stream" "$INTERNAL_SINK"
        done
        
        echo "Successfully switched to internal audio" >> "$LOG_FILE"
        return 0
    fi
    
    echo "ERROR: Could not find any suitable audio sink for laptop speakers" >> "$LOG_FILE"
    return 1
}

# Function to set HDMI as default
set_hdmi_audio() {
    # Find the HDMI sink
    HDMI_SINK=$(pactl list sinks short | grep "HDMI1" | awk '{print $2}')
    
    if [ -n "$HDMI_SINK" ]; then
        echo "Setting default sink to HDMI: $HDMI_SINK" >> "$LOG_FILE"
        pactl set-default-sink "$HDMI_SINK"
        
        # Move all current audio streams to the new sink
        for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
            pactl move-sink-input "$stream" "$HDMI_SINK"
        done
        
        echo "Successfully switched to HDMI audio" >> "$LOG_FILE"
    else
        echo "ERROR: Could not find HDMI sink" >> "$LOG_FILE"
    fi
}

# Check current monitor setup
if hyprctl monitors | grep -q "HDMI-A-1"; then
    echo "HDMI monitor detected" >> "$LOG_FILE"
    
    # Check if the HDMI monitor has speakers
    HDMI_HAS_SPEAKERS=false
    
    # For now, we'll assume it doesn't have speakers
    # If you want to detect this automatically in the future, we can add logic here
    
    if [ "$HDMI_HAS_SPEAKERS" = true ]; then
        # If HDMI monitor has speakers, use HDMI audio
        set_hdmi_audio
    else
        # If HDMI monitor doesn't have speakers, use laptop speakers
        set_laptop_speakers
    fi
else
    # No HDMI monitor, use laptop speakers
    echo "No HDMI monitor detected, using laptop speakers" >> "$LOG_FILE"
    set_laptop_speakers
fi

# Print current audio setup
echo "Current audio configuration:" >> "$LOG_FILE"
pactl get-default-sink >> "$LOG_FILE"

exit 0
