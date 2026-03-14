{ pkgs, ... }:

{
  environment.shells = [ pkgs.fish ];
  users.defaultUserShell = pkgs.fish;

  programs = {
    fish.enable = true;
    git.enable = true;
    neovim.enable = true;
  };

}
