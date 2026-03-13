{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.gaming.amd;
in
{
  options.myConfig.gaming.amd = {
    enable = lib.mkEnableOption "AMD gaming support";

    enableSteam = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Steam and related gaming support.";
    };

    enableGamescope = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Gamescope session support.";
    };

    enableMangohud = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install MangoHud for performance overlays.";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    boot.initrd.kernelModules = [
      "amdgpu"
    ];

    services.xserver.videoDrivers = [
      "amdgpu"
    ];

    hardware.enableRedistributableFirmware = true;

    programs.steam = lib.mkIf cfg.enableSteam {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = cfg.enableGamescope;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = cfg.enableGamescope;

    environment.systemPackages =
      with pkgs;
      [
        glxinfo
        vulkan-tools
        vulkan-loader
        radeontop
        goverlay
        protontricks
        winetricks
      ]
      ++ lib.optionals cfg.enableMangohud [
        mangohud
      ];

    environment.sessionVariables = {
      AMD_VULKAN_ICD = "RADV";
    };
  };
}
