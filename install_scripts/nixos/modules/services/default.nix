# modules/services/default.nix
{ config, pkgs, lib, ... }:

{
  # Example: Enable PostgreSQL
  # services.postgresql = {
  #   enable = true;
  #   package = pkgs.postgresql_15; # Specify the desired version
  #   extraConfig = "listen_addresses = '*'";
  #   initialScript = pkgs.writeText "init-db" ''
  #     CREATE USER devuser WITH PASSWORD 'devpassword';
  #     CREATE DATABASE devdb OWNER devuser;
  #   '';
  # };

  # Example: Enable Nginx
  # services.nginx.enable = true;
  # services.nginx.virtualHosts."dev.server" = {
  #   root = "/var/www/dev-server";
  #   extraConfig = ''
  #     index index.html index.htm;
  #   '';
  # };

  # Example: Enable Docker
  # virtualisation.docker.enable = true;
  # users.users.youruser.extraGroups = [ "docker" ];
}