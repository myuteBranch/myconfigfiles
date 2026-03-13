{ username, stateVersion, ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/fish.nix
    ./modules/shell-ui.nix
    ./modules/gui.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = stateVersion;
}
