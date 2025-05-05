#!/bin/bash
# Simple script to show Bluetooth status for Polybar

ICON_ON=""  # Icon when connected or just powered on
ICON_OFF="" # Icon when powered off

if bluetoothctl show | grep -q "Powered: yes"; then
  # Check if any device is connected
  if bluetoothctl devices Connected | grep -q "Device"; then
    echo "$ICON_ON" # Blue color when connected
  else
    echo "$ICON_ON" # Default color when on but not connected
  fi
else
  echo "$ICON_OFF" # Dimmed color when off
fi
