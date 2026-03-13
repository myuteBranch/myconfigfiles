{ config, lib, ... }:

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
  };
}
