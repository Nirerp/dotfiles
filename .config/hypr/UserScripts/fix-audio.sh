#!/bin/bash

# Smart Audio Router Script
# Intelligently routes audio based on your location (home vs office)
# and whether monitors have speakers

# The exact name of your laptop's headphone/speaker sink
LAPTOP_SINK="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Headphones__sink"

# The HDMI sinks
HDMI1_SINK="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI1__sink"
HDMI2_SINK="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI2__sink"
HDMI3_SINK="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI3__sink"

# Log file for debugging
LOG_FILE="$HOME/.config/hypr/UserScripts/fix-audio.log"
echo "Running smart audio router: $(date)" > "$LOG_FILE"

# Get current default sink
CURRENT_SINK=$(pactl get-default-sink)
echo "Current default sink: $CURRENT_SINK" >> "$LOG_FILE"

# Function to set a specific sink as default
set_sink_as_default() {
    SINK_NAME="$1"
    SINK_DESCRIPTION="$2"
    
    echo "Setting default sink to $SINK_DESCRIPTION: $SINK_NAME" >> "$LOG_FILE"
    pactl set-default-sink "$SINK_NAME"
    
    # Move all current audio streams to the new sink
    for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
        echo "Moving stream $stream to $SINK_NAME" >> "$LOG_FILE"
        pactl move-sink-input "$stream" "$SINK_NAME"
    done
    
    echo "Audio should now come from $SINK_DESCRIPTION" >> "$LOG_FILE"
}

# Detect monitor setup
if hyprctl monitors | grep -q "DP-5" && hyprctl monitors | grep -q "DP-6"; then
    # OFFICE SETUP (3 monitors)
    echo "Office setup detected (3 monitors)" >> "$LOG_FILE"
    
    # We know Dell monitor (DP-5) has speakers in the office
    # Check if HDMI output is available and working
    if pactl list sinks short | grep -q "$HDMI1_SINK"; then
        echo "Dell monitor with working speakers detected" >> "$LOG_FILE"
        set_sink_as_default "$HDMI1_SINK" "Dell monitor speakers"
    else
        echo "Dell monitor detected but HDMI audio not working, using laptop speakers" >> "$LOG_FILE"
        set_sink_as_default "$LAPTOP_SINK" "laptop speakers"
    fi
    
elif hyprctl monitors | grep -q "HDMI-A-1"; then
    # HOME SETUP (HDMI monitor without speakers)
    echo "Home setup detected (HDMI monitor)" >> "$LOG_FILE"
    echo "Home HDMI monitor doesn't have speakers, using laptop speakers" >> "$LOG_FILE"
    set_sink_as_default "$LAPTOP_SINK" "laptop speakers"
    
else
    # LAPTOP-ONLY SETUP
    echo "Laptop-only setup detected" >> "$LOG_FILE"
    set_sink_as_default "$LAPTOP_SINK" "laptop speakers"
fi

# Output current status
echo "New default sink: $(pactl get-default-sink)" >> "$LOG_FILE"
echo "Done!" >> "$LOG_FILE"
