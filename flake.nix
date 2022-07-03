{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        desttinghim = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix 
            home-manager.nixosModules.home-manager { 
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.desttinghim = {
                imports = [ ./home.nix ];
              };
            }
          ];
        };
      };
      hmConfig = {
        desttinghim = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
