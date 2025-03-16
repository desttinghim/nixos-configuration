{
  description = "Desttinghim's NixOS Configuration";

  inputs = {
    # Use nixpkgs 24.11
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Setup home manager as a module
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Add nix-xilinx
    nix-xilinx.url = "gitlab:doronbehar/nix-xilinx";
    
    # Add open-xc7 toolchain for working with basys3
    openxc7-toolchain.url = "github:openxc7/toolchain-nix";
  };

  outputs = { nixpkgs, home-manager, ...}@inputs: 
  let 
    flake-overlays = [
      inputs.nix-xilinx.overlay
    ];
  in {
    # NixOS configuration entrypoint
    # Available through `nixos-rebuild --flake .#your-hostname`
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # pass flake inputs to our config
        # Our main nixos configuration file
        modules = [ 
          (import ./nixos/framework.nix flake-overlays)
        ];
      }; 
      desttop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # pass flake inputs to our config
        # Our main nixos configuration file
        modules = [ 
          ./nixos/desktop.nix
        ];
      };
    };
  };
}
