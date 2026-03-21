{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = lib.mkDefault true;
      wayland.enable = true;
    };

    security.pam.services.sddm.enableGnomeKeyring = true;
    security.pam.services.sddm-autologin.enableGnomeKeyring = true;

    services.displayManager.defaultSession = "hyprland";

    programs = {
      dconf.enable = true;
      fish.enable = true;
      nm-applet.enable = true;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.meslo-lg
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-mono
      noto-fonts
      noto-fonts-color-emoji
    ];

  };
}
