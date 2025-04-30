#!/bin/bash
set -eux

sudo pacman -S fish
chsh -s /usr/bin/fish
curl -sS https://starship.rs/install.sh | sh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# link
rm -rf ~/.config/fish
ln -s $HOME/src/myconfigfiles/dotfiles/fish $HOME/.config/fish
