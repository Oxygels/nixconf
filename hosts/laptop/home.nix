{ pkgs, ... }:
{
  home.packages = [ pkgs.nvtopPackages.full ];

  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = "eDP-1";
      mode = "preferred";
      position = "0x0";
      scale = "1";
    }
  ];
}
