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

DESKTOP_PACKAGES=(
  plasma-desktop
  plasma-workspace
  kde-cli-tools
  kde-gtk-config
  xdg-desktop-portal
  xdg-desktop-portal-kde
  sddm
  dolphin
  konsole
  spectacle
  ark
  gwenview
  okular
  alacritty
  pavucontrol
  bluedevil
  bluez
  bluez-utils
  pipewire
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
  wireplumber
  gvfs
  udisks2
  upower
  dconf
  networkmanager
  network-manager-applet
  kscreen
  noto-fonts
  noto-fonts-emoji
  ttf-jetbrains-mono-nerd
  ttf-meslo-nerd
  ttf-cascadia-code-nerd
  breeze
  breeze-gtk
  kvantum
  libqalculate
  mpv
)

echo "==> Installing desktop packages..."
sudo pacman -S --needed --noconfirm "${DESKTOP_PACKAGES[@]}"

echo "==> Installing desktop AUR packages..."
AUR_DESKTOP_PACKAGES=(
  vivaldi
)

for pkg in "${AUR_DESKTOP_PACKAGES[@]}"; do
  if pacman -Q "${pkg}" >/dev/null 2>&1; then
    echo "==> ${pkg} already installed"
    continue
  fi

  yay --sync --needed --noconfirm "${pkg}"
done

echo "==> Writing desktop config files..."
sudo install -d -m 0755 /etc/environment.d
sudo install -d -m 0755 /etc/sddm.conf.d
sudo install -d -m 0755 /etc/xdg/xdg-desktop-portal

sudo tee /etc/environment.d/99-myconfigfiles-desktop.conf >/dev/null <<'EOF'
EDITOR=nvim
VISUAL=zeditor
TERMINAL=alacritty
XDG_SESSION_TYPE=wayland
XDG_CURRENT_DESKTOP=KDE
XDG_SESSION_DESKTOP=KDE
DESKTOP_SESSION=plasma
GDK_BACKEND=wayland,x11,*
QT_QPA_PLATFORM=wayland;xcb
QT_STYLE_OVERRIDE=kvantum
SDL_VIDEODRIVER=wayland
MOZ_ENABLE_WAYLAND=1
ELECTRON_OZONE_PLATFORM_HINT=wayland
OZONE_PLATFORM=wayland
XCURSOR_SIZE=24
EOF

sudo tee /etc/sddm.conf.d/10-plasma-wayland.conf >/dev/null <<'EOF'
[General]
DisplayServer=wayland

[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1

[Autologin]
Relogin=false

[Users]
MaximumUid=60000
MinimumUid=1000
EOF

sudo tee /etc/xdg/xdg-desktop-portal/portals.conf >/dev/null <<'EOF'
[preferred]
default=kde
org.freedesktop.impl.portal.FileChooser=kde
org.freedesktop.impl.portal.Screenshot=kde
org.freedesktop.impl.portal.ScreenCast=kde
EOF

echo "==> Enabling desktop services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now sddm

echo "==> Desktop setup complete"
