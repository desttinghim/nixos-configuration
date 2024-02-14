# Desktop specific configuration
# - System specific variables
# - Globally installed packages
# - System services
# - Networking configuration

{ inputs, lib, config, pkgs, ... }:

{
  # Other NixOS modules to import
  imports =
    [ # Include the results of the hardware scan.
      ./desktop/hardware-configuration.nix
      ./configuration.nix
      ./cachix.nix
      ./dev-vms.nix
    ];

  # Should be left at the version that was used when first installing
  # the system, allows stateful configuration to upgrade properly.
  system.stateVersion = "23.11"; 

  networking.hostName = "desttop";
  time.timeZone = "America/Denver"; 

  hardware.vulkan.enable = true;

  # TODO: research setting up a self-hosted remote development environment and 
  # implement it here.

  # TODO: configure sleep/power management
}
