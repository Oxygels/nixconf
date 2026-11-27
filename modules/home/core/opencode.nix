{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    context = ./opencode/AGENTS.md;
    cli = {
      session.sidebar = "auto";
      theme.name = "catppuccin";
      diffs.source = "turn";
    };
  };
}
