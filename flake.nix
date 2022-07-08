{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nc-emacs.url = "github:nix-community/emacs-overlay/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = { self, nixpkgs, home-manager, nix-doom-emacs, nixpkgs-unstable, nc-emacs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        emacs = nc-emacs.emacsPgtk;
        config.allowUnfree = true;
      };
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        desttop = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            home-manager.nixosModules.home-manager { 
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.desttinghim = {
                imports = [ ./home.nix ./sway.nix ];
              };
            }
          ];
        };
        destbook = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.desttinghim = {
                imports = [ ./home.nix ./sway.nix ];
                # programs.doom-emacs = {
                #   enable = true;
                #   doomPrivateDir = ./doom.d;
                # };
              };
            }
          ];
        };
      };
    };
}
