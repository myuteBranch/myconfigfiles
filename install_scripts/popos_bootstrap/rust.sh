#!/bin/bash
set -eux

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install tools
sudo apt install openssl libssl-dev clang lldb pkg-config
cargo install jj-cli eza difftastic just bat --locked