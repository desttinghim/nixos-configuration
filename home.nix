{ config, pkgs, ... }:

let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of metafont
      pdflscape pdfpages # for including pdfs in latex
    ;
  });
  mopidy-bandcamp = pkgs.python3Packages.buildPythonApplication rec {
    name = "mopidy-bandcamp";
    version = "1.1.5";
    src = pkgs.fetchFromGitHub {
      owner = "impliedchaos";
      repo = "mopidy-bandcamp";
      rev = "v${version}";
      sha256 = "sha256-Dl/ge3B2/tHKAY1DhD4XVbZWTrVfcQyo8lXmYQzUm9s=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [ pkgs.mopidy pykka ];

    doCheck = false;

    meta = with pkgs.lib; {
      description = "Mopidy extension for playing music from bandcamp";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "desttinghim";
  home.homeDirectory = "/home/desttinghim";

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

  # Add ~/.local/bin to my PATH
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.config/emacs/bin" "$HOME/.cargo/bin" "$HOME/.bun/bin" ];

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 12;
  };

  # gtk theming
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Apps I don't care to configure
  home.packages = with pkgs; [ 
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
    pinentry-curses
    cmake # vterm, c/c++
    editorconfig-core-c
    irony-server
    glslang
    rtags

    # Programming
    clang-tools
    cargo
    rustfmt
    clang
    lua53Packages.luacheck
    sumneko-lua-language-server
    openjdk

    # Editors
    emacs
    vim
    neovim
    helix
    hicolor-icon-theme

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
    tex # defined at top of file
    xdg-utils
    bluez
    unstable.bluetuith

    # Chat
    unstable.armcord
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
    sunvox
    soundfont-fluid
    soundfont-generaluser
    x42-gmsynth
    geonkick

    # Misc.
    bitwarden
    godot
    godot-export-templates
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
  ];

  # Services, sorted alphabetically
  services.emacs = {
    enable = true;
    # startWithUserSession = true;
  };

  services.wlsunset = {
    enable = true;
    latitude = "42";
    longitude = "-112";
    systemdTarget = "sway-session.target";
  };

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
      mopidy-podcast
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
      scrobbler.enabled = false;
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

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    style = ./waybar/style.css;
    settings = import ./waybar;
  };
}
