{ config, pkgs, ... }:

{
  imports = [
    ./rust.nix
    ./golang.nix
    # Add other development tool modules here, e.g., ./nodejs.nix, ./python.nix
  ];

  # You can add common development packages here if desired
  # environment.systemPackages = with pkgs; [
  #   gdb
  #   strace
  #   valgrind
  # ];
}