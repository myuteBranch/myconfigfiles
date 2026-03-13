{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/hyprland.nix
    ../../modules/host-defaults.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  myConfig.desktop.hyprland = {
    enable = true;
    monitors = [
      {
        name = "eDP-1";
        resolution = "preferred";
        position = "auto";
        scale = 1;
      }
    ];
    networkInterface = "wlp0s20f3";
  };

  virtualisation.docker.enable = true;
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";

}
