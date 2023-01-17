{
  description = "Desttinghim's NixOS Configuration";

  inputs = {
    # Use both 22.11 and unstable nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Setup home manager as a module
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs
    nc-emacs.url = "github:nix-community/emacs-overlay/master";

    zig.url = "github:mitchellh/zig-overlay";
    zig.inputs.nixpkgs.follows = "nixpkgs";

    zls.url = "github:zigtools/zls";
    zls.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.zig-overlay.follows = "zig";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, nc-emacs, zig, zls }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        zig-overlay = zig.packages.${system}.master;
        zls-overlay = zls.packages.${system}.zls;
      };

    in {
      homeConfigurations = {
        desttinghim = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable (import nc-emacs) ]; })
          ];
        };
      };
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ];
        };
      };
    };
}
