#!/usr/bin/env bash
set -euo pipefail

# Arch install script derived from nixos-flake/hosts/default/hardware-configuration.nix
#
# Matches layout:
# - UEFI + systemd-boot
# - Btrfs root partition with subvolumes: root, home, log
# - Mounts:
#   /         -> subvol=root,compress=zstd
#   /home     -> subvol=home,compress=zstd
#   /var/log  -> subvol=log,compress=zstd
#   /boot     -> vfat EFI partition
# - No swap
#
# Usage (from Arch ISO):
#   chmod +x ./install_arch_default_host.sh
#   ./install_arch_default_host.sh /dev/nvme0n1 default myute
#
# WARNING: This wipes the target disk.

DISK_INPUT="${1:-}"
HOSTNAME="${2:-default}"
USERNAME="${3:-myute}"
MICROCODE_PKG_INPUT="${4:-auto}" # auto|amd-ucode|intel-ucode|none
TIMEZONE="America/Chicago"
LOCALE="en_US.UTF-8"

on_error() {
  echo
  echo "Error: installation failed. Attempting cleanup..."
  if mountpoint -q /mnt; then
    umount -R /mnt || true
  fi
}
trap on_error ERR INT TERM

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: required command not found: $1"
    exit 1
  }
}

for cmd in lsblk readlink partprobe udevadm parted mkfs.fat mkfs.btrfs mount umount btrfs pacstrap genfstab blkid arch-chroot bootctl; do
  require_cmd "$cmd"
done

if [[ -z "${DISK_INPUT}" ]]; then
  echo "Usage: $0 <disk> [hostname] [username] [microcode]"
  echo "Example: $0 /dev/nvme0n1 default myute auto"
  exit 1
fi

DISK="$(readlink -f "${DISK_INPUT}")"

if [[ ! -b "${DISK}" ]]; then
  echo "Error: ${DISK_INPUT} (resolved to ${DISK}) is not a block device"
  exit 1
fi

if [[ "$(lsblk -ndo TYPE "${DISK}")" != "disk" ]]; then
  echo "Error: ${DISK} is not a whole-disk device (refusing to continue)"
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Error: run as root"
  exit 1
fi

if [[ ! -d /sys/firmware/efi ]]; then
  echo "Error: system not booted in UEFI mode"
  exit 1
fi

if mountpoint -q /mnt; then
  echo "Error: /mnt is already mounted. Unmount it before running this script."
  exit 1
fi

if ! [[ "${HOSTNAME}" =~ ^[a-zA-Z0-9][a-zA-Z0-9.-]{0,62}$ ]]; then
  echo "Error: invalid hostname '${HOSTNAME}'"
  exit 1
fi

if ! [[ "${USERNAME}" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]; then
  echo "Error: invalid username '${USERNAME}'"
  exit 1
fi

MICROCODE_PKG="${MICROCODE_PKG_INPUT}"
if [[ "${MICROCODE_PKG}" == "auto" ]]; then
  if grep -qi 'AuthenticAMD' /proc/cpuinfo; then
    MICROCODE_PKG="amd-ucode"
  elif grep -qi 'GenuineIntel' /proc/cpuinfo; then
    MICROCODE_PKG="intel-ucode"
  else
    MICROCODE_PKG="none"
  fi
fi

if [[ "${MICROCODE_PKG}" != "amd-ucode" && "${MICROCODE_PKG}" != "intel-ucode" && "${MICROCODE_PKG}" != "none" ]]; then
  echo "Error: invalid microcode option '${MICROCODE_PKG_INPUT}' (use auto|amd-ucode|intel-ucode|none)"
  exit 1
fi

echo "Target disk: ${DISK}"
echo "Hostname: ${HOSTNAME}"
echo "Username: ${USERNAME}"
echo "Microcode: ${MICROCODE_PKG}"
echo
echo "Current block devices:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS,MODEL

echo
read -r -p "This will ERASE ${DISK}. Type 'YES' to continue: " CONFIRM
if [[ "${CONFIRM}" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

PART_SUFFIX=""
if [[ "${DISK}" =~ [0-9]$ ]]; then
  PART_SUFFIX="p"
fi

EFI_PART="${DISK}${PART_SUFFIX}1"
BTRFS_PART="${DISK}${PART_SUFFIX}2"

echo "[1/9] Partitioning ${DISK}..."
parted -s "${DISK}" -- \
  mklabel gpt \
  mkpart ESP fat32 1MiB 1025MiB \
  set 1 esp on \
  mkpart primary btrfs 1025MiB 100%

# Ensure kernel/udev see new partition table
partprobe "${DISK}"
udevadm settle

for _ in {1..10}; do
  if [[ -b "${EFI_PART}" && -b "${BTRFS_PART}" ]]; then
    break
  fi
  sleep 1
done

if [[ ! -b "${EFI_PART}" || ! -b "${BTRFS_PART}" ]]; then
  echo "Error: partition nodes not detected (${EFI_PART}, ${BTRFS_PART})"
  exit 1
fi

echo "[2/9] Formatting partitions..."
mkfs.fat -F 32 "${EFI_PART}"
mkfs.btrfs -f "${BTRFS_PART}"

echo "[3/9] Creating Btrfs subvolumes..."
mount "${BTRFS_PART}" /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/log
umount /mnt

echo "[4/9] Mounting target filesystem layout..."
mount -o subvol=root,compress=zstd "${BTRFS_PART}" /mnt
mkdir -p /mnt/{boot,home,var/log}
mount -o subvol=home,compress=zstd "${BTRFS_PART}" /mnt/home
mount -o subvol=log,compress=zstd "${BTRFS_PART}" /mnt/var/log
mount "${EFI_PART}" /mnt/boot

echo "[5/9] Installing base system..."
PACSTRAP_PACKAGES=(
  base
  linux
  linux-firmware
  btrfs-progs
  efibootmgr
  networkmanager
  sudo
  git
  vim
  fish
)
if [[ "${MICROCODE_PKG}" != "none" ]]; then
  PACSTRAP_PACKAGES+=("${MICROCODE_PKG}")
fi
pacstrap -K /mnt "${PACSTRAP_PACKAGES[@]}"

echo "[6/9] Generating fstab..."
genfstab -U /mnt > /mnt/etc/fstab

ROOT_UUID="$(blkid -s UUID -o value "${BTRFS_PART}")"

echo "[7/9] Configuring system..."
arch-chroot /mnt /usr/bin/env \
  TIMEZONE="${TIMEZONE}" \
  LOCALE="${LOCALE}" \
  HOSTNAME="${HOSTNAME}" \
  USERNAME="${USERNAME}" \
  ROOT_UUID="${ROOT_UUID}" \
  MICROCODE_PKG="${MICROCODE_PKG}" \
  /bin/bash -s <<'EOF'
set -euo pipefail

ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
hwclock --systohc

sed -i "s/^#\(${LOCALE} UTF-8\)/\1/" /etc/locale.gen
locale-gen

echo "LANG=${LOCALE}" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

echo "${HOSTNAME}" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}
HOSTS

cat > /etc/sudoers.d/10-wheel <<SUDO
%wheel ALL=(ALL:ALL) ALL
SUDO
chmod 0440 /etc/sudoers.d/10-wheel

groupadd -f docker
groupadd -f networkmanager
useradd -m -G wheel,docker,networkmanager -s /usr/bin/fish "${USERNAME}"

bootctl --path=/boot install
mkdir -p /boot/loader/entries

cat > /boot/loader/loader.conf <<LOADER
default arch.conf
timeout 3
editor no
LOADER

if [[ "${MICROCODE_PKG}" == "amd-ucode" ]]; then
  MICROCODE_INITRD="/amd-ucode.img"
elif [[ "${MICROCODE_PKG}" == "intel-ucode" ]]; then
  MICROCODE_INITRD="/intel-ucode.img"
else
  MICROCODE_INITRD=""
fi

cat > /boot/loader/entries/arch.conf <<ENTRY
title   Arch Linux
linux   /vmlinuz-linux
ENTRY

if [[ -n "${MICROCODE_INITRD}" ]]; then
  echo "initrd  ${MICROCODE_INITRD}" >> /boot/loader/entries/arch.conf
fi

cat >> /boot/loader/entries/arch.conf <<ENTRY
initrd  /initramfs-linux.img
options root=UUID=${ROOT_UUID} rootflags=subvol=root,compress=zstd rw
ENTRY

systemctl enable NetworkManager
EOF

echo "[8/9] Set passwords..."
echo "Set root password:"
arch-chroot /mnt passwd root

echo "Set password for ${USERNAME}:"
arch-chroot /mnt passwd "${USERNAME}"

echo "[9/9] Done."
echo "You can now reboot."
echo "Before reboot: umount -R /mnt"
