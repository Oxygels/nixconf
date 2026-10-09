{
  pkgs,
  lazyvim,
  ...
}:
{
  home.stateVersion = "26.05";

  imports = [
    lazyvim.homeManagerModules.default
  ];

  home.packages = [ pkgs.nvtopPackages.full ];

  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = "eDP-1";
      mode = "preferred";
      position = "0x0";
      scale = "1";
    }
  ];

  programs.lazyvim = {
    enable = true;
    # Optional: enable LazyVim's Nix support
    extras.lang.nix.enable = true;
  };

}
