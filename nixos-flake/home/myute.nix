{ username, stateVersion, ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/fish.nix
    ./modules/shell-ui.nix
    ./modules/gui.nix
    ./modules/mime.nix
    ./modules/citrix.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = stateVersion;

  # switch this to false till you have the citrix workspace app downloaded and prefetched for citrix.nix
  modules.citrix.enable = true;
}
