{ ... }:

{
  imports = [
    ../../modules/common.nix
    ../../modules/gaming.nix
    ../../modules/hyprland.nix
    ../../modules/host-defaults.nix
  ];

  myConfig.gaming.amd.enable = true;
  virtualisation.docker.enable = true;

  myConfig.desktop.hyprland.enable = true;
}
