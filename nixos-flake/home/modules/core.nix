{ pkgs, ... }:

{

  programs.home-manager.enable = true;

  xdg.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
  };

  home.packages = with pkgs; [
    pavucontrol
    nautilus
    blueman
    swaybg
    swayosd
    wl-clipboard
    libnotify
    ripgrep
    fzf
    highlight
  ];
}
