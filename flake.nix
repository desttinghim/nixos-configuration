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

    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NOTE: This will require your git SSH access to the repo.
    #
    # WARNING:
    # Do NOT pin the `nixpkgs` input, as that will
    # declare the cache useless. If you do, you will have
    # to compile LLVM, Zig and Ghostty itself on your machine,
    # which will take a very very long time.
    #
    # Additionally, if you use NixOS, be sure to **NOT**
    # run `nixos-rebuild` as root! Root has a different Git config
    # that will ignore any SSH keys configured for the current user,
    # denying access to the repository.
    #
    # Instead, either run `nix flake update` or `nixos-rebuild build`
    # as the current user, and then run `sudo nixos-rebuild switch`.
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";

      # NOTE: The below 2 lines are only required on nixos-unstable,
      # if you're on stable, they may break your build
      # inputs.nixpkgs-stable.follows = "nixpkgs";
      # inputs.nixpkgs-unstable.follows = "nixpkgs";
    };  
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
