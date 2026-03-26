{ pkgs, ... }:

{

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    evince
    loupe
    libqalculate
    just
    freerdp
    vivaldi
    go
    rustup
    tree-sitter
    nodejs
    nil
    nixd
    alejandra
    gopls
    lua-language-server
    stylua
  ];

  programs.zed-editor = {
    enable = true;
  };
}
