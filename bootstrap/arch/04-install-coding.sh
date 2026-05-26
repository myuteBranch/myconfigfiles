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

command -v yay >/dev/null 2>&1 || {
  echo "yay is required. Run ./01-install-base-and-yay.sh first."
  exit 1
}

sudo -v

CODING_PACKAGES=(
  just
  go
  rustup
  tree-sitter
  nodejs
  gopls
  lua-language-server
  stylua
  ripgrep
  highlight
  tmux
  zed
)

echo "==> Installing coding packages..."
sudo pacman -S --needed --noconfirm "${CODING_PACKAGES[@]}"

echo "==> Installing coding AUR packages..."
AUR_CODING_PACKAGES=(
  jujutsu
)

for pkg in "${AUR_CODING_PACKAGES[@]}"; do
  if pacman -Q "${pkg}" >/dev/null 2>&1; then
    echo "==> ${pkg} already installed"
    continue
  fi

  yay --sync --needed --noconfirm "${pkg}"
done

echo "==> Coding setup complete"
