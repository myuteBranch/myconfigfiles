# arch-ansible (mirrors `nixos-flake`)

This playbook mirrors the setup in `nixos-flake` for Arch Linux hosts, including:

- Host profiles matching flake hosts:
  - `default` (desktop + gaming)
  - `server` (desktop + citrix-enabled user profile)
- Base system, services, shell, locale/timezone, keyboard layout
- KDE Plasma desktop stack + SDDM + PipeWire + KDE portals
- Docker + SSH + NetworkManager + Bluetooth
- User packages and config files (fish, tmux, starship, KDE config, mime)

## Usage

```sh
ansible-galaxy collection install -r requirements.yml
ansible-playbook playbook.yml
```

### Run only one profile

```sh
ansible-playbook playbook.yml -l default
ansible-playbook playbook.yml -l server
```

## Notes

- This is a distro translation from NixOS to Arch; package names are mapped where possible.
- AUR packages are installed via `yay` + `kewlfft.aur`.
- `citrix_workspace` is included only when `citrix_enabled: true` (server profile).
- User config files are rendered into the repo and symlinked into `$HOME`:
  - source: `$HOME/src/myconfigfiles/ansible/arch-ansible/linked-config/<host>/...`
  - target: `~/.config/...`, `~/.local/...`, `~/.tmux.conf`
  - edits made through the symlinked paths are directly reflected in the repo.

