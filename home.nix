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
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Add ~/.local/bin to my PATH
  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.config/emacs/bin" ];

  home.file = {
    ".config/doom/config.el".source = ./doom.d/config.el;
    ".config/doom/dialog.el".source = ./doom.d/dialog.el;
    ".config/doom/init.el".source = ./doom.d/init.el;
    ".config/doom/packages.el".source = ./doom.d/packages.el;
  };

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
    # font = {
    #   name = "FiraCode Nerd Font Mono Medium";
    # };
  };

  # Apps I don't care to configure
  home.packages = with pkgs; [ 
    # Terminal
    btop
    ranger
    zellij

    # Editor LSP support
    clang-tools

    # Editors
    emacs
    helix
    hicolor-icon-theme
    unstable.lapce

    # Video/Audio
    feh
    mpv
    pavucontrol
    vlc
    mopidy

    # Dependencies
    libnotify
    libappindicator-gtk3
    light
    mpris-scrobbler
    nodejs
    nodePackages.npm
    ripgrep
    sqlite
    tex # defined at top of file
    xdg-utils

    # Apps
    bitwarden
    element-desktop
    okular
    reaper
    solaar
    torrential
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.tumbler
    zathura
    libreoffice

    # File Management
    zip
    unzip
    unrar
    unar
    soundconverter
    picard
  ];

  # Services, sorted alphabetically
  services.emacs = {
    enable = true;
    startWithUserSession = true;
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";
    profiles = (import ./kanshi/profiles.nix pkgs);
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
    extraConfigFiles = [ "${config.xdg.configHome}/mopidy/mopidy-secrets.conf" ];
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
  programs.alacritty = {
    enable = true;
    settings = import ./alacritty.nix;
  };

  programs.chromium = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    # TODO: Add nur so addons can be managed by nix
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      forceWayland = true;
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
      core.defaultBranch = "main";
    };
  };

  programs.gitui = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      yankring
      vim-nix
      { plugin = vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }
    ];
  };

  programs.qutebrowser = {
    enable = true;
    settings = {
      colors.webpage.preferred_color_scheme = "dark";
    };
    extraConfig = builtins.readFile ./qutebrowser/extraConfig.py;
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    style = ./waybar/style.css;
    settings = import ./waybar;
  };
}
