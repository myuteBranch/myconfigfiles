#!/bin/bash



BASEDIR=$(dirname $(realpath "$0"))

APPDIR=$(dirname $(dirname $(dirname $(realpath "$0"))))
# update system
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y nodejs ripgrep wget gcc tmux

# install zsh and oh-my-zsh
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# install pl10k
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g' ~/.zshrc

# install nvim and config files
sudo snap install nvim --classic
cp -R $APPDIR/dotfiles/nvim ~/.config/nvim/
cp $APPDIR/dotfiles/.tmux.conf ~/
cp $APPDIR/dotfiles/.zshrc ~/

# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
