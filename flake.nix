{
  description = "Desttinghim's NixOS Configuration";

  inputs = {
    # Use nixpkgs 24.05
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";

    # Setup home manager as a module
    home-manager.url = "github:nix-community/home-manager/release-24.05";   
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zig.url = "github:mitchellh/zig-overlay"; 
    zls.url = "github:zigtools/zls";
    zls.inputs.zig-overlay.follows = "zig";

    atuin.url = "github:atuinsh/atuin";
  };

  outputs = { nixpkgs, home-manager, ...}@inputs: {
    homeConfigurations = {
      "desttinghim@framework" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./home.nix
        ];
      };  
      "desttinghim@desttop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./home.nix
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
