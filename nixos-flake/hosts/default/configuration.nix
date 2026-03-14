{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/gaming.nix
    ../../modules/hyprland.nix
    ../../modules/host-defaults.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # btrfs
  services.btrfs.autoScrub.enable = true;

  myConfig.gaming.amd.enable = true;
  virtualisation.docker.enable = true;

  myConfig.desktop.hyprland = {
    enable = true;
    monitors = [
      {
        name = "DP-2";
        resolution = "3440x1440@165";
        position = "auto";
        scale = 1;
      }
    ];
    networkInterface = "wlp9s0";
  };

  # this is for citrix workspaces
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

}
