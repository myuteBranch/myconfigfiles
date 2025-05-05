#!/bin/bash

# Options for powermenu
lock=" Lock"
logout=" Logout"
shutdown=" Shutdown"
reboot=" Reboot"
sleep=" Sleep"

# Get confirmation
confirm_exit() {
  wofi -dmenu -i -p "Are you sure? > " \
    -theme-str 'window {width: 20%;}' \
    -theme-str 'listview {lines: 2;}' \
    -theme-str 'textbox-prompt-colon {str: "Confirmation";}'
}

# Display powermenu
chosen=$(printf "%s\n%s\n%s\n%s\n%s" "$lock" "$logout" "$sleep" "$reboot" "$shutdown" | rofi -dmenu -i -p "Power Menu" -theme-str 'window {width: 20%;}' -theme-str 'listview {lines: 5;}')

# Execute command
case "$chosen" in
"$shutdown")
  ans=$(confirm_exit &)
  if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
    systemctl poweroff
  fi
  ;;
"$reboot")
  ans=$(confirm_exit &)
  if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
    systemctl reboot
  fi
  ;;
"$lock")
  # Use a screen locker. i3lock-fancy is a popular choice, or just i3lock.
  # Install it first: sudo apt install i3lock-fancy or i3lock
  # i3lock-fancy -p # Pixelated lock
  swaylock -c 000000 # Simple black lock screen
  ;;
"$logout")
  ans=$(confirm_exit &)
  if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
    hyperctl dispatch exit
  fi
  ;;
"$sleep")
  # Check if systemctl hybrid-sleep works better if suspend has issues
  systemctl suspend
  ;;
esac
