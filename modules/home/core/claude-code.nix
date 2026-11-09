{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code;
    context = ./claude/CLAUDE.md;
    settings = {
      model = "sonnet";
      advisorModel = "opus";
      effortLevel = "medium";
      preferredNotifChannel = "notifications_disabled";
    };
  };
}
