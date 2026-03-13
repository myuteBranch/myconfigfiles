{
  description = "Idiomatic NixOS flake migrated from the ansible workstation configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
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
            inherit inputs self username hostname stateVersion;
          };

          modules =
            [
              ./hosts/${configname}/configuration.nix
              home-manager.nixosModules.home-manager
              {
                networking.hostName = hostname;
                system.stateVersion = stateVersion;

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs self username hostname stateVersion;
                  };
                  users.${username} = import ./home/${username}.nix;
                };
              }
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
          hostname = "myute-nixos";
          configname = "myute-nixos";
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
