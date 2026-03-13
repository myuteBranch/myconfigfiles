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
    jq
    jujutsu
    less
    neovim
    openssh
    starship
    tmux
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

  appPackages = with pkgs; [
    vivaldi
  ];
in
{
  environment.systemPackages =
    cliPackages
    ++ buildPackages
    ++ languagePackages
    ++ appPackages;
}
