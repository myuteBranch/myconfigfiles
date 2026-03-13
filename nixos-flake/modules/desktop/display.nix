{ config, lib, ... }:

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

    services.displayManager.defaultSession = "hyprland";
  };
}
