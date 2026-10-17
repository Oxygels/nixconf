{ ... }:
{
  home.stateVersion = "26.05";

  imports = [
    ./lf.nix
    ./lazyvim.nix
    ./fish.nix
    ./git.nix
    ./vars.nix
    ./btop.nix
    ./claude.nix
    ./packages.nix
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
    };
  };
}
