#!/bin/bash

BASEDIR=$(dirname $(realpath "$0"))
# Install rust
curl https://sh.rustup.rs -sSf | sh -s -- -y
# install rust tools
