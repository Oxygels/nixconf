{ pkgs, ... }:
{
  home.stateVersion = "26.05";

  home.packages = [ pkgs.nvtopPackages.amd ];

  # Disable subpixel rendering for the OLED screen
  fonts.fontconfig = {
    enable = true;
    subpixelRendering = "none";
  };

  # ----------------------------------------------------------------------
  # Hyprland Monitors
  # ----------------------------------------------------------------------
  wayland.windowManager.hyprland.settings = {
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
}
