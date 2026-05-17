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
    networking.networkmanager.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    security.polkit.enable = true;

    services = {
      dbus.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      blueman.enable = true;
      libinput.enable = true;
      gnome.gnome-keyring.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };
    };

    programs.nm-applet.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [
          "hyprland"
          "gtk"
        ];
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };
    };
  };
}
