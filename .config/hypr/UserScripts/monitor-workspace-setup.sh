#!/bin/bash

# Monitor-Workspace Configuration Script
# Automatically detects home vs office setup and configures monitors and workspaces accordingly
# Created: May 22, 2025

# Default workspace configuration file
WORKSPACE_CONF="/home/nir/.config/hypr/workspaces.conf"

# Detect active monitors
if hyprctl monitors | grep -q "DP-5" && hyprctl monitors | grep -q "DP-6"; then
    # OFFICE SETUP (3 monitors)
    echo ":: Office setup detected (3 monitors)"
    
    # Create workspaces.conf for office setup
    cat > "$WORKSPACE_CONF" << EOF
# Auto-generated for 3-monitor OFFICE setup on $(date)
# Left monitor (Lenovo DP-6) - Workspace 1
workspace = 1, monitor:DP-6, default:true
workspace = 4, monitor:DP-6
workspace = 7, monitor:DP-6

# Center monitor (Dell DP-5 - Primary) - Workspace 2
workspace = 2, monitor:DP-5, default:true
workspace = 5, monitor:DP-5
workspace = 8, monitor:DP-5

# Right/Laptop monitor (eDP-1) - Workspace 3
workspace = 3, monitor:eDP-1, default:true
workspace = 6, monitor:eDP-1
workspace = 9, monitor:eDP-1
EOF

elif hyprctl monitors | grep -q "HDMI-A-1"; then
    # HOME SETUP (2 monitors)
    echo ":: Home setup detected (2 monitors)"
    
    # Create workspaces.conf for home setup
    cat > "$WORKSPACE_CONF" << EOF
# Auto-generated for 2-monitor HOME setup on $(date)
# Left/Laptop monitor (eDP-1) - Workspace 1
workspace = 1, monitor:eDP-1, default:true
workspace = 3, monitor:eDP-1
workspace = 5, monitor:eDP-1
workspace = 7, monitor:eDP-1
workspace = 9, monitor:eDP-1

# Right/HDMI monitor (HDMI-A-1) - Workspace 2
workspace = 2, monitor:HDMI-A-1, default:true
workspace = 4, monitor:HDMI-A-1
workspace = 6, monitor:HDMI-A-1
workspace = 8, monitor:HDMI-A-1
workspace = 10, monitor:HDMI-A-1
EOF

else
    # LAPTOP-ONLY SETUP
    echo ":: Laptop-only setup detected"
    
    # Create workspaces.conf for laptop-only setup
    cat > "$WORKSPACE_CONF" << EOF
# Auto-generated for LAPTOP-ONLY setup on $(date)
# Laptop monitor (eDP-1)
workspace = 1, monitor:eDP-1, default:true
workspace = 2, monitor:eDP-1
workspace = 3, monitor:eDP-1
workspace = 4, monitor:eDP-1
workspace = 5, monitor:eDP-1
workspace = 6, monitor:eDP-1
workspace = 7, monitor:eDP-1
workspace = 8, monitor:eDP-1
workspace = 9, monitor:eDP-1
workspace = 10, monitor:eDP-1
EOF
fi

# Reload Hyprland configuration to apply changes
hyprctl reload

echo ":: Workspace configuration updated successfully"
