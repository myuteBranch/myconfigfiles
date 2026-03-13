{ lib, ... }:

let
  monitorType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Hyprland monitor output name.";
        example = "eDP-1";
      };

      resolution = lib.mkOption {
        type = lib.types.str;
        default = "preferred";
        description = "Monitor resolution passed to Hyprland.";
        example = "1920x1080@60";
      };

      position = lib.mkOption {
        type = lib.types.str;
        default = "auto";
        description = "Monitor position passed to Hyprland.";
        example = "0x0";
      };

      scale = lib.mkOption {
        type = lib.types.oneOf [ lib.types.int lib.types.float lib.types.str ];
        default = 1;
        description = "Monitor scale passed to Hyprland.";
        example = 1.25;
      };
    };
  };
in
{
  options.myConfig.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment";

    monitors = lib.mkOption {
      type = lib.types.listOf monitorType;
      default = [
        {
          name = "DP-1";
          resolution = "preferred";
          position = "auto";
          scale = 1;
        }
        {
          name = "HDMI-A-2";
          resolution = "preferred";
          position = "auto";
          scale = 1;
        }
      ];
      description = "Monitor definitions used by Hyprland and related desktop defaults.";
      example = [
        {
          name = "eDP-1";
          resolution = "1920x1200@60";
          position = "0x0";
          scale = 1.25;
        }
        {
          name = "HDMI-A-1";
          resolution = "2560x1440@144";
          position = "1920x0";
          scale = 1;
        }
      ];
    };



    networkInterface = lib.mkOption {
      type = lib.types.str;
      default = "eno1";
      description = "Network interface shown by desktop status components.";
    };
  };
}
