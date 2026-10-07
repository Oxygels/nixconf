{ ... }:
{
  imports = [
    ./hyprland
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      # ----------------------------------------------------------------------
      # Monitors
      # ----------------------------------------------------------------------
      monitor = [
        {
          output = "HDMI-A-1";
          mode = "1920x1080@100";
          position = "0x0";
          scale = "1";
        }
        {
          output = "DP-2";
          mode = "2560x1440@244";
          position = "1920x0";
          scale = "1";
          bitdepth = 10;
        }
      ];

      # ----------------------------------------------------------------------
      # Gestures
      # ----------------------------------------------------------------------
      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        }
      ];

      # ----------------------------------------------------------------------
      # Workspaces
      # ----------------------------------------------------------------------
      workspace_rule = [
        {
          workspace = "1";
          monitor = "DP-2";
        }
        {
          workspace = "2";
          monitor = "HDMI-A-1";
        }
        {
          workspace = "3";
          monitor = "DP-2";
        }
        {
          workspace = "4";
          monitor = "DP-2";
        }
        {
          workspace = "5";
          monitor = "DP-2";
        }
        {
          workspace = "6";
          monitor = "DP-2";
        }
      ];
    };
  };
}
