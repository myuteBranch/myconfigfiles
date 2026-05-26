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

MARK_BEGIN="# >>> myconfigfiles multilib >>>"
MARK_END="# <<< myconfigfiles multilib <<<"

if ! sudo grep -Fqx "${MARK_BEGIN}" /etc/pacman.conf; then
  echo "==> Enabling multilib..."
  printf '\n%s\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n%s\n' \
    "${MARK_BEGIN}" "${MARK_END}" | sudo tee -a /etc/pacman.conf >/dev/null
  sudo pacman -Sy --noconfirm
else
  echo "==> multilib already enabled"
fi

GAMING_PACKAGES=(
  steam
  mangohud
  vulkan-tools
  vulkan-radeon
  lib32-vulkan-radeon
  radeontop
  goverlay
  protontricks
  winetricks
  gamescope
  gamemode
)

echo "==> Installing gaming packages..."
sudo pacman -S --needed --noconfirm "${GAMING_PACKAGES[@]}"

echo "==> Gaming setup complete"
echo "Note: this script assumes your gaming stack is AMD-based."
