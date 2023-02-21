# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{
  # Other NixOS modules to import
  imports =
    [ # Include the results of the hardware scan.
      ./framework/hardware-configuration.nix
      ./cachix.nix
    ];

  nixpkgs = {
    # Add overlays here
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new `nix` command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    # Garbage collect
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixFlakes; # Enable nixFlakes on system
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  # Configure networking. I'm using network manager
  networking = {
    hostName = "framework";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.desttinghim = {
    isNormalUser = true;
    description = "Louis Pearson";
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" "dialout" "vboxusers" "plugdev" "adbusers" "docker" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      TERMINAL = "foot";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [     # Default packages installed system-wide
      git
      usbutils
      pciutils
      wget

      gnome3.adwaita-icon-theme # Default gnome cursors
      pipewire
      acpi
      arduino

      home-manager
      lxqt.lxqt-policykit
    ];
  };

  # Gnome Virtual File System
  # Allows browsing network directories in nautilus
  services.gvfs = {
    enable = true;
    package = pkgs.lib.mkForce pkgs.gnome3.gvfs;
  };

  hardware.bluetooth.enable = true;

  # Optional but recommended for pipewire
  security.rtkit.enable = true;

  # Programs
  programs.light.enable = true;

  # Gnome configuration manager
  programs.dconf.enable = true;

  # Services
  services.blueman.enable = true;
  services.dbus.enable = true;
  services.flatpak.enable = true;

  services.udev = {
    packages = [ pkgs.android-udev-rules ];
    extraRules = let set-mem = pkgs.writeShellScript "set-mem" ''
      echo 200 >/sys/module/usbcore/parameters/usbfs_memory_mb
      '';
      in
      ''
      ACTION=="add", ATTR{idVendor}=="03c3", RUN+="${set-mem}"
      # All ASI Cameras and filter wheels
      SUBSYSTEMS=="usb", ATTR{idVendor}=="03c3", MODE="0666", GROUP="video"
      '';
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=10m
    '';
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    media-session.config.bluez-monitor.rules = [
      {
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
      }
    ];
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 97;
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal ];
  };

  fonts.fonts = with pkgs; [
    source-code-pro
    font-awesome
    font-awesome_5
    font-awesome_4
    corefonts
    roboto
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
