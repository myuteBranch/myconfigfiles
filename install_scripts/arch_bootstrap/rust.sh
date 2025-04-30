#!/bin/bash
set -eux

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install tools
sudo pacman -S bat
cargo install jj-cli eza difftastic just --locked

