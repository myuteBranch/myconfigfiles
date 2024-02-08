
#!/bin/bash

BASEDIR=$(dirname $(realpath "$0"))
APPDIR=$(dirname $(dirname $(dirname $(realpath "$0"))))

sudo apt install i3 i3blocks compton lxappearance feh

cp -R $APPDIR/dotfiles/i3 ~/.config/i3/
