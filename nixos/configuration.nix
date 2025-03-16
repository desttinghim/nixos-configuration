# This file contains configuration that is *not* unique between devices.
# Only global settings should be configured here; configuration that can
# be done with superuser permissions should go in home-manager/home.nix

# Help is available in the configuration.nix(5) man page and in the NixOS
# manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{ 
  nixpkgs = {
    # Add overlays here
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
    package = pkgs.nixVersions.stable; # Enable nixFlakes on system
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Register AppImage as a misc binary type
  programs.appimage = {
    enable = true;
    binfmt = true;
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
      "podman"
      "libvirtd"
      "cdrom"
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
      # Important utilities, I guess
      fwupd
      helix
      git
      usbutils
      pciutils
      wget
      pipewire
      acpi
      light # controls backlight brightness
      ripgrep
      tldr
      file # print information about files
      fd
      ly
      wofi
      mako
      waybar
      syncthing

      # terminal emulators
      alacritty
      foot

      # cli tools
      atuin
      btop
      gh # github cli helper thing
      jujutsu
      glow
      wl-clipboard
      xxd
      dumpasn1
      pgpdump

      # compilers/runtimes
      cargo
      clang
      nodejs
      python3
      nasm
      platformio
      arduino-cli
      iverilog
      verilator
      # inputs.openxc7-toolchain.packages.${system}

      # programming utilities
      clang-tools
      nodePackages.prettier
      nasmfmt

      # language servers
      irony-server
      glslang
      asm-lsp

      # wine/windows
      wineWowPackages.waylandFull
      winetricks
      icoutils

      # media playback/viewing
      # imv
      pavucontrol
      # vlc
      # obs-studio
      # oculante
      strawberry
      zathura

      # dependencies
      libnotify
      libappindicator-gtk3
      xdg-utils
      bluez

      # graphics editing
      inkscape
      gimp
      krita

      # audio/music editing
      vital
      picard
      milkytracker

      # file management
      zip
      unzip
      unrar
      unar
      soundconverter
      # paperwork
      libcdio
      tarsnap

      # file sharing
      # qbittorrent
      # samba
      # nextcloud-client

      # web
      firefox-bin
      mullvad-vpn

      # chat/social
      kdePackages.konversation
      kdePackages.tokodon
      zoom-us
      inputs.nixpkgs-unstable.legacyPackages.${system}.signal-desktop

      # misc. utlities
      anki
      bitwarden
      libreoffice-qt
      typst
      nuspell
      hunspellDicts.en_US
      qalculate-qt
      appimage-run
      qrencode
      labplot
      lutris
      sc-controller

      kdePackages.okular
      # kdePackages.elisa
      # kdePackages.kasts
      kdePackages.plasma-browser-integration
      kdePackages.kio-extras
      kdePackages.audiocd-kio
      kdePackages.discover
      kdePackages.kdeconnect-kde
      kdePackages.breeze-gtk
      # Allows gtk apps (like firefox) to integrate with KDE theming;
      # meaning it will actually follow light/dark theming
      kdePackages.kde-gtk-config
      adwaita-icon-theme
    ];
  };

  programs.partition-manager.enable = true;
  programs.steam.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Enable mullvad
  services.mullvad-vpn.enable = true;

  # Enable mDNS
  # services.resolved.enable = true;
  # networking.networkmanager.connectionConfig."connection.mdns" = 2; # 2 == yes

  # Enable bluetooth
  hardware.bluetooth.enable = true;

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
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;
  # services.mpris-proxy.enable = true; # strawberry has mpris support built in, probably not needed?

  # udev manages kernel events and handles permissions for
  # non-root users
  # https://wiki.archlinux.org/title/udev  
  services.udev = {
    packages = [ pkgs.android-udev-rules pkgs.platformio-core.udev ];
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

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  fonts.packages = with pkgs; [
    source-code-pro
    font-awesome
    font-awesome_5
    font-awesome_4
    corefonts
    roboto
    atkinson-hyperlegible
    hack-font
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
    };
  };

  documentation = {
    enable = true;
    nixos.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    info.enable = true;
    doc.enable = true;
    dev.enable = true;
  };
}
