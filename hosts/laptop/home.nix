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

  programs.lazyvim = {
    enable = true;
    # Optional: enable LazyVim's Nix support
    extras.lang.nix.enable = true;
  };

}
