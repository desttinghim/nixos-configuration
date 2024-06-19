# Framework 13 laptop configuration
# - System specific variables
# - Globally installed packages
# - System services
# - Networking configuration

{ inputs, lib, config, pkgs, ... }:

{
  # Other NixOS modules to import
  imports =
    [ # Include the results of the hardware scan.
      ./framework/hardware-configuration.nix
      ./configuration.nix
      ./cachix.nix
      ./dev-vms.nix
    ];

  # Should be left at the version that was used when first installing
  # the system, allows stateful configuration to upgrade properly.
  system.stateVersion = "24.05"; 

  networking.hostName = "framework";
  time.timeZone = "America/Denver"; 

  boot.loader.efi.efiSysMountPoint = "/boot/efi"; 

  # Suspend and hibernation.
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=30m
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  # TODO: why is this commented out and should add it back in?
  # Seems related to power management. Can I configure this to
  # extend battery life?
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_BOOST_ON_BAT = 0;
  #     CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
  #     START_CHARGE_THRESH_BAT0 = 90;
  #     STOP_CHARGE_THRESH_BAT0 = 97;
  #     RUNTIME_PM_ON_BAT = "auto";
  #   };
  # };  
}
