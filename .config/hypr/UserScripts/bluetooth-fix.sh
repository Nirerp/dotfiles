#!/bin/bash

# Direct Bluetooth headphones switcher
# This script automatically switches audio to Bluetooth headphones when connected
# and keeps track of the monitor output to return to when disconnected

# Log file for debugging
LOG_FILE="$HOME/.config/hypr/UserScripts/bluetooth-fix.log"
echo "Running Bluetooth fix: $(date)" > "$LOG_FILE"

# Function to find Bluetooth sink
find_bluetooth_sink() {
    # Find the Bluetooth sink if available
    BT_SINK=$(pactl list sinks short | grep -i "bluez" | awk '{print $2}' | head -n 1)
    echo "Bluetooth sink: $BT_SINK" >> "$LOG_FILE"
    echo "$BT_SINK"
}

# Function to find monitor/laptop speakers sink
find_speakers_sink() {
    # Check for office setup (DP-5)
    if hyprctl monitors | grep -q "DP-5"; then
        # We're at the office, use HDMI sink
        SPEAKERS_SINK=$(pactl list sinks short | grep "HDMI" | awk '{print $2}' | head -n 1)
    else
        # We're at home or just on laptop, use internal speakers
        SPEAKERS_SINK=$(pactl list sinks short | grep "Headphones" | awk '{print $2}' | head -n 1)
    fi
    
    echo "Speakers sink: $SPEAKERS_SINK" >> "$LOG_FILE"
    echo "$SPEAKERS_SINK"
}

# Function to switch to a specific sink
switch_to_sink() {
    SINK="$1"
    DESC="$2"
    
    if [ -z "$SINK" ]; then
        echo "Error: No $DESC sink found" >> "$LOG_FILE"
        return 1
    fi
    
    echo "Switching to $DESC: $SINK" >> "$LOG_FILE"
    
    # Set as default sink
    pactl set-default-sink "$SINK"
    
    # Move all streams to the new sink
    for stream in $(pactl list sink-inputs short | awk '{print $1}'); do
        echo "Moving stream $stream to $SINK" >> "$LOG_FILE"
        pactl move-sink-input "$stream" "$SINK"
    done
    
    # Add a notification
    notify-send "Audio Output" "Switched to $DESC" -i audio-headphones-symbolic
    
    return 0
}

# Function to save the current sink if it's not Bluetooth
save_current_sink() {
    CURRENT_SINK=$(pactl get-default-sink)
    
    if ! echo "$CURRENT_SINK" | grep -qi "bluez"; then
        echo "$CURRENT_SINK" > "$HOME/.config/hypr/UserScripts/last_speakers_sink.txt"
        echo "Saved last speakers sink: $CURRENT_SINK" >> "$LOG_FILE"
    fi
}

# Function to get the last saved speakers sink
get_last_speakers_sink() {
    if [ -f "$HOME/.config/hypr/UserScripts/last_speakers_sink.txt" ]; then
        LAST_SINK=$(cat "$HOME/.config/hypr/UserScripts/last_speakers_sink.txt")
        echo "$LAST_SINK"
    else
        echo ""
    fi
}

# Main logic to switch to Bluetooth
switch_to_bluetooth() {
    # Save current sink if it's not Bluetooth
    save_current_sink
    
    # Find Bluetooth sink
    BT_SINK=$(find_bluetooth_sink)
    
    if [ -n "$BT_SINK" ]; then
        switch_to_sink "$BT_SINK" "Bluetooth headphones"
        return $?
    else
        echo "No Bluetooth sink found" >> "$LOG_FILE"
        notify-send "Audio Error" "No Bluetooth device connected" -i audio-headphones-symbolic
        return 1
    fi
}

# Main logic to switch back to speakers
switch_to_speakers() {
    # Try to get the last saved speakers sink
    LAST_SINK=$(get_last_speakers_sink)
    
    if [ -n "$LAST_SINK" ] && pactl list sinks short | grep -q "$LAST_SINK"; then
        switch_to_sink "$LAST_SINK" "speakers"
    else
        # If no saved sink or it's no longer available, find the appropriate sink
        SPEAKERS_SINK=$(find_speakers_sink)
        switch_to_sink "$SPEAKERS_SINK" "speakers"
    fi
}

# Create a DBus monitor for Bluetooth events
create_dbus_monitor() {
    MONITOR_SCRIPT="$HOME/.config/hypr/UserScripts/bluetooth-monitor.sh"
    
    cat > "$MONITOR_SCRIPT" << EOF
#!/bin/bash

# Monitor DBus for Bluetooth events
dbus-monitor --system "interface='org.bluez.Device1'" | 
while read -r line; do
    if echo "\$line" | grep -q "org.bluez.Device1.*Connected"; then
        if echo "\$line" | grep -q "boolean true"; then
            # Device connected, wait a moment for audio profile to be set up
            sleep 2
            $HOME/.config/hypr/UserScripts/bluetooth-fix.sh --connect
        elif echo "\$line" | grep -q "boolean false"; then
            # Device disconnected
            $HOME/.config/hypr/UserScripts/bluetooth-fix.sh --disconnect
        fi
    fi
done
EOF
    
    chmod +x "$MONITOR_SCRIPT"
    
    # Create systemd service to run the monitor
    mkdir -p "$HOME/.config/systemd/user"
    cat > "$HOME/.config/systemd/user/bluetooth-audio-monitor.service" << EOF
[Unit]
Description=Bluetooth Audio Connection Monitor
After=bluetooth.service pulseaudio.service

[Service]
ExecStart=$HOME/.config/hypr/UserScripts/bluetooth-monitor.sh
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF
    
    # Enable and start the service
    systemctl --user daemon-reload
    systemctl --user enable bluetooth-audio-monitor.service
    systemctl --user restart bluetooth-audio-monitor.service
    
    echo "Created and started Bluetooth monitor service" >> "$LOG_FILE"
}

# Handle command line arguments
case "$1" in
    --connect)
        switch_to_bluetooth
        ;;
    --disconnect)
        switch_to_speakers
        ;;
    --toggle)
        # Check if current sink is Bluetooth
        CURRENT_SINK=$(pactl get-default-sink)
        if echo "$CURRENT_SINK" | grep -qi "bluez"; then
            # Currently on Bluetooth, switch to speakers
            switch_to_speakers
        else
            # Currently on speakers, switch to Bluetooth
            switch_to_bluetooth
        fi
        ;;
    --setup)
        # Create the DBus monitor for auto-switching
        create_dbus_monitor
        ;;
    *)
        # No arguments, check if Bluetooth is connected but not being used
        BT_SINK=$(find_bluetooth_sink)
        CURRENT_SINK=$(pactl get-default-sink)
        
        if [ -n "$BT_SINK" ] && [ "$BT_SINK" != "$CURRENT_SINK" ]; then
            # Bluetooth connected but not being used
            switch_to_bluetooth
        else
            echo "No action needed. Current sink: $CURRENT_SINK" >> "$LOG_FILE"
        fi
        ;;
esac

echo "Script completed: $(date)" >> "$LOG_FILE"
exit 0
