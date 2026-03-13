{ ... }:

{
  imports = [
    ../../modules/common.nix
    ../../modules/gaming.nix
    ../../modules/hyprland.nix
    ../../modules/host-defaults.nix
  ];

  myConfig.gaming.amd.enable = true;
  virtualisation.docker.enable = true;

  myConfig.desktop.hyprland = {
    enable = true;
    monitors = [
      {
        name = "DP-2";
        resolution = "3440x1440@165";
        position = "auto";
        scale = 1;
      }
    ];
  };
}
