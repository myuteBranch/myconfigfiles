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
    environment.systemPackages = with pkgs; [
      hyprlock
      hyprpicker
      hypridle
      waybar
      rofi
      dunst
      lxappearance
      alacritty
      grim
      slurp
      gpu-screen-recorder
      libva-utils
    ];

  };
}
