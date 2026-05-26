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

TIMEZONE="${TIMEZONE:-America/Chicago}"
LOCALE="${LOCALE:-en_US.UTF-8}"
HOSTNAME_VALUE="${HOSTNAME_VALUE:-$(hostnamectl --static 2>/dev/null || hostname)}"
KEYBOARD_LAYOUT="${KEYBOARD_LAYOUT:-us}"
KEYBOARD_VARIANT="${KEYBOARD_VARIANT:-dvorak}"
KEYBOARD_OPTIONS="${KEYBOARD_OPTIONS:-grp:shift_caps_toggle}"
LOGIN_USER="${SUDO_USER:-${USER}}"
FISH_SHELL="/usr/bin/fish"

if ! id "${LOGIN_USER}" >/dev/null 2>&1; then
  echo "User ${LOGIN_USER} does not exist."
  exit 1
fi

echo "==> Setting hostname to ${HOSTNAME_VALUE}"
sudo hostnamectl set-hostname "${HOSTNAME_VALUE}"

echo "==> Setting timezone to ${TIMEZONE}"
sudo ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
sudo hwclock --systohc

echo "==> Configuring locale ${LOCALE}"
if ! grep -Eq "^${LOCALE//./\\.} UTF-8$" /etc/locale.gen; then
  sudo sed -i "s/^#\(${LOCALE//./\\.} UTF-8\)/\1/" /etc/locale.gen
fi
sudo locale-gen
printf 'LANG=%s\n' "${LOCALE}" | sudo tee /etc/locale.conf >/dev/null

echo "==> Configuring keyboard layout"
sudo install -d -m 0755 /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/00-keyboard.conf >/dev/null <<EOF
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "${KEYBOARD_LAYOUT}"
    Option "XkbVariant" "${KEYBOARD_VARIANT}"
    Option "XkbOptions" "${KEYBOARD_OPTIONS}"
EndSection
EOF

echo "==> Ensuring groups exist"
sudo groupadd -f wheel
sudo groupadd -f networkmanager
sudo groupadd -f docker

current_groups="$(id -nG "${LOGIN_USER}")"
ensure_group_membership() {
  local group="$1"
  if ! printf '%s\n' "${current_groups}" | tr ' ' '\n' | grep -Fxq "${group}"; then
    echo "==> Adding ${LOGIN_USER} to ${group}"
    sudo usermod -aG "${group}" "${LOGIN_USER}"
  fi
}

ensure_group_membership wheel
ensure_group_membership networkmanager
ensure_group_membership docker

if [[ -x "${FISH_SHELL}" ]]; then
  current_shell="$(getent passwd "${LOGIN_USER}" | cut -d: -f7)"
  if [[ "${current_shell}" != "${FISH_SHELL}" ]]; then
    echo "==> Setting login shell to ${FISH_SHELL}"
    sudo chsh -s "${FISH_SHELL}" "${LOGIN_USER}"
  else
    echo "==> Login shell already set to ${FISH_SHELL}"
  fi
else
  echo "==> fish is not installed yet; shell change will happen after base packages are installed"
fi

echo "==> Ensuring wheel has sudo access"
sudo install -d -m 0755 /etc/sudoers.d
printf '%%wheel ALL=(ALL:ALL) ALL\n' | sudo tee /etc/sudoers.d/10-wheel >/dev/null
sudo chmod 0440 /etc/sudoers.d/10-wheel

echo "==> System setup complete"
echo "If group membership changed, log out and back in for it to fully apply."
