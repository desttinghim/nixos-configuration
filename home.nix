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

  # Apps I don't care to configure
  home.packages = with pkgs; [ 
    # Terminal
    btop 
    zellij
    ranger
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

    # Apps
    chromium
    element-desktop
    syncthing
    bitwarden
    reaper
    solaar
    dia
    zathura
    okular
    libreoffice
    kicad-small
    ripgrep
    emacs
    sqlite

    # File Management
    unzip
    unrar
  ];

  services.emacs = {
    enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

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
        height = 24;
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "battery" "clock" "tray" ];

        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = false;
          "format" = "{index}: {icon}";
          "format-icons" = {
              "10:web"   = "";
              "2:docs"  = "";
              "7:code"  = "";
              "3:term"  = "";
              "work"  = "";
              "1:music" = "";
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
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = "{icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "";
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

  programs.alacritty = {
    enable = true;
    # Dracula theme for alacritty
    settings.colors = {
      primary = {
        background = "#282a36";
        foreground = "#f8f8f2";
        bright_foreground = "#ffffff";
      };
      cursor = {
        text = "CellBackground";
        cursor = "CellForeground";
      };
      search = {
        matches = { foreground = "#44475a"; background = "#50fa7b"; };
        focused_match = {
          foreground = "#44475a";
          background = "#ffb86c";
        };
        bar = {
          background = "#282a36";
          foreground = "#f8f8f2";
        };
      };
      hints = {
        start = {
          foreground = "#282a36";
          background = "#f1fa8c";
        };
        end = {
          foreground = "#f1fa8c";
          background = "#282a36";
        };
      };
      line_indicator = {
        foreground = "None";
        background = "None";
      };
      selection = {
        text = "CellForeground";
        background = "#44475a";
      };
      normal = {
        black = "#21222c";
        red = "#ff5555";
        green = "#50fa7b";
        yellow = "#f1fa8c";
        blue = "#bd93f9";
        magenta = "#ff79c6";
        cyan = "#8be9fd";
        white = "#f8f8f2";
      };
      bright = {
        black = "#6272a4";
        red = "#ff6e6e";
        green = "#69ff94";
        yellow = "#ffffa5";
        blue = "#d6acff";
        magenta = "#ff92df";
        cyan = "#a4ffff";
        white = "#ffffff";
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "yes";
      };
      colors = {
        # Normal/regular colors (color palette 0-7
        regular0 = "21222c"; 
        regular1 = "ff5555";
        regular2 = "50fa7b";
        regular3 = "f1fa8c";
        regular4 = "bd93f9";
        regular5 = "ff79c6";
        regular6 = "8be9fd";
        regular7 = "f8f8f2"; 

        # Bright colors (color palette 8-15)
        bright0 = "21222c";
        bright1 = "ff6e6e";
        bright2 = "69ff94";
        bright3 = "ffffa5";
        bright4 = "d6acff";
        bright5 = "ff92df";
        bright6 = "a4ffff";
        bright7 = "ffffff";  

        # Misc colors
        selection-foreground = "ffffff";
        selection-background = "44475a";
        urls = "8be9fd";
      };
    };
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

  programs.qutebrowser = {
    enable = true;
    settings = {
    };
    extraConfig  = ''
def blood(c, options = {}):
    palette = {
        'background': '#282a36',
        'background-alt': '#282a36', 
        'background-attention': '#181920',
        'border': '#282a36',
        'current-line': '#44475a',
        'selection': '#44475a',
        'foreground': '#f8f8f2',
        'foreground-alt': '#e0e0e0',
        'foreground-attention': '#ffffff',
        'comment': '#6272a4',
        'cyan': '#8be9fd',
        'green': '#50fa7b',
        'orange': '#ffb86c',
        'pink': '#ff79c6',
        'purple': '#bd93f9',
        'red': '#ff5555',
        'yellow': '#f1fa8c'
    }   

    spacing = options.get('spacing', {
        'vertical': 5,
        'horizontal': 5
    })

    padding = options.get('padding', {
        'top': spacing['vertical'],
        'right': spacing['horizontal'],
        'bottom': spacing['vertical'],
        'left': spacing['horizontal']
    })

    ## Background color of the completion widget category headers.
    c.colors.completion.category.bg = palette['background']

    ## Bottom border color of the completion widget category headers.
    c.colors.completion.category.border.bottom = palette['border']

    ## Top border color of the completion widget category headers.
    c.colors.completion.category.border.top = palette['border']

    ## Foreground color of completion widget category headers.
    c.colors.completion.category.fg = palette['foreground']

    ## Background color of the completion widget for even rows.
    c.colors.completion.even.bg = palette['background']

    ## Background color of the completion widget for odd rows.
    c.colors.completion.odd.bg = palette['background-alt']

    ## Text color of the completion widget.
    c.colors.completion.fg = palette['foreground']

    ## Background color of the selected completion item.
    c.colors.completion.item.selected.bg = palette['selection']

    ## Bottom border color of the selected completion item.
    c.colors.completion.item.selected.border.bottom = palette['selection']

    ## Top border color of the completion widget category headers.
    c.colors.completion.item.selected.border.top = palette['selection']

    ## Foreground color of the selected completion item.
    c.colors.completion.item.selected.fg = palette['foreground']

    ## Foreground color of the matched text in the completion.
    c.colors.completion.match.fg = palette['orange']

    ## Color of the scrollbar in completion view
    c.colors.completion.scrollbar.bg = palette['background']

    ## Color of the scrollbar handle in completion view.
    c.colors.completion.scrollbar.fg = palette['foreground']

    ## Background color for the download bar.
    c.colors.downloads.bar.bg = palette['background']

    ## Background color for downloads with errors.
    c.colors.downloads.error.bg = palette['background']

    ## Foreground color for downloads with errors.
    c.colors.downloads.error.fg = palette['red']

    ## Color gradient stop for download backgrounds.
    c.colors.downloads.stop.bg = palette['background']

    ## Color gradient interpolation system for download backgrounds.
    ## Type: ColorSystem
    ## Valid values:
    ##   - rgb: Interpolate in the RGB color system.
    ##   - hsv: Interpolate in the HSV color system.
    ##   - hsl: Interpolate in the HSL color system.
    ##   - none: Don't show a gradient.
    c.colors.downloads.system.bg = 'none'

    ## Background color for hints. Note that you can use a `rgba(...)` value
    ## for transparency.
    c.colors.hints.bg = palette['background']

    ## Font color for hints.
    c.colors.hints.fg = palette['purple']

    ## Hints
    c.hints.border = '1px solid ' + palette['background-alt']

    ## Font color for the matched part of hints.
    c.colors.hints.match.fg = palette['foreground-alt']

    ## Background color of the keyhint widget.
    c.colors.keyhint.bg = palette['background']

    ## Text color for the keyhint widget.
    c.colors.keyhint.fg = palette['purple']

    ## Highlight color for keys to complete the current keychain.
    c.colors.keyhint.suffix.fg = palette['selection']

    ## Background color of an error message.
    c.colors.messages.error.bg = palette['background']

    ## Border color of an error message.
    c.colors.messages.error.border = palette['background-alt']

    ## Foreground color of an error message.
    c.colors.messages.error.fg = palette['red']

    ## Background color of an info message.
    c.colors.messages.info.bg = palette['background']

    ## Border color of an info message.
    c.colors.messages.info.border = palette['background-alt']

    ## Foreground color an info message.
    c.colors.messages.info.fg = palette['comment']

    ## Background color of a warning message.
    c.colors.messages.warning.bg = palette['background']

    ## Border color of a warning message.
    c.colors.messages.warning.border = palette['background-alt']

    ## Foreground color a warning message.
    c.colors.messages.warning.fg = palette['red']

    ## Background color for prompts.
    c.colors.prompts.bg = palette['background']

    # ## Border used around UI elements in prompts.
    c.colors.prompts.border = '1px solid ' + palette['background-alt']

    ## Foreground color for prompts.
    c.colors.prompts.fg = palette['cyan']

    ## Background color for the selected item in filename prompts.
    c.colors.prompts.selected.bg = palette['selection']

    ## Background color of the statusbar in caret mode.
    c.colors.statusbar.caret.bg = palette['background']

    ## Foreground color of the statusbar in caret mode.
    c.colors.statusbar.caret.fg = palette['orange']

    ## Background color of the statusbar in caret mode with a selection.
    c.colors.statusbar.caret.selection.bg = palette['background']

    ## Foreground color of the statusbar in caret mode with a selection.
    c.colors.statusbar.caret.selection.fg = palette['orange']

    ## Background color of the statusbar in command mode.
    c.colors.statusbar.command.bg = palette['background']

    ## Foreground color of the statusbar in command mode.
    c.colors.statusbar.command.fg = palette['pink']

    ## Background color of the statusbar in private browsing + command mode.
    c.colors.statusbar.command.private.bg = palette['background']

    ## Foreground color of the statusbar in private browsing + command mode.
    c.colors.statusbar.command.private.fg = palette['foreground-alt']

    ## Background color of the statusbar in insert mode.
    c.colors.statusbar.insert.bg = palette['background-attention']

    ## Foreground color of the statusbar in insert mode.
    c.colors.statusbar.insert.fg = palette['foreground-attention']

    ## Background color of the statusbar.
    c.colors.statusbar.normal.bg = palette['background']

    ## Foreground color of the statusbar.
    c.colors.statusbar.normal.fg = palette['foreground']

    ## Background color of the statusbar in passthrough mode.
    c.colors.statusbar.passthrough.bg = palette['background']

    ## Foreground color of the statusbar in passthrough mode.
    c.colors.statusbar.passthrough.fg = palette['orange']

    ## Background color of the statusbar in private browsing mode.
    c.colors.statusbar.private.bg = palette['background-alt']

    ## Foreground color of the statusbar in private browsing mode.
    c.colors.statusbar.private.fg = palette['foreground-alt']

    ## Background color of the progress bar.
    c.colors.statusbar.progress.bg = palette['background']

    ## Foreground color of the URL in the statusbar on error.
    c.colors.statusbar.url.error.fg = palette['red']

    ## Default foreground color of the URL in the statusbar.
    c.colors.statusbar.url.fg = palette['foreground']

    ## Foreground color of the URL in the statusbar for hovered links.
    c.colors.statusbar.url.hover.fg = palette['cyan']

    ## Foreground color of the URL in the statusbar on successful load
    c.colors.statusbar.url.success.http.fg = palette['green']

    ## Foreground color of the URL in the statusbar on successful load
    c.colors.statusbar.url.success.https.fg = palette['green']

    ## Foreground color of the URL in the statusbar when there's a warning.
    c.colors.statusbar.url.warn.fg = palette['yellow']

    ## Status bar padding
    c.statusbar.padding = padding

    ## Background color of the tab bar.
    ## Type: QtColor
    c.colors.tabs.bar.bg = palette['selection']

    ## Background color of unselected even tabs.
    ## Type: QtColor
    c.colors.tabs.even.bg = palette['selection']

    ## Foreground color of unselected even tabs.
    ## Type: QtColor
    c.colors.tabs.even.fg = palette['foreground']

    ## Color for the tab indicator on errors.
    ## Type: QtColor
    c.colors.tabs.indicator.error = palette['red']

    ## Color gradient start for the tab indicator.
    ## Type: QtColor
    c.colors.tabs.indicator.start = palette['orange']

    ## Color gradient end for the tab indicator.
    ## Type: QtColor
    c.colors.tabs.indicator.stop = palette['green']

    ## Color gradient interpolation system for the tab indicator.
    ## Type: ColorSystem
    ## Valid values:
    ##   - rgb: Interpolate in the RGB color system.
    ##   - hsv: Interpolate in the HSV color system.
    ##   - hsl: Interpolate in the HSL color system.
    ##   - none: Don't show a gradient.
    c.colors.tabs.indicator.system = 'none'

    ## Background color of unselected odd tabs.
    ## Type: QtColor
    c.colors.tabs.odd.bg = palette['selection']

    ## Foreground color of unselected odd tabs.
    ## Type: QtColor
    c.colors.tabs.odd.fg = palette['foreground']

    # ## Background color of selected even tabs.
    # ## Type: QtColor
    c.colors.tabs.selected.even.bg = palette['background']

    # ## Foreground color of selected even tabs.
    # ## Type: QtColor
    c.colors.tabs.selected.even.fg = palette['foreground']

    # ## Background color of selected odd tabs.
    # ## Type: QtColor
    c.colors.tabs.selected.odd.bg = palette['background']

    # ## Foreground color of selected odd tabs.
    # ## Type: QtColor
    c.colors.tabs.selected.odd.fg = palette['foreground']

    ## Tab padding
    c.tabs.padding = padding
    c.tabs.indicator.width = 1
    c.tabs.favicons.scale = 1

blood(c, {
  'spacing': {
    'vertical': 6,
    'horizontal': 8
  }
})

config.set("colors.webpage.preferred_color_scheme", "dark")
# config.set("colors.webpage.darkmode.enabled", True)
    '';
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";
    profiles =
      let
        fd = {
          criteria = "Unknown 0x095F 0x00000000";
          mode = "2256x1504";
          scale = 1.5;
        };
        # My ViewSonic Gaming Monitor
        vs-g = {
          criteria = "ViewSonic Corporation XG2401 SERIES UG2193120319";
          mode = "1920x1080";
          scale = 1.0;
        };
        # My ViewSonic Normal Monitor
        vs-n = {
          criteria = "ViewSonic Corporation VA2746 Series V1Y203820007";
          mode = "1920x1080";
          scale = 1.0;
        };
        wasatch-display = {
          criteria = "'Hewlett Packard HP 2210 CNT023F556'";
          mode = "1920x1080";
          scale = 1.0;
        };
        virtual-display = {
          criteria = "'Virtual-1'";
          mode = "1440x900";
        };
        mvWorkspace = ws: criteria:
          "${pkgs.sway}/bin/swaymsg workspace ${ws}, move workspace to output '\"${criteria}\"'";
      in
      {
      framework = {
        outputs = [
          { criteria = fd.criteria; mode = fd.mode; scale = fd.scale; }
        ];
      };
      framework-docked-home = {
        exec = [
          (mvWorkspace "'1:music'" fd.criteria)
          (mvWorkspace "'2:docs'" vs-g.criteria)
          (mvWorkspace "'3:term'" vs-g.criteria)
          (mvWorkspace "4" vs-g.criteria)
          (mvWorkspace "5" vs-g.criteria)
          (mvWorkspace "6" vs-g.criteria)
          (mvWorkspace "'7:code'" vs-n.criteria)
          (mvWorkspace "8" vs-n.criteria)
          (mvWorkspace "9" vs-n.criteria)
          (mvWorkspace "'10:web'" vs-n.criteria)
        ];
        outputs = [
          {
            criteria = vs-g.criteria; mode = vs-g.mode; scale = vs-g.scale;
            position = "0,0";
          }
          {
            criteria = fd.criteria; mode = fd.mode; scale = fd.scale;
            position = "1920,0";
          }
          {
            criteria = vs-n.criteria; mode = vs-n.mode; scale = vs-n.scale;
            position = "3484,0";
          }
        ];
      };
      framework-docked-wasatch = {
        outputs = [
          {
            criteria = fd.criteria; mode = fd.mode; scale = fd.scale;
            position = "1920,0";
          }
          {
            criteria = wasatch-display.criteria; mode = wasatch-display.mode; scale = wasatch-display.scale;
            position = "0,0";
          }
        ];
      };
      thinkpad = {
        outputs = [
          {
            criteria = "LVDS-2";
            mode = "1365x768";
            position = "-1,312";
          }
        ];
      };
      thinkpad-docked = {
        outputs = [
          {
            criteria = "LVDS-2";
            mode = "1365x768";
            position = "-1,312";
          }
          {
            criteria = "HDMI-A-2";
            mode = "1919x1080";
            position = "1365,0";
          }
        ];
      };
    };
  };

  services.mpris-proxy.enable = true;
  services.swayidle.enable = true;

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 12;
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
