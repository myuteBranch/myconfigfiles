# NixOS Flake

This directory contains the NixOS replacement for the workstation setup that was originally managed through the Ansible configuration in `../ansible`.

The current flake is now structured as a modular NixOS + Home Manager configuration rather than a direct file-copy migration.

## Goals

This flake preserves the main intent of the original Ansible roles while expressing them in a more idiomatic Nix way:

- `common`
  - shared CLI packages
  - development toolchains
  - default shell and core programs
  - system-wide Nix and OpenSSH settings
- `dev_user`
  - primary user creation
  - shell selection
  - group membership
  - host defaults
- `rust`
  - Rust tooling through Nix packages
- `golang`
  - Go tooling through Nix packages
- `hyprland`
  - Wayland desktop stack
  - display/session services
  - audio, Bluetooth, portals, and desktop packages
  - user-facing desktop configuration through Home Manager

## High-Level Structure

- `flake.nix`
  - flake entrypoint
  - inputs
  - host construction helper
  - exported `nixosConfigurations`
- `hosts/default/configuration.nix`
  - host-specific enablement
  - imports shared system modules
  - turns on Docker and Hyprland
- `modules/`
  - reusable NixOS modules
  - split into common system, desktop system, and host defaults
- `home/`
  - Home Manager configuration for the primary user
  - split into smaller user-focused modules

## Current Layout

### Top level

- `flake.nix`
- `README.md`
- `hosts/default/configuration.nix`
- `modules/common.nix`
- `modules/hyprland.nix`
- `modules/host-defaults.nix`
- `home/myute.nix`

### System modules

#### Common system modules

- `modules/common/base.nix`
- `modules/common/packages.nix`
- `modules/common/programs.nix`
- `modules/common/services.nix`

`modules/common.nix` is a wrapper that imports these modules.

Responsibilities:

- `base.nix`
  - Nix settings
  - GC defaults
  - documentation cache settings
- `packages.nix`
  - CLI packages
  - build tools
  - Go and Rust tooling
- `programs.nix`
  - `fish`
  - `git`
  - `neovim`
  - default system shell
- `services.nix`
  - shared service defaults such as OpenSSH

#### Desktop system modules

- `modules/desktop/hyprland-options.nix`
- `modules/desktop/base.nix`
- `modules/desktop/display.nix`
- `modules/desktop/audio.nix`
- `modules/desktop/desktop-packages.nix`

`modules/hyprland.nix` is a wrapper that imports these modules.

Responsibilities:

- `hyprland-options.nix`
  - desktop enable option
  - monitor and network interface options
- `base.nix`
  - shared Hyprland desktop baseline
  - portals
  - fonts
  - session variables
  - desktop helper programs
- `display.nix`
  - Hyprland enablement
  - X server
  - display manager
  - default session
- `audio.nix`
  - NetworkManager
  - Bluetooth
  - Polkit
  - PipeWire
  - related desktop services
- `desktop-packages.nix`
  - desktop packages such as Waybar, Rofi, Alacritty, Dunst, and related tools

#### Host defaults

- `modules/host-defaults.nix`

This contains the shared baseline for the current host:

- hostname
- timezone
- locale
- unfree setting
- primary user
- keyboard layout
- common environment variables
- `system.stateVersion`

### Home Manager modules

- `home/modules/core.nix`
- `home/modules/fish.nix`
- `home/modules/shell-ui.nix`
- `home/modules/gui.nix`

`home/myute.nix` is a wrapper that imports these modules.

Responsibilities:

- `core.nix`
  - username
  - home directory
  - Home Manager state version
  - session variables
  - base user packages
- `fish.nix`
  - fish shell configuration
  - abbreviations
  - prompt helpers
  - custom fish functions
  - generated helper scripts
- `shell-ui.nix`
  - shell-oriented UX such as Starship
- `gui.nix`
  - graphical user configuration and generated desktop scripts

## Host Model

`flake.nix` defines a small host-construction helper and currently exports one host:

- `default`

The flake currently assumes:

- username: `myute`
- system: `x86_64-linux`
- state version: `24.11`

The host definition lives in `flake.nix`, while host-specific enablement lives in `hosts/default/configuration.nix`.

## Home Manager Integration

Home Manager is integrated as a NixOS module inside the flake.

That means:

- user configuration is applied together with the system rebuild
- user packages come from the same `nixpkgs`
- Home Manager receives the same shared arguments as the host configuration

The Home Manager entry for the primary user is:

- `home/myute.nix`

## Translation Notes from Ansible

The migration intentionally changes some implementation details while preserving behavior:

- imperative package installation became declarative package lists
- Rust and Go are provided through Nix packages instead of installation scripts
- user configuration is expressed through Home Manager modules instead of copying dotfiles
- desktop helper scripts are generated from Nix where practical
- Arch-specific package manager behavior such as `yay` is not reproduced

## What Has Been Modernized

Compared with the initial migration state, the flake now has these improvements:

- no copied home config tree remains
- Home Manager config is split into focused modules
- system config is split into focused modules
- host defaults are extracted into a reusable module
- desktop and shell behavior are mostly expressed declaratively
- generated helper scripts are used instead of ad hoc copied scripts

## Applying the Configuration

Typical workflow:

1. Enter the flake directory.
2. Review the host and module settings.
3. Rebuild with:

   `sudo nixos-rebuild switch --flake .#default`

Because Home Manager is integrated into the NixOS configuration, the user environment is applied as part of the same rebuild.

## Extending the Flake

### Add another host

To add another host:

1. create `hosts/<name>/configuration.nix`
2. add an entry under `hosts` in `flake.nix`
3. optionally add more host-specific modules to that host's `modules` list

### Parameterize defaults

A natural next step would be parameterizing:

- hostname
- username
- locale
- timezone
- monitor names
- network interface

At the moment, these are still tailored to the current workstation.

## Known Assumptions

This flake currently assumes:

- the primary user is `myute`
- the target platform is `x86_64-linux`
- Hyprland is the intended desktop environment
- Docker should be enabled on the default host
- the default keyboard layout is `us` with `dvorak`
- the desktop configuration is aimed at a personal workstation rather than a generic machine

## Suggested Next Improvements

Potential follow-up work:

- parameterize hostname and username in `modules/host-defaults.nix`
- add more hosts to validate the structure
- extract desktop-specific constants into per-host options
- reduce remaining large inline config blocks where native module options exist
- add bootloader and hardware-specific system modules for a fully deployable machine profile
- add secrets management if private values are introduced

## Summary

This flake is no longer just a rough Ansible translation. It is now a modular NixOS/Home Manager configuration with:

- wrapper modules at the top level
- focused system submodules
- focused Home Manager submodules
- generated configuration where appropriate
- a cleaner path toward reuse across multiple hosts