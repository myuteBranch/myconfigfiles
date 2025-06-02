{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    rustc # The Rust compiler
    cargo # The Rust package manager
    rustfmt # Rust code formatter
    clippy # Rust linter
    rust-analyzer # LSP server for Rust (highly recommended for IDEs)
  ];

  # You might want to define a specific Rust toolchain for consistency
  # For example, to use a specific nightly or stable version:
  # programs.rust = {
  #   enable = true;
  #   defaultToolchain = "stable"; # or "nightly"
  #   # package = pkgs.rust-bin.fromRustupToolchain {
  #   #   toolchain = "nightly";
  #   #   sha256 = "sha256-hash-of-nightly-toolchain"; # Get this from `nix-prefetch-url`
  #   # };
  # };

  # If you want to use rustup (less "Nix-idiomatic" but sometimes useful)
  # environment.systemPackages = with pkgs; [
  #   rustup
  # ];
  # users.users.youruser.extraGroups = [ "rust-toolchain" ]; # If rustup manages permissions
}