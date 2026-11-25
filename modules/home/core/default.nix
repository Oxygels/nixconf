{ ... }:
{
  home.stateVersion = "26.05";

  imports = [
    ./lf.nix
    ./neovim.nix
    ./fish.nix
    ./git.nix
    ./vars.nix
    ./btop.nix
    ./packages.nix
    ./ssh.nix
    ./opencode.nix
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
    };
  };
}
