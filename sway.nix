options:
{ config, pkgs, fetchurl, ... }:

let 
  # background = null;

  # Mod4 for Super
  # Mod1 for Alt
  modifier = options.modifier or "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  resizeAmount = "10px";
  menu = options.menu or "wofi --show=drun --lines=5 --prompt=''";
  terminal = options.terminal or "foot";
in {
  home = {
    packages = with pkgs; [
      waybar
      wofi
      wofi-emoji
      slurp
      grim
      swappy
      swaylock-effects
      notify-desktop
      mako
      libappindicator
      gnome.zenity
      kanshi
      wl-clipboard
      polkit_gnome
      playerctl
      pulseaudio
    ];
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
        "${modifier}+Return" = "exec ${terminal}";
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
        # { command = "waybar"; }
        { command = "mako"; }
        { command = "dbus-sway-environment"; }
        { command = "configure-gtk"; }
        { command = "wl-paste -t text --watch ${pkgs.clipman}/bin/clipman store --no-persist"; }
        { command = "/run/current-system/sw/libexec-polkit-gnome-authentication-agent-1"; }
        # { command = "systemctl --user restart kanshi"; }
        # { command = "systemctl --user import-environment; systemctl --user start sway-session.target"; }
        # { command = "$HOME/.config/sway/idle.sh"; }
      ];
      terminal = pkgs.foot;
      window.titlebar = false;
    };
  };
} 

