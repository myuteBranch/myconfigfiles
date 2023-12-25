#!/bin/bash

BASEDIR=$(dirname $(realpath "$0"))
APPDIR=$(dirname $(dirname $(dirname $(realpath "$0"))))
#  install homebrew and update system
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update && brew upgrade
sudo brew install nodejs ripgrep wget gcc tmux lazygit

# install zsh and oh-my-zsh
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# install pl10k
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g' ~/.zshrc

# install nvim and config files
brew install neovim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.config/nvim
cp -R $APPDIR/dotfiles/nvim ~/.config/
cp $APPDIR/dotfiles/.tmux.conf ~/
cp $APPDIR/dotfiles/.zshrc ~/
# install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
