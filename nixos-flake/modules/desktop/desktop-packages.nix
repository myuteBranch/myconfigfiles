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
      wl-clipboard
      dunst
      lxappearance
      alacritty
      swaybg
      swayosd
      nautilus
      grim
      slurp
      gpu-screen-recorder
      libva-utils
    ];

  };
}
