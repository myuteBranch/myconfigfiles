{ pkgs, ... }:

{

  programs.home-manager.enable = true;

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
    just
    highlight
    vivaldi
    zoom-us
    claude-code
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
