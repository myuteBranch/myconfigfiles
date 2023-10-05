#!/bin/bash

# update system
sudo apt update && sudo apt upgrade -y
sudo apt install git nodejs neovim ripgrep build-base wget
# install zsh and oh-my-zsh
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install pl10k
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g' ~/.zshrc

# install nvim and astrovim
sudo snap install nvim --classic
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim --headless