# This file stores the configuration for running virtualized development 
# environments.

{ inputs, lib, config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.virt-manager # GUI
    pkgs.spice
  ]; 
  virtualisation.libvirtd.enable = true;
}
