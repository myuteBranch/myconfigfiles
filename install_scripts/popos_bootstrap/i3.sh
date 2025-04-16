#!/bin/bash
set -eux

# install required packages
sudo apt install i3 rofi polybar feh picom lxappearance fonts-font-awesome network-manager-gnome blueman dunst arandr

# link i3 config
ln -s $HOME/src/myconfigfiles/dotfiles/i3/config $HOME/.config/i3/config
# link polybar config directory
ln -s $HOME/src/myconfigfiles/dotfiles/polybar $HOME/.config/polybar
# link rofi config
ln -s $HOME/src/myconfigfiles/dotfiles/rofi/config.rasi $HOME/.config/rofi/config.rasi