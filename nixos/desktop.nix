# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{
  # Other NixOS modules to import
  imports =
    [ # Include the results of the hardware scan.
      ./desktop/hardware-configuration.nix
      ./configuration.nix
      ./cachix.nix
    ];

  networking.hostName = "desttop";
}
