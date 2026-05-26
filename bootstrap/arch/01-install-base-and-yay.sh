#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this as your normal user, not root."
  exit 1
fi

command -v sudo >/dev/null 2>&1 || {
  echo "sudo is required."
  exit 1
}

sudo -v

BASE_PACKAGES=(
  base-devel
  bat
  btop
  curl
  difftastic
  eza
  fastfetch
  fish
  fzf
  git
  jq
  less
  openssh
  starship
  vim
  wget
  binutils
  file
  gcc
  make
  sed
  tar
  gzip
  patch
  pkgconf
  unzip
  which
  xz
  neovim
  man-db
  man-pages
)

echo "==> Installing base packages..."
sudo pacman -Syu --needed --noconfirm "${BASE_PACKAGES[@]}"

echo "==> Enabling sshd..."
sudo systemctl enable --now sshd

if command -v yay >/dev/null 2>&1; then
  echo "==> yay already installed"
  exit 0
fi

echo "==> Installing yay..."
workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

git clone https://aur.archlinux.org/yay.git "${workdir}/yay"
pushd "${workdir}/yay" >/dev/null

makepkg -s --noconfirm

pkg_file="$(find . -maxdepth 1 -type f -name 'yay-*.pkg.tar*' ! -name '*.sig' | head -n1)"
if [[ -z "${pkg_file}" ]]; then
  echo "Failed to build yay package."
  exit 1
fi

sudo pacman -U --needed --noconfirm "${pkg_file}"
popd >/dev/null

echo "==> Base setup complete"
