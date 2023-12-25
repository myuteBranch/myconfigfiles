
#!/bin/bash

BASEDIR=$(dirname $(realpath "$0"))
# install tools
sh $BASEDIR/tools_install.sh
# install rust and rust tools
sh $BASEDIR/rust.sh
# install golang and go tools
sh $BASEDIR/golang.sh
