{ config, pkgs, ... }:

let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
  });
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
    font = {
      name = "FiraCode Nerd Font Mono Medium";
    };
  };

  # Apps I don't care to configure
  home.packages = with pkgs; [ 
    # Terminal
    btop
    ranger
    zellij

    # Editors
    emacs
    helix

    # Video/Audio
    feh
    mpv
    pavucontrol
    vlc

    # Dependencies
    libnotify
    libappindicator-gtk3
    light
    mpris-scrobbler
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
    zathura

    # File Management
    unzip
    unrar
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
    extensionPackages = with pkgs; [
      mopidy-mpris
      mopidy-ytmusic
      mopidy-iris
      mopidy-local
      mopidy-podcast
      mopidy-scrobbler
    ];
    settings = {
      mpd.hostname = "::";
      ytmusic.auth_json = "/home/desttinghim/.config/mopidy/ytmusic/auth.json";
      # TODO: learn how to manage secrets with nix
      # The username/password need to be added manually for now
      scrobbler.enabled = true;
      local = {
        media_dir = "/home/desttinghim/Music";
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

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    style = ./waybar/style.css;
    settings = import ./waybar;
  };
}
