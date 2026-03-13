{ pkgs, ... }:

let
  cliPackages = with pkgs; [
    bat
    btop
    curl
    difftastic
    eza
    fastfetch
    fish
    fzf
    git
    jujutsu
    less
    neovim
    openssh
    starship
    vim
    wget
  ];

  buildPackages = with pkgs; [
    binutils
    file
    gcc
    gnumake
    gnused
    gnutar
    gzip
    patch
    pkg-config
    unzip
    which
    xz
  ];

  languagePackages = with pkgs; [
    go
    rustup
  ];
in
{
  environment.systemPackages =
    cliPackages
    ++ buildPackages
    ++ languagePackages;
}
