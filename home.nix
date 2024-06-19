{ inputs, lib, config, pkgs, ...}: 
let
  username = "desttinghim";
  homeDirectory = "/home/${username}";
in
{
  # Import home-manager modules here
  imports = [
    # inputs.nix-colors.homeManagerModule
  ];

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

  # colorScheme = inputs.nix-colors.colorSchemes.dracula;

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
    };
  };

  # Apps I don't care to configure
  home.packages = with pkgs; [ 
    plasma5Packages.kio-extras

    # Terminal
    alacritty
    btop
    tldr
    bashmount
    helix
    wl-clipboard

    # Programming
    ripgrep
    editorconfig-core-c
    irony-server
    glslang
    fd 
    clang-tools
    cargo
    rustfmt
    clang
    inputs.zig.packages.${system}."0.12.0"
    inputs.zls.packages.${system}.default
    nodePackages.prettier
    nodejs
    python3
    exercism

    # Windows UI development
    wineWowPackages.waylandFull
    winetricks
    q4wine

    # Media
    feh
    mpv
    imv
    pavucontrol
    vlc
    obs-studio

    # Dependencies
    libnotify
    libappindicator-gtk3
    light
    mpris-scrobbler
    xdg-utils
    bluez

    # Graphics
    libresprite
    inkscape

    # Audio
    ardour
    sonic-visualiser
    soundfont-fluid
    soundfont-generaluser
    x42-plugins
    geonkick
    musescore
    drumgizmo
    lsp-plugins
    cardinal
    dexed
    odin2
    surge-XT
    vital

    # Misc.
    bitwarden
    okular
    zathura
    libreoffice
    zeal
    qalculate-gtk
    samba
    qbittorrent
    appimage-run
    # thunderbird

    # File Management
    zip
    unzip
    unrar
    unar
    soundconverter
    uget
    uget-integrator
    paperwork

    #Engineering
    # kicad # disabled b/c it takes forever to build
    freecad

    # N64 dev 
    milkytracker
    cen64

    furnace # deflemask compatible, sound chip emulation, tracker

    plasma5Packages.plasma-browser-integration
    nextcloud-client
    tailscale
    ktailctl
    plasma5Packages.kasts
    elisa
    kdePackages.audiocd-kio
    libcdio

    # Allows gtk apps (like firefox) to integrate with KDE theming;
    # meaning it will actually follow light/dark theming
    kde-gtk-config
    breeze-gtk

    firefox-bin
    discover
  ];

  services.mpris-proxy.enable = true;
  services.syncthing.enable = true;

  # Programs, sorted alphabetically
  programs.atuin = {
    package = inputs.atuin.packages.${pkgs.system}.default;
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
}
