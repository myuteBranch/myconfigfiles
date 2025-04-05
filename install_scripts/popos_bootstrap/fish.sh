#!/bin/bash
set -eux

sudo apt update
sudo apt install fish
chsh -s /usr/bin/fish
curl -sS https://starship.rs/install.sh | sh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# link
ln -s /home/myutex/src/myconfigfiles/dotfiles/fish /home/myutex/.config/fish