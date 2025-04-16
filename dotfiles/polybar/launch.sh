#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Find the primary monitor name
PRIMARY_MONITOR=$(xrandr --query | grep " primary" | cut -d" " -f1)

# Check if xrandr is available
if type "xrandr"; then
  # Loop through each connected monitor name detected by xrandr
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    echo "--- Checking monitor $m ---"
    # Launch the 'main' bar config (which is hardcoded to DisplayPort-0 and has tray)
    # only if the current monitor is the primary one.
    if [[ "$m" == "$PRIMARY_MONITOR" ]] && [[ "$m" == "DisplayPort-0" ]]; then
      echo "Launching main bar (DisplayPort-0 with tray)"
      polybar --config=~/.config/polybar/config.ini --reload main &
    # Launch the 'secondary' bar config (hardcoded to HDMI-A-1, no tray)
    # only if the current monitor is HDMI-A-1.
    elif [[ "$m" == "HDMI-A-1" ]]; then
      echo "Launching secondary bar (HDMI-A-1 without tray)"
      polybar --config=~/.config/polybar/config.ini --reload secondary &
    else
      echo "Monitor $m not configured for a bar."
    fi
    sleep 1 # Optional delay
  done
else
  # Fallback if xrandr not found - attempt to launch main bar
  # (This might only work if DisplayPort-0 is connected)
  echo "--- xrandr not found, attempting to launch main bar ---"
  polybar --config=~/.config/polybar/config.ini --reload main &
fi

echo "Polybar launch sequence finished."
