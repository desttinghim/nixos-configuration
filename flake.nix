{
  description = "Desttinghim's NixOS Configuration";

  inputs = {
    # Use nixpkgs 23.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Setup home manager as a module
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig.url = "github:mitchellh/zig-overlay";
    zig.inputs.nixpkgs.follows = "nixpkgs";

    zls.url = "github:zigtools/zls";
    zls.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.zig-overlay.follows = "zig";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs, home-manager, ...}@inputs: {
    # Standalone home-manager configuration entrypoint
    # Available through `home-manager --flake .#your-username@your-hostname`
    homeConfigurations = {
      "desttinghim@framework" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./home-manager/home.nix
        ];
      };
    };

    # NixOS configuration entrypoint
    # Available through `nixos-rebuild --flake .#your-hostname`
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # pass flake inputs to our config
        # Our main nixos configuration file
        modules = [ ./nixos/framework.nix ];
      }; 
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # pass flake inputs to our config
        # Our main nixos configuration file
        modules = [ ./nixos/desktop.nix ];
      };
    };
  };
}
