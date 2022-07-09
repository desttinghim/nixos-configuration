{
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
}
