{ inputs, lib, config, pkgs, ...}: {
  # Import home-manager modules here
  imports = [
    # inputs.nix-colors.homeManagerModule
    inputs.plasma-manager.homeManagerModules.plasma-manager
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
    username = "desttinghim";
    homeDirectory = "/home/desttinghim";
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
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    GDK_BACKEND="wayland";
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
    inputs.zig.packages.${system}.master-2024-01-07
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
    x42-gmsynth
    geonkick
    musescore

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
    thunderbird

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

    # Allows gtk apps (like firefox) to integrate with KDE theming;
    # meaning it will actually follow light/dark theming
    kde-gtk-config
    breeze-gtk
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

  programs.firefox = {
    enable = true;
    # TODO: Add nur so addons can be managed by nix
    package = pkgs.firefox-wayland;
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

  # KDE configuration, depends on plasma-manager
  programs.plasma = {
    enable = true;

    # High-level plasma settings
    
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursorTheme = "Dracula-cursors";
      iconTheme = "dracula-icons-main"; 
      wallpaper = "${pkgs.libsForQt5.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";    
    };

    panels = [
      # Windows-like panel at bottom of screen
      {
        location = "bottom";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseperator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    # Mid-level plasma settings 
    shortcuts = {
      "Alacritty.desktop"."New" = "Meta+Return";

      kwin = {
        # Polonium items (kwin tiling script)
        "PoloniumCycleLayouts" = "Meta+|";
        # "PoloniumEngineBTree" = [ ];
        # "PoloniumEngineHalf" = [ ];
        # "PoloniumEngineKWin" = [ ];
        # "PoloniumEngineMonocle" = [ ];
        # "PoloniumEngineThreeColumn" = [ ];
        "PoloniumFocusAbove" = "Meta+K";
        "PoloniumFocusBelow" = "Meta+J";
        "PoloniumFocusLeft" = "Meta+H";
        "PoloniumFocusRight" = "Meta+L";
        "PoloniumInsertAbove" = "Meta+Shift+O";
        "PoloniumInsertBelow" = "Meta+O";
        "PoloniumInsertLeft" = "Meta+I";
        "PoloniumInsertRight" = "Meta+A";
        "PoloniumRebuildLayout" = "Meta+Ctrl+Space";
        "PoloniumResizeTileDown" = "Meta+Shift+Down";
        # "PoloniumResizeTileLeft" = [ ];
        # "PoloniumResizeTileRight" = [ ];
        "PoloniumResizeTileUp" = "Meta+Shift+Up";
        "PoloniumRetileWindow" = "Meta+Shift+Space";
        "PoloniumShowSettings" = "Meta+?";
        "PoloniumSwapAbove" = "Meta+Shift+K";
        "PoloniumSwapBelow" = "Meta+Shift+J";
        "PoloniumSwapLeft" = "Meta+Shift+H";
        "PoloniumSwapRight" = "Meta+Shift+L"; 

        # Default plasma items
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";
        "Switch to Desktop 9" = "Meta+9";
        "Switch to Desktop 10" = "Meta+0";

        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+@";
        "Window to Desktop 3" = "Meta+#";
        "Window to Desktop 4" = "Meta+$";
        "Window to Desktop 5" = "Meta+%";
        "Window to Desktop 6" = "Meta+^";
        "Window to Desktop 7" = "Meta+&";
        "Window to Desktop 8" = "Meta+*";
        "Window to Desktop 9" = "Meta+(";
        "Window to Desktop 10" = "Meta+)";

        # "Switch Window Left" = "Meta+H"; 
        # "Switch Window Down" = "Meta+J"; 
        # "Switch Window Up" = "Meta+K"; 
        # "Switch Window Right" = "Meta+L"; 

        "Window Fullscreen" = "Meta+F";
        "Window Maximize" = "Meta+M";
        "Window Minimize" = "Meta+N";
      };          

      "org\\.kde\\.plasma\\.emojier\\.desktop"."_launch" = "Meta+."; 
      plasmashell = {
        cycle-panels = "Meta+Alt+P";
      };
    };

    # Low-level plasma settings
    configFile = {
      baloofilerc."Basic Settings".Indexing-Enabled = false;

      kwinrc = { 
        ModifierOnlyShortcuts.Meta = "";
        Xwayland.Scale = 1.5; 
        Compositing.LatencyPolicy = "Low";

        Plugins = {
          bismuthEnabled = false;
          poloniumEnabled = true;
        };

        Desktops = { 
          "Name_1" = "Desktop 1";
          "Name_2" = "Desktop 2";
          "Name_3" = "Desktop 3";
          "Name_4" = "Desktop 4";
          "Name_5" = "Desktop 5";
          "Name_6" = "Desktop 6";
          "Name_7" = "Desktop 7";
          "Name_8" = "Desktop 8";
          "Name_9" = "Desktop 9";
          "Name_10" = "Desktop 10";
          "Number" = 10;
          "Rows" = 1;
        };
      };

      ksplashrc.KSplash.Engine = "KSplashQML";

      kdeglobals = {
        KScreen.ScaleFactor = 1.25;

        Shortcuts = {
          Quit = "Meta+Shift+Q";
        };

        General = {
          BrowserApplication = "firefox.desktop";
          TerminalApplication = "alacritty";
          TerminalService = "Alacritty.desktop"; 
          ColorScheme = "DraculaPurple";
          ColorSchemeHash = "01662607e36cd33eacc7d7d7189f69c26b9a2cc8";
        };

        KDE.widgetStyle = "Fusion";
      };
    };
  };

  # direnv - automatically load project environment from shell.nix
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
