#!/bin/bash
# Simple script to show Bluetooth status for Polybar

ICON_ON=""  # Icon when connected or just powered on
ICON_OFF="" # Icon when powered off

if bluetoothctl show | grep -q "Powered: yes"; then
  # Check if any device is connected
  if bluetoothctl devices Connected | grep -q "Device"; then
    echo "%{F#81A1C1}$ICON_ON%{F-}" # Blue color when connected
  else
    echo "$ICON_ON" # Default color when on but not connected
  fi
else
  echo "%{F#666}$ICON_OFF%{F-}" # Dimmed color when off
fi
