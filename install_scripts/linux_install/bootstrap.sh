#!/bin/bash

BASEDIR=$(dirname $(realpath "$0"))
# install tools
sh $BASEDIR/install_tools.sh
# install rust and rust tools
sh $BASEDIR/rust.sh
# install golang and go tools
sh $BASEDIR/golang.sh
# install docker
sh $BASEDIR/install_docker.sh
