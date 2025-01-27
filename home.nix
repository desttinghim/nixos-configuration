{ inputs, lib, config, pkgs, ...}: 
let
  username = "desttinghim";
  homeDirectory = "/home/${username}";
in
{
  # Import home-manager modules here
  imports = [ ];

  nixpkgs = {
    # Add overlays here
    overlays = [
      inputs.zig.overlays.default
    ];
    # Configure nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = username;
    homeDirectory = homeDirectory;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  # Add ~/.local/bin to my PATH
  home.sessionPath = [ "${homeDirectory}/.local/bin" ];

  home.sessionVariables = {
    GDK_BACKEND="wayland";
  };

  home.file.alacritty = {
    enable = true;
    source = ./alacritty.yml;
    target = ".config/alacritty/alacritty.yml";
  };

  # Required to allow Home Manager to manage shell configuration
  programs.bash = {
    enable = true;
    sessionVariables = {
      NIXOS_OZONE_WL = 1;
      PAGER = null;
    };
  };

  # Apps I don't care to configure
  home.packages = with pkgs; [ 

    # Terminal
    alacritty
    foot
    tldr
    wl-clipboard
    inputs.ghostty.packages.${system}.default
    glow
    helix
    jujutsu

    # Programming
    ripgrep
    editorconfig-core-c
    irony-server
    glslang
    fd 
    clang
    clang-tools
    cargo
    rustfmt
    inputs.zig.packages.${system}."0.13.0"
    inputs.zls.packages.${system}.default
    nodePackages.prettier
    nodejs
    python3
    xxd
    dumpasn1
    pgpdump
    asm-lsp
    nasm
    nasmfmt
    platformio
    arduino-cli

    # Windows UI development
    wineWowPackages.waylandFull
    winetricks
    icoutils # Needed to show exe icons in dolphin

    # Media
    imv
    pavucontrol
    vlc
    obs-studio
    oculante

    # Dependencies
    libnotify
    libappindicator-gtk3
    light
    mpris-scrobbler
    xdg-utils
    bluez

    # Graphics
    inkscape
    gimp
    krita
    kolourpaint

    # Audio
    ardour
    sonic-visualiser
    soundfont-fluid
    soundfont-generaluser
    geonkick
    drumgizmo
    cardinal
    dexed
    odin2
    vital
    strawberry
    picard
    milkytracker

    # Misc.
    bitwarden
    zathura
    libreoffice-qt
    zeal
    qalculate-qt
    appimage-run
    qrencode
    labplot

    # File Management
    zip
    unzip
    unrar
    unar
    soundconverter
    paperwork
    qbittorrent
    samba

    nextcloud-client
    libcdio

    kdePackages.okular
    kdePackages.elisa
    kdePackages.kasts
    kdePackages.plasma-browser-integration
    kdePackages.kio-extras
    kdePackages.audiocd-kio
    kdePackages.discover
    kdePackages.kdeconnect-kde
    kdePackages.tokodon
    kdePackages.konversation

    # Allows gtk apps (like firefox) to integrate with KDE theming;
    # meaning it will actually follow light/dark theming
    kdePackages.kde-gtk-config
    kdePackages.breeze-gtk

    firefox-bin

    sqlitebrowser
    signal-desktop
    tarsnap
    typst
    mullvad-vpn
    zoom-us

    anki # Flash card program

    adwaita-icon-theme

    # Spell checking
    nuspell
    hunspellDicts.en_US

    lutris
  ];

  services.mpris-proxy.enable = true;
  services.syncthing.enable = true;

  # Programs, sorted alphabetically
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;    
    flags = [
      "--disable-up-arrow"
    ];
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "https";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "opensource@louispearson.work";
    userName = "Louis Pearson";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.qutebrowser = {
    enable = true;
    settings = {
      colors.webpage.darkmode.enabled = true;
      colors.webpage.darkmode.policy.page = "always";
      colors.webpage.preferred_color_scheme = "dark";
    };
    extraConfig = builtins.readFile ./qutebrowser/extraConfig.py;
  };

  # direnv - automatically load project environment from shell.nix
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      graph_symbol = "braille";
    };
  };
}
