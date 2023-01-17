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

  # Sway defines
  # Mod4 for Super
  # Mod1 for Alt
  modifier = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  resizeAmount = "10px";
  menu = "wofi --show=drun --lines=5 --prompt=''";
  terminal = pkgs.foot;
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

    # sway
    wofi
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
    # systemd.enable = true;
    # systemd.target = "sway-session.target";
    style = ./waybar/style.css;
    settings = import ./waybar;
  };

  services.kanshi = {
    enable = true;
    profiles = (import ./kanshi/profiles.nix pkgs);
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      floating.border = 1;
      window.border = 1;
      colors.background = "#000000";
      fonts = {
        names = [ "Source Code Pro" "Roboto" ];
        style = "Regular Bold";
        size = 8.0;
      };
      bars = [];
      menu = menu;
      modifier = modifier;
      up = up;
      left = left;
      down = down;
      right = right;
      assigns = {
        "web" = [{ class = "^Firefox"; }];
        "docs" = [{ class = "^qutebrowser"; }];
        "code" = [{ class = "^emacs"; }];
      };
      keybindings = {
        # Exit sway (logs you out of your Wayland session)
        # "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${modifier}+Shift+e" = "exit";

        # Reload the configuration file
        "${modifier}+Shift+c" = "reload";

        # Kill focused window
        "${modifier}+Shift+q" = "kill";

        # Launch the default terminal $TERM
        "${modifier}+Return" = "exec foot";
        "${modifier}+d" = "exec ${menu}";

        # Take a screenshot by selecting an area
        # TODO
        # Toggle deafen
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        # Toggle mute
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SINK@ toggle";
        # Raise sink (speaker, headphones) volume
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        # Lower sink (microphone) volume
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        # Media controls
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";

        # Brightness control
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86MonBrightnessDown" = "exec light -U 10";
        "${modifier}+F12" = "exec ddcutil setcvp 10 + 10";
        "${modifier}+F11" = "exec ddcutil setcvp 10 - 10";
        "${modifier}+Control+F12" = "exec ddcutil setcvp 10 15";
        "${modifier}+Control+F11" = "exec ddcutil setcvp 10 0";
        # Moving around
        ## Move your focus around
        "${modifier}+${up}" = "focus up";
        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${right}" = "focus right";

        ### With arrow keys
        "${modifier}+Up" = "focus up";
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Right" = "focus right";

        ## Move the focused window with the same, but add Shift
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${right}" = "move right";

        ### With arrow keys
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Right" = "move right";

        # Workspaces
        ## Switch to workspace
        "${modifier}+1" = "workspace '1:music'";
        "${modifier}+2" = "workspace '2:docs'";
        "${modifier}+3" = "workspace '3:term'";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace '7:code'";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace '10:web'";

        ## Move focused container to workspace
        "${modifier}+Shift+1" = "move container to workspace '1:music'";
        "${modifier}+Shift+2" = "move container to workspace '2:docs'";
        "${modifier}+Shift+3" = "move container to workspace '3:term'";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace '7:code'";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace '10:web'";

        ## Move workspaces between outputs
        "${modifier}+Control+Shift+${up}" = "move workspace to output up";
        "${modifier}+Control+Shift+${left}" = "move workspace to output left";
        "${modifier}+Control+Shift+${down}" = "move workspace to output down";
        "${modifier}+Control+Shift+${right}" = "move workspace to output right";

        # Layout stuff
        ## You can split the current object of your focus with mod+b or mod+v, for horizontal and vertical splits respectively.
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";

        ## Switch the current container between different layout styles.
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        ## Make the current focus fullscreen.
        "${modifier}+f" = "fullscreen";

        ## Toggle the current focus between tiling and floating mode
        "${modifier}+Shift+space" = "floating toggle";

        ## Swap focus between the tiling area and the floating area
        "${modifier}+space" = "focus mode_toggle";

        ## Move focus to the parent container
        "${modifier}+a" = "focus parent";

        # Scratchpad
        ## Move the currently focused window to the scratchpad
        "${modifier}+Shift+minus" = "move scratchpad";

        ## Show the next scratchpad window or hide the focused scratchpad window. If there are multiple scratchpad windows, this command cycles through them.
        "${modifier}+minus" = "scratchpad show";

        # Resizing containers
        ## Mode "resize"
        "${modifier}+r" = "mode 'resize'";
      };
      modes = {
        resize = {
          # left will shrink the containers width
          # right will grow the containers width
          # up will shrink the containers width
          # down will grow the containers width
          "${left}" = "resize shrink width 10px";
          "${right}" = "resize grow width 10px";
          "${up}" = "resize shrink height 10px";
          "${down}" = "resize grow height 10px";

          # Ditto, with arrow keys
          "Left" = "resize shrink width 10px";
          "Right" = "resize grow width 10px";
          "Up" = "resize shrink height 10px";
          "Down" = "resize grow height 10px";

          "Return" = "mode 'default'";
          "Escape" = "mode 'default'";
        };
      };
      startup = [
        { command = "mako"; }
        { command = "wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store --no-persist"; }
        { command = "/run/current-system/sw/libexec-polkit-gnome-authentication-agent-1"; }
        { command = "kanshi"; }
        { command = "waybar"; }
      ];
      terminal = terminal;
      window.titlebar = false;
    };
  };
}
