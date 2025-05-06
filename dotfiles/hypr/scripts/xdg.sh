#!/bin/bash
# __  ______   ____
# \ \/ /  _ \ / ___|
#  \  /| | | | |  _
#  /  \| |_| | |_| |
# /_/\_\____/ \____|
#

# Setup Timers
_sleep1="0.1"
_sleep2="0.5"
_sleep3="2"

# Kill all possible running xdg-desktop-portals
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-gnome
killall -e xdg-desktop-portal

# Set required environment variables
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland

# Stop all services
systemctl --user stop pipewire
systemctl --user stop wireplumber
systemctl --user stop xdg-desktop-portal
sleep $_sleep1

# Start xdg-desktop-portal-hyprland
/usr/lib/xdg-desktop-portal-hyprland &
sleep $_sleep1

# Start xdg-desktop-portal
/usr/lib/xdg-desktop-portal &
sleep $_sleep2

# Start required services
systemctl --user start pipewire
systemctl --user start wireplumber
systemctl --user start xdg-desktop-portal