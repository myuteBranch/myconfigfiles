#!/bin/bash
set -eux

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

ln -s $HOME/src/myconfigfiles/dotfiles/lazynvim/lua $HOME/.config/nvim/lua