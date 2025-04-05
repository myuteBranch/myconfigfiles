#!/bin/bash
set -eux

ln -s /home/myutex/src/myconfigfiles/dotfiles/alacritty.toml /home/myutex/.config/alacritty/alacritty.toml
sudo apt install libfreetype6-dev libfontconfig1-dev libx11-dev libxft-dev libxext-dev
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release
sudo cp target/release/alacritty /usr/bin/
cd ..
rm -rf alacritty