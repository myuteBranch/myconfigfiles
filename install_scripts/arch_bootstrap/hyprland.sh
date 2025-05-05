#!/bin/bash
set -eux

sudo pacman -Syu hyprland \
                waybar \
                rofi-wayland \
                xdg-desktop-portal-hyprland \
                qt5-wayland \
                qt6-wayland \
                pipewire \
                wireplumber \
                polkit-kde-agent \
                wl-clipboard \
                swaylock \
                swayidle \
                swaybg \
                dunst

rm -rf $HOME/.config/hypr
ln -s $HOME/src/myconfigfiles/dotfiles/hypr $HOME/.config/hypr
rm -rf $HOME/.config/waybar
ln -s $HOME/src/myconfigfiles/dotfiles/waybar $HOME/.config/waybar
rm -rf $HOME/.config/rofi
ln -s $HOME/src/myconfigfiles/dotfiles/rofi $HOME/.config/rofi