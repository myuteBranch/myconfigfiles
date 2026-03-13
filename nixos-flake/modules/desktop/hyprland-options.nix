{ lib, ... }:

{
  options.myConfig.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment";

    monitorPrimary = lib.mkOption {
      type = lib.types.str;
      default = "DP-1";
      description = "Primary monitor name used by desktop defaults.";
    };

    monitorSecondary = lib.mkOption {
      type = lib.types.str;
      default = "HDMI-A-2";
      description = "Secondary monitor name used by desktop defaults.";
    };

    networkInterface = lib.mkOption {
      type = lib.types.str;
      default = "eno1";
      description = "Network interface shown by desktop status components.";
    };
  };
}
