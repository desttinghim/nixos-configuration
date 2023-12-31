# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.desttinghim = {
    isNormalUser = true;
    description = "Louis Pearson";
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" "dialout" "vboxusers" "plugdev" "adbusers" "docker" "libvirtd" ];
  };

  users.extraGroups.vboxusers.members = [ "desttinghim" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      TERMINAL = "foot";
      EDITOR = "helix";
      VISUAL = "helix";
    };
    systemPackages = with pkgs; [     # Default packages installed system-wide
      helix
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

      virt-manager
      spice
    ];
  };

  # Gnome Virtual File System
  # Allows browsing network directories in nautilus
  services.gvfs = {
    enable = true;
    package = pkgs.lib.mkForce pkgs.gnome3.gvfs;
  };

  services.fprintd = {
    enable = true;
  };

  # Enable mDNS
  services.resolved.enable = true;
  networking.networkmanager.connectionConfig."connection.mdns" = 2; # 2 == yes

  # networking.firewall.enable = true;
  # networking.firewall.allowPing = true;
  # services.samba.openFirewall = true;

  hardware.bluetooth.enable = true;

  # Optional but recommended for pipewire
  security.rtkit.enable = true;

  # Programs
  programs.light.enable = true;

  # Gnome configuration manager
  programs.dconf.enable = true;

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

  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
    };
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
    wireplumber.enable = true;
  };

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

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal ];
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
  system.stateVersion = "23.11"; # Did you read the comment?

  # Allow non-nix binaries to run without patching
  programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   stdenv.cc.cc
  #   fuse3
  #   alsa-lib
  #   at-spi2-atk
  #   at-spi2-core
  #   atk
  #   cairo
  #   cups
  #   curl
  #   dbus
  #   expat
  #   fontconfig
  #   freetype
  #   gdk-pixbuf
  #   glib
  #   gtk3
  #   libGL
  #   libappindicator-gtk3
  #   libdrm
  #   libnotify
  #   libpulseaudio
  #   libuuid
  #   xorg.libxcb
  #   libxkbcommon
  #   mesa
  #   nspr
  #   nss
  #   pango
  #   pipewire
  #   systemd
  #   icu
  #   openssl
  #   xorg.libX11
  #   xorg.libXScrnSaver
  #   xorg.libXcomposite
  #   xorg.libXcursor
  #   xorg.libXdamage
  #   xorg.libXext
  #   xorg.libXfixes
  #   xorg.libXi
  #   xorg.libXrandr
  #   xorg.libXrender
  #   xorg.libXtst
  #   xorg.libxkbfile
  #   xorg.libxshmfence
  #   zlib
  # ];

  # virtualisation.virtualbox.host = {
  #   enable = true;
  #   enableExtensionPack = true;
  # };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
}
