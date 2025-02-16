{
  description = "Desttinghim's NixOS Configuration";

  inputs = {
    # Use nixpkgs 24.11
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Setup home manager as a module
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zig.url = "github:mitchellh/zig-overlay"; 
    zls.url = "github:zigtools/zls";
    zls.inputs.zig-overlay.follows = "zig";
    
    # Add open-xc7 toolchain for working with basys3
    openxc7-toolchain.url = "github:openxc7/toolchain-nix";
  };

  outputs = { nixpkgs, home-manager, ...}@inputs: {
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
