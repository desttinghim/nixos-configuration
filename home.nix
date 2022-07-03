{ config, pkgs, ... }:

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

  home.packages = with pkgs; [ 
    # Terminal
    htop 
    zellij
    ranger

    # Video/Audio
    feh
    mpv
    pavucontrol
    vlc
    # obs-studio
    # plex-media-player
    # stremio

    # Dependencies
    libnotify
    light

    # Apps
    chromium
    firefox
    foot

    # File Management
    unzip
    unrar
  ];

  nixpkgs.config.allowUnfree = true;

  home.sessionPath = [ "$HOME/.local/bin" ];

  accounts.email.accounts.fastmail = {
    primary = true;
    address = "lep@fastmail.com";
    aliases = [ "contact@louispearson.work" "opensource@louispearson.work" ];
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

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings.git_protocol = "https";
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        output = [ "Virtual-1" ];
        modules-left = [ "sway-workspaces" "sway/mode" "wlr/taskbar" ];
        moduels-center = [ "sway/window" "custom/hello-from-waybar" ];
        modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      };
    };
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";
    profiles = {
      virtual = {
        outputs = [
          {
            criteria = "Virtual-1";
            mode = "1440x900";
          }
        ];
      };
    };
  };

  services.swayidle.enable = true;

  wayland.windowManager.sway = {
    enable = true;
  };

  # home.pointerCursor = {
  #   name = "Dracula-cursors";
  #   package = pkgs.dracula-theme;
  #   size = 16;
  # };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Dracula";
  #     package = pkgs.dracula-theme;
  #   };
  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #   };
  #   font = {
  #     name = "FiraCode Nerd Font Mono Medium";
  #   };
  # };
}
