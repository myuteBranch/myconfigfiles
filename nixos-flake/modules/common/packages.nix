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

in
{
  environment.systemPackages = cliPackages ++ buildPackages;
}
