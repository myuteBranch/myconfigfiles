# NixOS Flake

This directory contains a modular NixOS + Home Manager flake for managing multiple NixOS hosts.

The configuration is organized so that:

- `flake.nix` defines hosts and wires shared arguments into NixOS and Home Manager
- `hosts/<name>/configuration.nix` contains host-specific configuration
- `modules/` contains reusable NixOS modules
- `home/` contains reusable Home Manager modules and per-user entrypoints

## Overview

The flake currently builds hosts through a helper in `flake.nix` and exports them under `nixosConfigurations`.

Each host gets:

- a host-specific `configuration.nix`
- Home Manager integrated as a NixOS module
- shared arguments like `username`, `hostname`, and `stateVersion`
- optional extra system modules through the host definition

## Repository Structure


### Hosts

Each host lives under `hosts/<name>/`.

A host configuration is responsible for machine-specific concerns such as:

- importing shared modules
- importing `hardware-configuration.nix`
- bootloader choice
- kernel selection
- filesystem-related settings
- machine-specific desktop settings
- Docker, gaming, laptop behavior, and other per-host toggles

### System module structure

The `modules/` directory is split into wrapper modules and focused submodules.

#### Wrapper modules

- `modules/common.nix`
  - imports the common system baseline
- `modules/hyprland.nix`
  - imports the desktop/Hyprland-related modules

These wrappers let a host enable a whole feature group with a single import.


### Home Manager structure

The `home/` directory is split into per-user entrypoints and reusable user modules.

#### User entrypoints

A user entrypoint typically:

- imports reusable Home Manager modules
- sets `home.username`
- sets `home.homeDirectory`
- sets `home.stateVersion`
- toggles optional user-level modules

## How hosts are defined

Host definitions live in `flake.nix`.

Each host entry provides values like:

- `hostname`
- `configname`
- `username`
- `system`
- `stateVersion`

The helper in `flake.nix` then builds a NixOS system from:

- `./hosts/${configname}/configuration.nix`
- Home Manager's NixOS module
- an inline module that sets:
  - `networking.hostName`
  - `system.stateVersion`
  - `home-manager.users.${username} = import ./home/${username}.nix`

Because of that setup, host names and user entrypoint names matter:

- `configname` must match a directory under `hosts/`
- `username` must match a file under `home/` such as `home/<username>.nix`

## How to add a new NixOS host

To add a new host named `laptop`:

### 1. Create the host directory

Create:

- `hosts/laptop/configuration.nix`

Later, after installation, you will also place:

- `hosts/laptop/hardware-configuration.nix`

### 2. Add the host entry to `flake.nix`

Add a new attribute under the `hosts` set in `flake.nix`, for example:

- `laptop.hostname = "laptop"`
- `laptop.configname = "laptop"`
- `laptop.username = "myute"`
- `laptop.system = "x86_64-linux"`
- `laptop.stateVersion = "25.11"`

The important part is that:

- `configname = "laptop"` matches `hosts/laptop/configuration.nix`
- `username` matches an existing `home/<username>.nix`

### 3. Write `hosts/laptop/configuration.nix`

A typical host imports:

- `./hardware-configuration.nix`
- `../../modules/common.nix`
- `../../modules/host-defaults.nix`

Then optionally imports feature modules such as:

- `../../modules/hyprland.nix`
- `../../modules/gaming.nix`

This file should contain host-only settings such as:

- bootloader configuration
- kernel choice
- desktop enablement
- monitor configuration
- network interface name
- laptop/server-specific behavior

### 4. Ensure the Home Manager user entrypoint exists

If your host uses:

- `username = "myute"`

then this file must exist:

- `home/myute.nix`

If you want a different primary user, create the matching file:

- `home/<username>.nix`

## How to set up a new NixOS system with Btrfs

These are practical steps for bringing up a fresh machine and then moving it into this flake.

Adjust device names to match your machine.

### 1. Boot the NixOS installer

Boot the NixOS ISO in UEFI mode.

Confirm your target disk, for example with:

- `lsblk`
- `blkid`

In the examples below, the target disk is assumed to be:

- `/dev/nvme0n1`

with partitions:

- `/dev/nvme0n1p1` = EFI
- `/dev/nvme0n1p2` = Btrfs

### 2. Partition the disk

Create a GPT partition table with:

- an EFI system partition
- a Btrfs partition for NixOS

One common approach is:

- `p1` = EFI, a few hundred MiB
- `p2` = the rest of the disk as Btrfs

### 3. Format the partitions

Format the EFI partition as FAT32:

```
mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.btrfs -f /dev/nvme0n1p2
```
### 4. Create Btrfs subvolumes
```
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@log
umount /mnt
```

### 5. Mount the subvolumes
```
mount -o compress=zstd,subvol=@root /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{home,nix,var/log}
mount -o compress=zstd,subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o compress=zstd,subvol=@nix /dev/nvme0n1p2 /mnt/nix
mount -o compress=zstd,subvol=@log /dev/nvme0n1p2 /mnt/var/log

mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### 6. generate the hardware configuration

```
nixos-generate-config --root /mnt
```
### 7. Copy `hardware-configuration.nix` into the flake

On your flake repository, place it at:

- `hosts/<name>/hardware-configuration.nix`

For example:

- `hosts/laptop/hardware-configuration.nix`

Then make sure `hosts/laptop/configuration.nix` imports it.

### 8. Confirm the generated Btrfs mount definitions

Open the generated `hardware-configuration.nix` and verify that:

- the filesystem type is `btrfs`
- mount points are correct
- subvolumes are referenced correctly
- the EFI mount point matches your bootloader setup

### 9. Install using the flake

From the live installer environment, clone or copy this repository, enter `nixos-flake/`, and run:

- `sudo nixos-install --flake .#<host>`

Example:

- `sudo nixos-install --flake .#laptop`

That installs the system using your host definition from this flake.

## How to run this flake on a new system

Once the machine is installed and booted into the new system:

1. clone this repository onto the machine
2. enter `nixos-flake/`
3. review the host config and any machine-specific settings
4. rebuild with the matching host name

Example:

- `sudo nixos-rebuild switch --flake .#laptop`

For existing hosts in this repository, that looks like:

- `sudo nixos-rebuild switch --flake .#default`
- `sudo nixos-rebuild switch --flake .#server`

Because Home Manager is integrated into the NixOS configuration, the user environment is applied during the same rebuild.
