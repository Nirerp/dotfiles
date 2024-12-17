#!/bin/bash

# Get current keyboard layout
get_layout() {
    # Get the current keyboard layout
    current_layout=$(setxkbmap -query | grep "layout" | awk '{print $2}')
    
    # Split the layout if multiple are configured (like us,il)
    IFS=',' read -ra LAYOUTS <<< "$current_layout"
    
    # Determine which layout is active
    for layout in "${LAYOUTS[@]}"; do
        case "$layout" in
            us) echo "EN" ;;
            il) echo "HE" ;;
            *) echo "$layout" ;;
        esac
    done
}

# Print the current layout
get_layout
