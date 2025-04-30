#!/bin/bash
set -eux

# Install base packages
sudo pacman -S --needed git base-devel xclip arandr dunst lxappearance feh picom polybar rofi alacritty dolphin bat pacman-contrib reflector
sudo systemctl enable paccache.timer
sudo systemctl start paccache.timer

sudo systemctl enable reflector.service
sudo systemctl start reflector.service

# install yay
mkdir src
cd src
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# install thorium browser
yay -S thorium-browser-bin

# clone config files
git clone https://github.com/myuteBranch/myconfigfiles.git

# configure i3 polybar and rofi
rm -rf $HOME/.config/i3
ln -s $HOME/src/myconfigfiles/dotfiles/i3 $HOME/.config/i3
ln -s $HOME/src/myconfigfiles/dotfiles/polybar/ $HOME/.config/polybar
mkdir ~/.config/rofi
ln -s $HOME/src/myconfigfiles/dotfiles/rofi/config.rasi $HOME/.config/rofi/config.rasi
mkdir ~/.config/alacritty
ln -s $HOME/src/myconfigfiles/dotfiles/alacritty.toml $HOME/.config/alacritty/alacritty.toml

#configure neovim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf $HOME/.config/nvim/.git
rm -rf $HOME/.config/nvim/lua/
ln -s $HOME/src/myconfigfiles/dotfiles/lazynvim/lua $HOME/.config/nvim/lua

# install and setup fishshell
sh $HOME/src/myconfigfiles/install_scripts/arch_bootstrap/fish.sh

# install rust and rust tools
sh $HOME/src/myconfigfiles/install_scripts/arch_bootstrap/rust.sh