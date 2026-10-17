{ ... }:
{
  programs.claude-code = {
    enable = true;
    context = ./claude/CLAUDE.md;
    settings = {
      model = "sonnet";
      advisorModel = "opus";
      effortLevel = "medium";
      preferredNotifChannel = "notifications_disabled";
    };
  };
}
