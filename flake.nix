{
  description = "Desttinghim's NixOS Configuration";

  inputs = {
    # Use nixpkgs 23.11
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";

    # Setup home manager as a module
    home-manager.url = "github:nix-community/home-manager/release-23.11";   
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # stylix.url = "github:danth/stylix/release-23.11";
    # stylix.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:pjones/plasma-manager"; # home-manager module for configuring KDE
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";

    zig.url = "github:mitchellh/zig-overlay"; 
    zls.url = "github:zigtools/zls";
    zls.inputs.zig-overlay.follows = "zig";
  };

  outputs = { nixpkgs, home-manager, ...}@inputs: {
    homeConfigurations = {
      "desttinghim@framework" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./home-manager/home.nix
        ];
      };  
      "desttinghim@desttop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
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
        modules = [ 
          # stylix.nixosModules.stylix
          ./nixos/framework.nix 
        ];
      }; 
      desttop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # pass flake inputs to our config
        # Our main nixos configuration file
        modules = [ 
          # stylix.nixosModules.stylix
          ./nixos/desktop.nix 
        ];
      };
    };
  };
}
