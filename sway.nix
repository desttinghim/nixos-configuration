{ config, pkgs, fetchurl, ... }:

let 
  colorScheme = import ../../../color-schemes/campbell.nix;
  background = ../../../backgrounds/ferris-tux-nix-systemd.png;

  modifier = "Mod4";
  left = "h";
  down = "k";
  up = "k";
  right = "l";
  resizeAmount = "30px";
  menu = "dmenu-wl_run -i";
  filebrowser = "thunar";
  webbrowser = "qutebrowser";
  webbrowserPersistent = "firefox";
  # musicplayer = "";
in {
  home = {
    file {
      "./config/sway/background.png".source = background;
      "./config/sway/idle.sh".source = ./idle.sh;
      "./config/sway/drive-mount.sh".source = ./drive-mount.sh;
      "./config/sway/drive-unmount.sh".source = ./drive-unmount.sh;
      "./config/sway/screenshot.sh".source = ./screenshot.sh;
      "./config/sway/lock.sh".source = ./lock.sh;
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    config = {
      floating.border = 1;
      window.border = 1;
      bars = [ ];
      colors = {
        focused = {
          background = colorScheme.green;
          border = colorScheme.greenBright;
          childBorder = colorScheme.green;
          indicator = colorScheme.green;
          text = colorScheme.black;
        };
        focusedInactive = {};
        unfocused = {};
        urgent = {};
        background = colorScheme.black;
      };
      fonts = {
        names = [ "Roboto" ];
        style = "Regular Bold";
        size = 12.0;
      };
      # input = {
      #   "*" = {
      #     xkb_layout = "en";
      #   };
      # };
      menu = menu;
      modifier = modifier;
      up = up;
      left = left;
      down = down;
      right = right;
      keybindings = {
        # Exit sway (logs you out of your Wayland session)
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        # Reload the configuration file
        # Kill focused window
        # Launch the default terminal $TERM is defined in ../alacritty.nix:11
        "${modifier}+x" = "exec kitty";
        # Take a screenshot by selecting an area
        # Toggle deafen
        # Toggle mute
        # Raise sink (speaker, headphones) volume
        # Lower sink (microphone) volume
        # Media controls

        # Moving around
        ## Move your focus around
        ### With arrow keys
        ## Move the focused window with the same, but add Shift
        ### With arrow keys

        # Workspaces
        ## Switch to workspace
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        ## Move focused container to workspace
        "${modifier}+Shift+1" = "workspace number 1";
        "${modifier}+Shift+2" = "workspace number 2";
        "${modifier}+Shift+3" = "workspace number 3";
        "${modifier}+Shift+4" = "workspace number 4";
        "${modifier}+Shift+5" = "workspace number 5";
        "${modifier}+Shift+6" = "workspace number 6";
        "${modifier}+Shift+7" = "workspace number 7";
        "${modifier}+Shift+8" = "workspace number 8";
        "${modifier}+Shift+9" = "workspace number 9";
        "${modifier}+Shift+0" = "workspace number 10";

        # Layout stuff
        ##
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        ##
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        ##
        "${modifier}+f" = "fullscreen";
        ## Swap focus between the tiling area and the floating area
        ## Move focus to the parent container

        # Scratchpad
        ## Move the currently focused window to the scratchpad
        ## Show the next scratchpad window or hide the focused scratchpad window. If there are multiple scratchpad windows, this command cycles through them.
        ## Resizing containers
        ## Mode "resize"
      };
      modes = {
        resize = {};
      };
      startup = [
        { command = "waybar"; }
        { command = "mako"; }
        { command = "/run/current-system/sw/libexec-polkit-gnome-authentication-agent-1"; }
        { command = "$HOME/.config/sway/idle.sh"; }
      ];
      terminal = pkgs.alacritty;
      window.titlebar = false;
      workspaceAutoBackAndForth = true;
      output = {
        "*" = { bg = "${background} fit #1d2021"; };
        # Put displays here
      };
    };
  };
  home.packages = with pkgs; [
    waybar dmenu-wayland ulauncher wofi wofi-emoji slurp grim swappy swaylock-effects notify-desktop mako libappindicator gnome.zenity
  ];
} 

