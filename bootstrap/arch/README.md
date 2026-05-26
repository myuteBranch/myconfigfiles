# arch-ansible

This directory has been simplified into a small set of rerunnable Arch setup scripts.

## Scripts

- `00-system-setup.sh`
  - sets hostname, timezone, locale, and X11 keyboard layout
  - ensures `wheel`, `networkmanager`, and `docker` groups exist
  - adds your current user to those groups
  - sets your login shell to `fish` if available
  - ensures wheel sudo access exists
- `01-install-base-and-yay.sh`
  - installs base packages
  - enables `sshd`
  - bootstraps `yay`
- `02-install-gaming.sh`
  - enables `multilib`
  - installs AMD-focused gaming packages
- `03-install-desktop.sh`
  - installs KDE Plasma desktop packages
  - installs `vivaldi` via AUR
  - writes a few desktop-related system config files
  - enables `NetworkManager`, `bluetooth`, and `sddm`
- `04-install-coding.sh`
  - installs coding/programming packages
  - installs `jujutsu` via AUR
- `05-link-configs.sh`
  - symlinks files from `../../dotfiles` into your home directory
  - backs up existing conflicting files
- `06-run-all.sh`
  - orchestrates the above scripts in order
  - safe to rerun after package or dotfile updates

## Usage

Run from this directory as your normal user:

```sh
chmod +x ./*.sh
./06-run-all.sh
```

Skip gaming packages with:

```sh
INSTALL_GAMING=0 ./06-run-all.sh
```

Override system setup values if needed:

```sh
HOSTNAME_VALUE=my-host TIMEZONE=America/Chicago LOCALE=en_US.UTF-8 ./00-system-setup.sh
```

Optional keyboard overrides:

```sh
KEYBOARD_LAYOUT=us KEYBOARD_VARIANT=dvorak KEYBOARD_OPTIONS=grp:alt_shift_toggle ./00-system-setup.sh
```

## Notes

- These scripts assume an Arch Linux system.
- `02-install-gaming.sh` assumes an AMD gaming stack.
- `05-link-configs.sh` expects this repository layout so it can find `../../dotfiles` relative to the script directory.
- Existing files are backed up before being replaced with symlinks.
- If `00-system-setup.sh` changes your group membership, log out and back in before expecting those groups to apply everywhere.
