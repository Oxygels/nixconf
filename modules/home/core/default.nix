{ lazyvim, ... }:
{
  home.stateVersion = "26.05";

  imports = [
    lazyvim.homeManagerModules.default
    ./lf.nix
    ./fish.nix
    ./git.nix
    ./vars.nix
    ./btop.nix
    ./claude.nix
    ./packages.nix
  ];

  programs.lazyvim = {
    enable = true;
    # Optional: enable LazyVim's Nix support
    extras.lang.nix.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
    };
  };
}
