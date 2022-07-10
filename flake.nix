{
  description = "A very basic flake";

  inputs = {
    # Use both 22.05 and unstable nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Setup home manager as a module
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs
    nc-emacs.url = "github:nix-community/emacs-overlay/master";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = { self, nixpkgs, home-manager, nix-doom-emacs, nixpkgs-unstable, nc-emacs }:
    let
      system = "x86_64-linux";

      # Replace emacs with emacsPgtk
      pkgs = import nixpkgs {
        inherit system;
        emacs = nc-emacs.emacsPgtk;
        config.allowUnfree = true;
      };

      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };

      overlay-mpris-scrobbler = final: prev: {
        mpris-scrobbler = prev.mpris-scrobbler.overrideAttrs (old: rec {
          version = "0.5.0";
          src = prev.fetchFromGitHub {
            owner = "mariusor";
            repo = "mpris-scrobbler";
            rev = "v${version}";
            sha256 = "sha256-HUEUkVL5d6FD698k8iSCJMNeSo8vGJCsExJW/E0EWpQ=";
          };
          hardeningDisable = [ "all" ];
          nativeBuildInputs = [
            prev.git
            prev.m4
            prev.meson
            prev.ninja
            prev.pkg-config
            prev.scdoc
          ];
          mesonFlags = [
            "-Dversion=${version}" # Makes mpris-scrobbler show correct version in --help
            # "-Dlibeventdebug=true"
            # "-Dlibcurldebug=true"
            # "-Ddebug=true"
          ];
        });
      };
    in {
      homeConfigurations = {
        desttinghim = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-mpris-scrobbler ]; })
            (import ./sway.nix {
              terminal = "alacritty";
              modifier = "Mod4";
            })
            ./home.nix
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
