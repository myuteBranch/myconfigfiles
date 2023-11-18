#!/bin/bash

BASEDIR=$(dirname $(realpath "$0"))

# install golang and lazygit
wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.4.linux-amd64.tar.gz && rm -rf go1.21.4.linux-amd64.tar.gz
/usr/local/go/bin/go install github.com/jesseduffield/lazygit@latest
