{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/remote-desktop.nix
    ../../modules/hyprland.nix
    ../../modules/host-defaults.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Set your time zone.
  time.timeZone = "Americas/Chicago";

  myConfig.desktop.hyprland.enable = true;

  myConfig.remoteDesktop.xrdp.enable = true;

  virtualisation.docker.enable = true;
}
