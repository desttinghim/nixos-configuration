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
    style = ./waybar/style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        output = [ "Virtual-1" ];
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "battery" "clock" "tray" ];

        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = false;
          "format" = "{index}: {icon}";
          "format-icons" = {
              "1:web"   = "";
              "2:docs"  = "";
              "7:code"  = "";
              "*:term"  = "";
              "*:work"  = "";
              "*:music" = "";
              "urgent"  = "";
              "focused" = "";
              "default" = "";
          };
        };

        "battery" = {
          "format" = "{capacity}% {icon}";
          "format-icons" = [ "" "" "" "" "" ];
        };

        "clock" = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calander}</small></tt>";
          "format-alt" = "{:%Y-%m-%d %H:%M}";
        };

        "network" = {
          "format-wifi"         =  "";
          "format-ethernet"     =  "{ipaddr}/{cidr} ";
          "tooltip-format"      =  "{ifname} via {gwaddr} ";
          "format-linked"       =  "{ifname} (No IP) ";
          "format-disconnected" =  "⚠";
          "format-alt"          = "{ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          "format" = "{icon} {volume}% {format_source}";
          "format-bluetooth" = "{icon} {volume}%  {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = " {volume}%";
          "format-source-muted" = "";
          "format-icons" =  {
              "headphones"  = "";
              "handsfree"   = "";
              "headset"     = "";
              "phone"       = "";
              "portable"    = "";
              "car"         = "";
              "default"     = [ "" "" ];
          };
          "on-click" = "pavucontrol";
        };

        "tray"."spacing" = 10;
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
