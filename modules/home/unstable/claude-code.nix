{ unstable, ... }:
{
  programs.claude-code = {
    enable = true;
    # Pinned nixpkgs lags the fast-moving claude-code releases; pull the
    # package from unstable to stay current.
    package = unstable.claude-code;
    context = ./claude/CLAUDE.md;
    settings = {
      model = "sonnet";
      advisorModel = "opus";
      effortLevel = "medium";
      preferredNotifChannel = "notifications_disabled";
    };
  };
}
