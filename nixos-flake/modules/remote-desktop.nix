{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.remoteDesktop.xrdp;
in
{
  options.myConfig.remoteDesktop.xrdp = {
    enable = lib.mkEnableOption "XRDP remote desktop server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the firewall for XRDP.";
    };

    defaultWindowManager = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/Hyprland";
      description = "Window manager command to start for XRDP sessions.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xrdp = {
      enable = true;
      openFirewall = cfg.openFirewall;
      defaultWindowManager =
        if cfg.defaultWindowManager == null
        then "${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/Hyprland"
        else cfg.defaultWindowManager;
    };

    services.xserver.enable = true;
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      dbus
      hyprland
      xorg.xorgxinit
    ];
  };
}
