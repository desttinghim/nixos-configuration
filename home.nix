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
    # obs-studio
    pavucontrol
    # plex-media-player
    vlc
    # stremio

    # Dependencies
    libnotify

    # Apps
    chromium
    firefox
    alacritty

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

  # programs.waybar = {
  #   enable = true;
  #   systemd.enable = true;
  #   systemd.target = "sway-session.target";
  #   settings = {
  #     mainBar = {};
  #   };
  # };

  # services.kanshi = {
  #   enable = true;
  #   systemdTarget = "sway-session.target";
  #   profiles = {
  #     undocked = {
  #       outputs = [
  #         {
  #           criteria = "eDP-1";
  #         }
  #       ];
  #     };
  #     docked = {
  #       outputs = [
  #         {
  #           criteria = "eDP-1";
  #         }
  #         {
  #           criteria = "Some company ASDF 4242";
  #           transform = "90";
  #         }
  #       ];
  #     };
  #   };
  # };

  # services.swayidle.enable = true;

  # wayland.windowManager.sway = {
  #   enable = true;
  # };

  # home.file = {
  #   ".config/alacritty/alacritty.yml".text = ''
  #     {"font":{"bold":{"style":"Bold"}}}
  #   '';
  # };

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 16;
  };

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
}
