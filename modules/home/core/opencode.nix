{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    cli = {
      session.sidebar = "auto";
      theme.name = "catppuccin";
    };
  };
}
