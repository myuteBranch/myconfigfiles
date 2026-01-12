{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "myute-nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Americas/Chicago";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # List services that you want to enable:
  # fonts
 fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
 ];
nixpkgs.config.allowUnfree = true;
  # --- Core graphics stack for AMD 7700 XT ---
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Wayland + Hyprland
  programs.hyprland.enable = true;

  # AMD GPU drivers + Vulkan
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "dvorak";

  # Optional: performance & gaming tools
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
        git
        hyprland
        quickshell
        noctalia-shell
        neovim
        bluez
        bluez-tools
        vivaldi
        alacritty
        fzf
        ripgrep
        git
        cargo
        go
        wl-clipboard
        zoom-us
  ];

  # Example: user packages (include Noctalia Shell)
  users.users.myuteBranch = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "input" ];
    packages = with pkgs; [
    ];
  };

  # --- Steam + gaming dependencies ---
  hardware.steam-hardware.enable = true;


  # recommended for Wayland + Hyprland
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # Pulseaudio / PipeWire for audio
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
