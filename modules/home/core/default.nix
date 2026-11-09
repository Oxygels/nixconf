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
    ./packages.nix
    ./ssh.nix
    ./claude-code.nix
    ./opencode.nix
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
    };
  };
}
