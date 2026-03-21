{
  description = "Idiomatic NixOS flake for my system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;

      mkHost =
        {
          hostname,
          configname,
          system ? "x86_64-linux",
          username ? "myute",
          stateVersion ? "25.11",
          modules ? [ ],
        }:
        lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit
              inputs
              username
              hostname
              stateVersion
              ;
          };

          modules = [
            ./hosts/${configname}/configuration.nix
            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                networking.hostName = hostname;
                system.stateVersion = stateVersion;

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "bak";
                  extraSpecialArgs = {
                    inherit
                      inputs
                      username
                      hostname
                      stateVersion
                      ;
                    inherit (config.myConfig.desktop.hyprland) monitors networkInterface;
                  };
                  users.${username} = import ./home/${username}.nix;
                };
              }
            )
          ]
          ++ modules;
        };

      hosts = {
        default = {
          hostname = "default";
          configname = "default";
          username = "myute";
          system = "x86_64-linux";
          stateVersion = "25.11";
        };

        server = {
          hostname = "myute-nixos-svr";
          configname = "server";
          username = "myuteBranch";
          system = "x86_64-linux";
          stateVersion = "25.11";
        };
      };
    in
    {
      nixosConfigurations = lib.mapAttrs (_: mkHost) hosts;
    };
}
