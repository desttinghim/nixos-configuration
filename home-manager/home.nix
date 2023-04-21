{ inputs, lib, config, pkgs, ...}: {
  # Import home-manager modules here
  imports = [
    inputs.nix-colors.homeManagerModule
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

  colorScheme = inputs.nix-colors.colorSchemes.dracula;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  # Add ~/.local/bin to my PATH
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.config/emacs/bin" "$HOME/.cargo/bin" "$HOME/.bun/bin" ];

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
    libsForQt5.bismuth

    # Terminal
    btop
    ranger
    zellij
    entr # re run commands when files change
    tldr
    silver-searcher
    bashmount

    # Doom emacs
    ripgrep
    sqlite
    wordnet
    mu
    isync
    gnupg
    gnumake
    cmake # vterm, c/c++
    editorconfig-core-c
    irony-server
    glslang
    rtags
    fd

    # Programming
    clang-tools
    cargo
    rustfmt
    clang
    lua53Packages.luacheck
    sumneko-lua-language-server
    openjdk
    inputs.zig.packages.${system}.master
    inputs.zls.packages.${system}.default
    inputs.roc.packages.${system}.default
    git-bug
    nodePackages.prettier
    nodejs
    python
    erlang
    kotlin
    gradle
    exercism
    julia-bin
    python310Packages.pytest
    python310Packages.pytest-cache
    python310Packages.pytest-subtests
    R

    # Windows UI development
    wxformbuilder
    python310Packages.wxPython_4_2
    python310Full
    wineWowPackages.waylandFull
    winetricks
    skypeforlinux
    q4wine

    # Editors
    emacs28-gtk
    vim
    neovim
    helix
    hicolor-icon-theme
    wl-clipboard

    # Media
    feh
    flameshot
    mpv
    pavucontrol
    vlc
    mopidy
    qjackctl
    obs-studio

    # Dependencies
    libnotify
    libappindicator-gtk3
    light
    mpris-scrobbler
    nodejs
    nodePackages.npm
    xdg-utils
    bluez

    # Chat
    armcord
    discord
    element-desktop
    zoom-us
    zulip

    # Graphics
    libresprite
    inkscape

    # Audio
    ardour
    polyphone
    reaper
    sonic-visualiser
    soundfont-fluid
    soundfont-generaluser
    x42-gmsynth
    geonkick

    # Misc.
    bitwarden
    godot_4
    okular
    pdftk
    solaar
    torrential
    zathura
    libreoffice
    zeal
    imv
    qalculate-gtk
    okteta
    dbeaver
    sqlitebrowser
    samba
    qbittorrent
    appimage-run

    # CLI Spreadsheet
    visidata
    sc-im

      
    # File Management
    zip
    unzip
    unrar
    unar
    soundconverter
    picard
    uget
    uget-integrator
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.tumbler
    paperwork
  ];

  services.mopidy = {
    enable = true;
    # This adds the file mopidy-secrets.conf to the config search path.
    # The files are combined, with later files overriding earlier ones
    # extraConfigFiles = [ "${config.xdg.configHome}/mopidy/mopidy-secrets.conf" ];
    extensionPackages = with pkgs; [
      mopidy-bandcamp
      mopidy-mpris
      mopidy-ytmusic
      mopidy-iris
      mopidy-local
      mopidy-scrobbler
    ];
    settings = {
      iris = {
        country = "us";
        locale = "en_US";
      };
      # See here for process to get ytmusic auth info:
      # https://ytmusicapi.readthedocs.io/en/latest/setup.html
      # See here for info on brand accounts (apparently I use one?):
      # https://ytmusicapi.readthedocs.io/en/latest/faq.html
      # Finally, add "X-Goog-PageId" from the request header. This is
      # the same as the brand id.
      ytmusic = {
        enabled = true;
        enable_history = true;
        enable_scrobbling = true;
        auth_json = "/home/desttinghim/.config/mopidy/ytmusic/auth.json";
      };
      scrobbler.enabled = true;
      # NOTE: Local has a mopidy-scan.service file that needs to be run to
      # update. The local scan button in Iris can't be used. Rerun with the following command:
      # systemctl --user start mopidy-scan
      # TODO: automate this
      local = {
        media_dir = "~/Music";
      };
    };
  };

  services.mpris-proxy.enable = true;
  services.swayidle.enable = true;
  services.syncthing.enable = true;

  # Programs, sorted alphabetically
  programs.chromium = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    # TODO: Add nur so addons can be managed by nix
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        ExtensionSettings = {};
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = import ./foot.nix;
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
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

  programs.gitui = {
    enable = true;
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

  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscodium;
  #   extensions = with pkgs.vscode-extensions; [
  #     dracula-theme.theme-dracula
  #     vscodevim.vim
  #     tiehuis.zig
  #   ];
  # };
}
