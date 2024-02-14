# This file contains configuration that is *not* unique between devices.
# Only global settings should be configured here; configuration that can
# be done with superuser permissions should go in home-manager/home.nix

# Help is available in the configuration.nix(5) man page and in the NixOS
# manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{ 
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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Register AppImage as a misc binary type
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';  
  };

  # Configure networking. I'm using network manager
  networking.networkmanager.enable = true;
 
  i18n.defaultLocale = "en_US.utf8";

  # My user account
  users.users.desttinghim = {
    isNormalUser = true;
    description = "Louis Pearson";
    # A bunch of extra groups, typically to allow
    # access to certain hardware features.
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "input" 
      "video" 
      "audio" 
      "dialout" 
      "vboxusers" 
      "plugdev" 
      "adbusers" 
      "docker" 
      "libvirtd" 
    ];
  };

  # System wide enviroment
  environment = {
    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
    # Default packages installed system-wide    
    systemPackages = with pkgs; [     
      helix
      git
      usbutils
      pciutils
      wget 
      pipewire
      acpi
      arduino 
      light # controls backlight brightness

      # For managing non-globally installed apps
      home-manager
    ];
  };

  # Gnome Virtual File System
  # Allows browsing network directories in nautilus
  services.gvfs = {
    enable = true;
    package = pkgs.lib.mkForce pkgs.gnome3.gvfs;
  };

  # Enable mDNS
  services.resolved.enable = true;
  networking.networkmanager.connectionConfig."connection.mdns" = 2; # 2 == yes

  hardware.bluetooth.enable = true;
  hardware.opengl.enable = true;

  # Optional but recommended for pipewire
  # Allows pipewire to guarantee real time execution
  security.rtkit.enable = true;

  # Services
  services.dbus.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = true;  # Printing
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
  ];
  services.avahi.enable = true;     # Also printing
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # udev manages kernel events and handles permissions for
  # non-root users
  # https://wiki.archlinux.org/title/udev  
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

  # Even though I use wayland, nixos does not have a clean seperation
  # between wayland and x which results with x configuration being 
  # necessary even for wayland users.
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Tailscale for home VPN
  services.tailscale.enable = true;

  # Desktop portals! Allows sandboxed applications to request access to 
  # resources. Not yet widely used, except for Flatpak I think.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-kde
      # The following are disabled because I'm pretty sure I *only* need one,
      # and I'd like it to match with my desktop
      # pkgs.xdg-desktop-portal-gtk 
      # pkgs.xdg-desktop-portal-wlr 
      # pkgs.xdg-desktop-portal 
    ];
  };

  fonts.packages = with pkgs; [
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

  # TODO: should I use nix-ld or just virtualize my dev environments?
  # No nix-ld makes my setups more reproducible, but disallows running
  # unpatched binaries. Using VMs makes the mutable state contained and
  # could allows taking snapshots.

  virtualisation.docker.enable = true;

  documentation = {
    enable = true;
    nixos.enable = true;
    man.enable = true;
    info.enable = true;
    doc.enable = true;
    dev.enable = true;
  };
}
