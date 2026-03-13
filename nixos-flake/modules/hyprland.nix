{ ... }:

{
  imports = [
    ./desktop/base.nix
    ./desktop/display.nix
    ./desktop/audio.nix
    ./desktop/desktop-packages.nix
    ./desktop/hyprland-options.nix
  ];
}
