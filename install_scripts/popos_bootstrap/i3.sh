#!/bin/bash
set -eux

/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2025.03.09_all.deb keyring.deb SHA256:2c2601e6053d5c68c2c60bcd088fa9797acec5f285151d46de9c830aaba6173c
sudo apt install ./keyring.deb
echo "deb [signed-by=/usr/share/keyrings/sur5r-keyring.gpg] http://debian.sur5r.net/i3/ $(grep '^VERSION_CODENAME=' /etc/os-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
# install required packages
sudo apt install i3 rofi polybar feh picom lxappearance fonts-font-awesome network-manager-gnome blueman dunst arandr
rm -f keyring.deb

# link i3 config
ln -s $HOME/src/myconfigfiles/dotfiles/i3/config $HOME/.config/i3/config
# link polybar config directory
ln -s $HOME/src/myconfigfiles/dotfiles/polybar $HOME/.config/polybar
# link rofi config
ln -s $HOME/src/myconfigfiles/dotfiles/rofi/config.rasi $HOME/.config/rofi/config.rasi