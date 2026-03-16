{ pkgs, ... }:

{

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "zeditor";
    TERMINAL = "alacritty";
  };

  home.packages = with pkgs; [
    pavucontrol
    nautilus
    evince
    loupe
    blueman
    swaybg
    swayosd
    wl-clipboard
    libnotify
    libqalculate
    ripgrep
    fzf
    just
    highlight
    vivaldi
    zoom-us
  ];

  programs.zed-editor = {
    enable = true;
    # Add the necessary LSPs and formatters here
    extraPackages = with pkgs; [
      # For Nix language support
      nil
      nixd
      alejandra
      # For Rust language support
      rust-analyzer
      # golang
      gopls
    ];
  };
}
