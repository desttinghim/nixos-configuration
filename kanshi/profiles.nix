# Takes a pkgs argument. Use as follows: `(import ./kanshi/profiles.nix pkgs)`
# This is needed so sway can be called.
pkgs:
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
}
