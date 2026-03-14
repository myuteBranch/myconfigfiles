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

    environment.sessionVariables = {
      XCURSOR_SIZE = "24";
      HYPRCURSOR_SIZE = "24";
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_STYLE_OVERRIDE = "kvantum";
      SDL_VIDEODRIVER = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      OZONE_PLATFORM = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      GTK_THEME = "Flat-Remix-GTK-Grey-Darkest";

    };
  };
}
