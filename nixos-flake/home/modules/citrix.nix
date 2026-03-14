{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.citrix;
in
{
  options.modules.citrix.enable = lib.mkEnableOption "Citrix Workspace";

  config = lib.mkIf cfg.enable {
    # Before doing this download https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html
    # version 25.08.10.111
    # and run nix-prefetch-url file://$PWD/linuxx64-25.08.10.111.tar.gz

    home.packages = with pkgs; [
      citrix_workspace
    ];
  };

}
