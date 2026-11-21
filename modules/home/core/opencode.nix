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

  xdg.configFile."opencode/AGENTS.md".source = ./opencode/AGENTS.md;
}
