#!/bin/bash
set -eux

sudo rm -fv /etc/apt/sources.list.d/thorium.list && \
sudo wget --no-hsts -P /etc/apt/sources.list.d/ \
http://dl.thorium.rocks/debian/dists/stable/thorium.list && \
sudo apt update

sudo apt install thorium-browser
